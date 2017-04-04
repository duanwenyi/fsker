#include <string.h>
#include <pthread.h>
#include "eva_driver.h"

static EVA_BUS_ST_p eva_t = NULL;
pthread_t eva_axi_wr,eva_axi_rd;
pthread_t eva_intr;
pthread_t eva_monitor;

#define EVA_SAFE_MODE
#define EVA_AXI_DEBUG

#define EVA_AHB_DEBUG

//#define EVA_AXI_ADDR_CHECK_R
#define EVA_AXI_ADDR_CHECK_W

EVA_INTR_REG_t intr_reg;

EVA_TC_REG_t  eva_tc;

EVA_MEM_MAG_t eva_mem_mag;

void eva_cpu_wr(uint32_t addr, uint32_t data){
#ifdef EVA_SAFE_MODE
	while(eva_t->slv.sync != EVA_SYNC_ACK){
		EVA_UNIT_DELAY;
	}
#endif

#ifdef EVA_AHB_DEBUG
    eva_msg("%8x -- %8x\n", addr, data);
#endif

	eva_t->slv.write = 1;
	eva_t->slv.addr_l  = addr;
	eva_t->slv.addr_u  = 0;
	eva_t->slv.data_l  = data;
	eva_t->slv.data_u  = 0;
	barrier();
	eva_t->slv.sync  = EVA_SYNC;

	while(eva_t->slv.sync == EVA_SYNC){
		EVA_UNIT_DELAY;
	}

#ifdef EVA_AHB_DEBUG
    eva_msg("%8x -- %8x -- over\n", addr, data);
#endif
}


uint32_t eva_cpu_rd(uint32_t addr){
#ifdef EVA_SAFE_MODE
	while(eva_t->slv.sync != EVA_SYNC_ACK){
		EVA_UNIT_DELAY;
	}
#endif

	eva_t->slv.write = 0;
	eva_t->slv.addr_l  = addr;
	eva_t->slv.addr_u  = 0;
	barrier();
	eva_t->slv.sync  = EVA_SYNC;

	while(eva_t->slv.sync == EVA_SYNC){
		EVA_UNIT_DELAY;
	}
  
#ifdef EVA_AHB_DEBUG
    eva_msg("%8x -- %8x\n", addr, eva_t->slv.data_l);
#endif

	return eva_t->slv.data_l;
}

#ifdef __cplusplus
void *eva_monitor_handler(void *){
#else
void eva_monitor_handler(void){
#endif
    uint64_t local_time = 0;
	
    uint64_t pre_tick = 0;
	
    uint64_t max_rate = 0;
    uint64_t min_rate = 0xFFFFFFFF;
    uint64_t eva_rate = 0;
	
    uint64_t initial = 1;

    uint64_t die_cnt = 0;
    
    char     rota[4] = {'-','\\','|','/'};

    eva_msg(" created !\n");
    while(1){
		
        pre_tick = eva_t->tick;
        sleep(1);
        eva_rate = eva_t->tick - pre_tick;

        if(initial ){
            if(eva_rate != 0){
                max_rate = eva_rate;
                min_rate = eva_rate;
            }
        }
		
        local_time++;
        if(eva_rate > max_rate)
            max_rate = eva_rate;
			
        if( (eva_rate < min_rate)  && 
            (eva_rate !=0 ) &&
            ( (uint64_t)(min_rate - eva_rate) < (eva_rate/4) )  // fix stop action case
            )
            min_rate = eva_rate;

        if(eva_rate ==0){
            die_cnt++;
            if(die_cnt > 30){
                eva_msg( " Simulator seem to be dead! Killing self ...\n");
                usleep(200);
                exit(0);
            }
        }else{
            die_cnt = 0;
        }

        eva_msg( " %llu S (%c) HDL: %llu (CYCLE/S) [MAX/MIN][%llu / %llu] CYCLE/S\r",
                local_time, rota[local_time%4], eva_rate, max_rate,  min_rate);  

        initial = 0;
    }
}


#ifdef __cplusplus
void *eva_axi_rd_handler(void *){
#else
void eva_axi_rd_handler(void){
#endif
	uint32_t *ptr;
    eva_msg(" created !\n");
	while(1){
		if(eva_t->mst_rd.sync == EVA_SYNC){
			uint64_t mst_raddr = GEN_DMA_ADDR64(eva_t->mst_rd.addr_u,eva_t->mst_rd.addr_l);
#ifdef EVA_AXI_ADDR_CHECK_R
            if( eva_mem_access_check_read(mst_raddr, 16) )
                eva_t->control = EVA_BUS_ERROR;
#endif
			ptr = (uint32_t *)mst_raddr;
			eva_t->mst_rd.data_0 = *ptr;
			ptr++;
			eva_t->mst_rd.data_1 = *ptr;
			ptr++;
			eva_t->mst_rd.data_2 = *ptr;
			ptr++;
			eva_t->mst_rd.data_3 = *ptr;

#ifdef EVA_AXI_DEBUG
	eva_msg(" @AXI [R] [ 0x%llu - %08x %08x %08x %08x ] \n",
			mst_raddr,
			eva_t->mst_rd.data_3,
			eva_t->mst_rd.data_2,
			eva_t->mst_rd.data_1,
			eva_t->mst_rd.data_0
			);
#endif
			barrier();
			eva_t->mst_rd.sync = EVA_SYNC_ACK;
		}else{
			EVA_UNIT_DELAY;
		}
	}

#ifdef __cplusplus
  return NULL;
#endif
}

#ifdef __cplusplus
void *eva_axi_wr_handler(void *){
#else
void eva_axi_wr_handler(void){
#endif  
    int error;
    eva_msg(" created !\n");
	while(1){
        error = 0;
		if(eva_t->mst_wr.sync == EVA_SYNC){
			uint64_t mst_waddr = GEN_DMA_ADDR64(eva_t->mst_wr.addr_u,eva_t->mst_wr.addr_l);
#ifdef EVA_AXI_DEBUG
            eva_msg(" @AXI [W] [ 0x%llu - %08x %08x %08x %08x ] - strob: 0x%x \n",
					mst_waddr, 
					eva_t->mst_wr.data_3,
					eva_t->mst_wr.data_2,
					eva_t->mst_wr.data_1,
					eva_t->mst_wr.data_0, eva_t->mst_wr.strb
					);

#endif

            uint32_t * ptr32 = (uint32_t *)mst_waddr;
            uint8_t *  ptr8  = (uint8_t * )mst_waddr;

#ifdef EVA_AXI_ADDR_CHECK_W
            if(eva_t->mst_wr.strb == 0xFFFF){
                error =  eva_mem_access_check_write(mst_waddr, 16);

            }else if(eva_t->mst_wr.strb == 0xFF){
                error = eva_mem_access_check_write(mst_waddr, 8);
            }else{
                uint32_t header_ofst = 0;
                uint32_t bits_sum    = 16;
                while( header_ofst  < 16 ){
                    if(eva_t->mst_wr.strb & (1 << header_ofst)){
                        break;
                    }else{
                        bits_sum--;
                    }
                    header_ofst++;
                }

                int cc = 15;
                if(bits_sum > 0 ){
                    while( cc > 0 ){
                        if(eva_t->mst_wr.strb & (1 << cc)){
                            break;
                        }else{
                            bits_sum--;
                        }
                        cc--;
                    }
                }
                
                if(bits_sum > 0)
                    error = eva_mem_access_check_write(mst_waddr + header_ofst, bits_sum);
            }

            if(error){
                eva_msg(" @AXI [W] overflow detected !\n");
                eva_t->sync.sw = EVA_ERR;
            }else{
#endif

                if( (eva_t->mst_wr.strb & 0xF) == 0xF){
                    ptr32[0] = eva_t->mst_wr.data_0;
                }else if( (eva_t->mst_wr.strb & 0xF) != 0x0){
                    if( eva_t->mst_wr.strb & 0x1 )
                        ptr8[0] = eva_t->mst_wr.data_0 & 0xF;
                    if( eva_t->mst_wr.strb & 0x2 )
                        ptr8[1] = (eva_t->mst_wr.data_0 >> 8) & 0xF;
                    if( eva_t->mst_wr.strb & 0x4 )
                        ptr8[1] = (eva_t->mst_wr.data_0 >> 16) & 0xF;
                    if( eva_t->mst_wr.strb & 0x8 )
                        ptr8[3] = (eva_t->mst_wr.data_0 >> 24) & 0xF;
                }

                if( (eva_t->mst_wr.strb & 0xF0) == 0xF0){
                    ptr32[1] = eva_t->mst_wr.data_1;
                }else if( (eva_t->mst_wr.strb & 0xF0) != 0x0){
                    if( eva_t->mst_wr.strb & 0x10 )
                        ptr8[4+0] = eva_t->mst_wr.data_1 & 0xF;
                    if( eva_t->mst_wr.strb & 0x20 )
                        ptr8[4+1] = (eva_t->mst_wr.data_1 >> 8) & 0xF;
                    if( eva_t->mst_wr.strb & 0x40 )
                        ptr8[4+1] = (eva_t->mst_wr.data_1 >> 16) & 0xF;
                    if( eva_t->mst_wr.strb & 0x80 )
                        ptr8[4+3] = (eva_t->mst_wr.data_1 >> 24) & 0xF;
                }

                if( (eva_t->mst_wr.strb & 0xF00) == 0xF00){
                    ptr32[2] = eva_t->mst_wr.data_2;
                }else if( (eva_t->mst_wr.strb & 0xF00) != 0x0){
                    if( eva_t->mst_wr.strb & 0x100 )
                        ptr8[8+0] = eva_t->mst_wr.data_2 & 0xF;
                    if( eva_t->mst_wr.strb & 0x200 )
                        ptr8[8+1] = (eva_t->mst_wr.data_2 >> 8) & 0xF;
                    if( eva_t->mst_wr.strb & 0x400 )
                        ptr8[8+1] = (eva_t->mst_wr.data_2 >> 16) & 0xF;
                    if( eva_t->mst_wr.strb & 0x800 )
                        ptr8[8+3] = (eva_t->mst_wr.data_2 >> 24) & 0xF;
                }

                if( (eva_t->mst_wr.strb & 0xF000) == 0xF000){
                    ptr32[3] = eva_t->mst_wr.data_3;
                }else if( (eva_t->mst_wr.strb & 0xF000) != 0x0){
                    if( eva_t->mst_wr.strb & 0x1000 )
                        ptr8[12+0] = eva_t->mst_wr.data_3 & 0xF;
                    if( eva_t->mst_wr.strb & 0x2000 )
                        ptr8[12+1] = (eva_t->mst_wr.data_3 >> 8) & 0xF;
                    if( eva_t->mst_wr.strb & 0x4000 )
                        ptr8[12+1] = (eva_t->mst_wr.data_3 >> 16) & 0xF;
                    if( eva_t->mst_wr.strb & 0x8000 )
                        ptr8[12+3] = (eva_t->mst_wr.data_3 >> 24) & 0xF;
                }

#ifdef EVA_AXI_ADDR_CHECK_W
            }
#endif
			barrier();
			eva_t->mst_wr.sync = EVA_SYNC_ACK;
		}else{
			EVA_UNIT_DELAY;
		}
	}

#ifdef __cplusplus
  return NULL;
#endif
}

#ifdef __cplusplus
void *eva_interrupt_handler(void *){
#else
void eva_interrupt_handler(void){
#endif
	int  cc = 0;
    eva_msg(" created !\n");
	while(1){
		if( (intr_reg.valid_bits != 0) && (eva_t->intx.intx != 0)){
			eva_msg( " @EVA recieved interrupt : 0x%8x    [Local Mask: 0x%8x]\n", eva_t->intx.intx, intr_reg.valid_bits ); 
			for( cc=0; cc<EVA_MAX_INT_NUM; cc++){
				if( intr_reg.valid[cc] == 1){
					if( (eva_t->intx.intx & (1<<cc)) != 0 ){
						// excute registered interrupt function
						(*intr_reg.func[cc])();
	    
						eva_t->intx.intx = eva_t->intx.intx & (~(1<<cc));
					}
				}
			}
		}else{
			EVA_UNIT_DELAY;
		}
	}
  
#ifdef __cplusplus
  return NULL;
#endif
}

 void eva_intr_register(void (*user_func)(), int intr_id){
	 if(intr_id < EVA_MAX_INT_NUM){
		 if(intr_reg.valid[intr_id] == 0){
			 intr_reg.func[intr_id]  = user_func;
			 intr_reg.valid[intr_id] = 1;
			 intr_reg.valid_bits |= (1<< intr_id);
			 eva_msg( " @EVA intrrupt register [ID: %d] [BASE: 0x%llx] is register OK. [0x%x]\n", intr_id, (uint64_t)user_func, intr_reg.valid_bits); 
		 }else{
			 eva_msg( " @EVA intrrupt register : [ID]:%d have been registered , please choose other ID.\n", intr_id); 
		 }
	 }else{
		 eva_msg( " @EVA intrrupt register : [ID]:%d exceed MAX support numbers [%d].\n", intr_id, EVA_MAX_INT_NUM); 
	 }
 }


 void eva_intr_unregister(int intr_id){
	 if(intr_id < EVA_MAX_INT_NUM){
		 intr_reg.func[intr_id]  = NULL;
		 intr_reg.valid[intr_id] = 0;
		 intr_reg.valid_bits &= ~(1<< intr_id);
		 eva_msg( " @EVA intrrupt unregister [ID]:%d . [0x%x]\n", intr_id, intr_reg.valid_bits); 
	 }else{
		 eva_msg( " @EVA intrrupt unregister : [ID]:%d exceed MAX support numbers [%d].\n", intr_id, EVA_MAX_INT_NUM); 
	 }
 }

void eva_drv_init(){
	int ret;
    int en_slv = 0;
    int en_mst = 0;
    int en_int = 0;
    int en_get = 0;

	memset(&intr_reg, 0, sizeof(EVA_INTR_REG_t));
    eva_mem_init();

	eva_t = (EVA_BUS_ST_t *)eva_map(0);

    eva_t->sync.sw = EVA_IDLE;

    do{
        switch(eva_t->sync.dut)
            {
            case EVA_INIT  : {
                barrier();
                eva_t->sync.sw = EVA_INIT;
                break;
            }
            case EVA_RDY  : {
                eva_t->mst_wr.data_0;// *slv_cfg;
                eva_t->mst_wr.data_1;// *mst_cfg;

                eva_msg( " @EVA AHB Slave set Address %d Bits, Data %d Bits.\n", 
                         eva_t->mst_wr.data_0 & 0xFF, (eva_t->mst_wr.data_0 >>8) & 0xFF);  

                eva_msg( " @EVA AXI Write set Address %d Bits, Data %d Bits.\n", 
                         eva_t->mst_wr.data_1 & 0xFF, (eva_t->mst_wr.data_1 >>8) & 0xFF);  

                eva_msg( " @EVA AXI Read  set Address %d Bits, Data %d Bits.\n", 
                         (eva_t->mst_wr.data_1>>16) & 0xFF, (eva_t->mst_wr.data_1 >>24) & 0xFF);  
                
                en_slv = eva_t->mst_rd.data_0;
                en_mst = eva_t->mst_rd.data_1;
                en_int = eva_t->mst_rd.data_2;
                en_get = eva_t->mst_rd.data_3;
                
                eva_msg( " Enable Status : Slave | Master | Interrupt | Get\n");
                eva_msg( "                 %d     | %d      | %d         | %d\n",
                         en_slv, 
                         en_mst, 
                         en_int, 
                         en_get );

                barrier();

                eva_t->sync.sw = EVA_RDY;
                break;
            }
            }

        EVA_UNIT_DELAY;
    }while( eva_t->sync.sw != EVA_RDY);

    eva_msg( " @EVA SW Handshake Over , set ALIVE now.\n");  

    if(en_mst){
        ret = pthread_create(&eva_axi_wr, NULL, 
#ifndef __cplusplus
                             (void *)
#endif
                             eva_axi_wr_handler, NULL);
        if(ret != 0){
            eva_msg( " @EVA SW AXI write thread created failed , exit .\n");  
            exit(EXIT_FAILURE);  
        }
  
        ret = pthread_create(&eva_axi_rd, NULL, 
#ifndef __cplusplus
                             (void *)
#endif
                             eva_axi_rd_handler, NULL);
        if(ret != 0){
            eva_msg( " @EVA SW AXI read  thread created failed , exit .\n");  
            exit(EXIT_FAILURE);  
        }
    }

    if(en_int){
        ret = pthread_create(&eva_intr, NULL, 
#ifndef __cplusplus
                             (void *)
#endif
                             eva_interrupt_handler, NULL);
        if(ret != 0){
            eva_msg( " @EVA SW Interrupt Handle  thread created failed , exit .\n");  
            exit(EXIT_FAILURE);  
        }
    }

    if(en_get){
        
        ret = pthread_create(&eva_monitor, NULL, 
#ifndef __cplusplus
                             (void *)
#endif
                             eva_monitor_handler, NULL);
        if(ret != 0){
            eva_msg( " @EVA SW Monitor Handle  thread created failed , exit .\n");  
            exit(EXIT_FAILURE);  
        }
    }

	eva_msg( " @EVA SW initial OVER @0x%llx\n",(size_t)eva_t);  
    EVA_TC_INIT();
}

void eva_drv_stop(){

  if( eva_t->sync.dut != EVA_RDY){
    eva_msg( " @EVA HDL is not alive when stop , exit .\n");  
    exit(EXIT_FAILURE);  
  }

  eva_t->sync.sw = EVA_STOP;
  eva_msg( " @EVA SW STOP ...\n");  

  while(eva_t->sync.dut != EVA_STOP ){
    EVA_UNIT_DELAY;
  }

  eva_msg( " @EVA HDL STOP ACKED ...\n");  
  eva_destory();
}

 void eva_drv_pause(){

     if( eva_t->sync.dut != EVA_RDY){
         eva_msg( " @EVA HDL is not alive when pause , exit .\n");  
         exit(EXIT_FAILURE);  
     }

	 eva_t->sync.sw = EVA_PAUSE;

	 //while(eva_t->sync.dut != EVA_PAUSE ){
	 //    EVA_UNIT_DELAY;
	 //}

 }

 uint32_t evaGetPro(char *path){
     uint32_t val = 0;
     uint32_t cnt = (strlen(path)+1)/32;
     int      pos = 0;

     eva_t->get.sync = EVA_SOF;

    do{
        switch(eva_t->get.sync)
            {
            case EVA_ACK  : {
                memcpy(eva_t->get.str, path + pos, 32);
                pos += 32;
                barrier();
                if(cnt > 0)
                    cnt--;
                eva_t->get.sync = EVA_SEND_A;
                break;
            }
            case EVA_ACK_A : {
                memcpy(eva_t->get.str, path + pos, 32);
                pos += 32;
                barrier();
                if(cnt > 0){
                    cnt--;
                    eva_t->get.sync = EVA_ACK_A;
                }else{
                    eva_t->get.sync = EVA_EOF;
                }
                break;
            }
            case EVA_ACK_B : {
                memcpy(eva_t->get.str, path + pos, 32);
                pos += 32;
                barrier();
                if(cnt > 0){
                    cnt--;
                    eva_t->get.sync = EVA_ACK_B;
                }else{
                    eva_t->get.sync = EVA_EOF;
                }
                break;
            }
            case EVA_ROK : {
                val = *(int *)eva_t->get.str;

                barrier();
                eva_t->get.sync = EVA_IDLE;
                break;
            }
            }
        
        EVA_UNIT_DELAY;
        
    }while( cnt != 0);

     return val;
 }

 uint32_t evaGet(char *path){
     uint32_t val = evaGetPro(path);
     eva_msg(" %s = 0x%x\n", path, val);
     return val;
 }

 void evaWait(char *path, uint32_t value, uint32_t mode ){
	 /*
	   path like "top.module.wire"
	   value
	   mode : 1: be equal to out  0: be not equal to out
	 */
     int tim = 0;

     uint32_t val = 0;

     while(1){
         val = evaGetPro(path);
         if( ((mode == 1) && (val == value)) ||
             ((mode == 0) && (val != value)) 
             ){
             break;
         }
         EVA_UNIT_DELAY;
         tim++;

     }

	 if(mode == 1){
		 eva_msg(" %s == 0x%x : after %dus @HDL : %llx CYCLE \n", path, value, tim, eva_t->tick);
	 }else{
		 eva_msg(" %s != 0x%x : after %dus @HDL : %llx CYCLE\n", path, value, tim, eva_t->tick);
	 }
 }

 void eva_delay(int cycle){
	 uint64_t mark = eva_t->tick;
	 uint64_t mark2;
	 int grap;
	 do{
		 mark2 = eva_t->tick;
		 grap = mark2 - mark;
		 if(cycle > 20)
			 EVA_UNIT_DELAY;
	 }while( grap < cycle);
  
	 eva_msg(" delayed %d HDL CYCLE [%llx -> %llx]\n", cycle, mark, mark2 );
 }


 void  EVA_TC_INIT(){
     memset(&eva_tc, 0, sizeof(EVA_TC_REG_t));
 }

 void  EVA_TC_REGISTER(void (*func)(), const char *name){
     if(eva_tc.tc_nums < EVA_MAX_TC_NUM){
         eva_tc.tc[eva_tc.tc_nums].func = func;
         strcpy( eva_tc.tc[eva_tc.tc_nums].name , name );
         eva_msg(" @EVA Register TC  %3d) %s \n",  eva_tc.tc_nums, eva_tc.tc[eva_tc.tc_nums].name );
         eva_tc.tc_nums++;
     }
 }

 void  EVA_TC_SHOW_LIST(){
     int cc;
	 eva_msg(" *** EVA TC List *** \n" );
     for(cc=0; cc<eva_tc.tc_nums; cc++){
         eva_msg(" %3d) %s \n",  cc, eva_tc.tc[cc].name );
     }
 }

 char *EVA_TC_GET_NAME_BY_ID(int id){
     if(id < eva_tc.tc_nums){
         return eva_tc.tc[id].name;
     }else{
         return NULL;
     }
 }

 int   EVA_TC_GET_ID_BY_NAME(char *name){
     int cc;

     if(eva_tc.tc_nums > 0){
         for(cc=0; cc<eva_tc.tc_nums; cc++){
             if ( strcmp( eva_tc.tc[cc].name , name) == 0 ){
                 break;
             }
         }
         
         if(cc > eva_tc.tc_nums)
             return -1;
         else
             return cc;

     }else{
         return -1;
     }

 }

 void  EVA_TC_RUN_BY_NAME(char *name){

     int id = EVA_TC_GET_ID_BY_NAME( name );

     if(id != -1){
         eva_msg(" +going TC : %s \n\n", name );
         EVA_TC_RUN_BY_ID(id);
     }else{
         eva_msg(" TC : %s is not found !\n", name );
         EVA_TC_SHOW_LIST();
     }
 }
 
 void  EVA_TC_RUN_BY_ID(int id){
     if(id < eva_tc.tc_nums){
         eva_tc.tc[id].func();
     }
 }

 void* aligned_malloc(size_t size, size_t align)
 {
     void* raw_malloc_ptr;		//初始分配的地址
     void* aligned_ptr;			//最终我们获得的alignment地址
	
     if( align & (align - 1) )	//如果alignment不是2的n次方，返回
         {
             //errno = EINVAL;
             return ( (void*)0 );
         }
	
     if( 0 == size )
         {
             return ( (void*)0 );
         } 
	
     //将alignment置为至少为2*sizeof(void*),一种优化做法。
     if( align < 2*sizeof(void*) )
         {
             align = 2 * sizeof(void*);
         }
	
     raw_malloc_ptr = malloc(size + align);
     if( !raw_malloc_ptr )
         {
             return ( (void*)0 );
         }
	
     //Align  We have at least sizeof (void *) space below malloc'd ptr. 
     aligned_ptr = (void*) ( ((size_t)raw_malloc_ptr + align) & ~((size_t)align - 1));
	
     ( (void**)aligned_ptr )[-1] = raw_malloc_ptr;
	
     return aligned_ptr;
 }

 void aligned_free(void * aligned_ptr)
 {
     if( aligned_ptr )
         {
             free( ((void**)aligned_ptr)[-1] );
         }
 }

 void  eva_mem_init(){
     memset(&eva_mem_mag, 0, sizeof(EVA_MEM_MAG_t));
     eva_msg(" EVA Memory Map List Initialed!\n"); 
 }
 
 int  eva_mem_seek(uint64_t aligned_ptr, uint64_t size){
     int      cc;
     int      index = -1;
     uint64_t new_end = aligned_ptr + size;
     for(cc=0; cc < eva_mem_mag.map_nums; cc++ ){
         if( (aligned_ptr >= eva_mem_mag.map[cc].keypair &&
              aligned_ptr <= eva_mem_mag.map[cc].end) ||
             (new_end >= eva_mem_mag.map[cc].keypair &&
              new_end <= eva_mem_mag.map[cc].end) 
             ){
             index = cc;
             break;
         }
     }
          
     return index;
 }

 void  eva_mem_register(uint64_t aligned_ptr, uint64_t size){
     uint64_t new_end = aligned_ptr + size;

     int index = eva_mem_seek(aligned_ptr, size);

     if(index < 0){
         if(eva_mem_mag.map_nums < EVA_MAX_MAP_NUM){
             eva_mem_mag.map[eva_mem_mag.map_nums].keypair = aligned_ptr;
             eva_mem_mag.map[eva_mem_mag.map_nums].end = new_end;
             eva_mem_mag.map_nums++;
         }else{
             eva_msg(" Error: eva_malloc exceed EVA_MAX_MAP_NUM %d ! change EVA_MAX_MAP_NUM bigger!\n", EVA_MAX_MAP_NUM );
         }

     }else{
         eva_msg(" Warn: eva_malloc overlap detected ! %llx+%llx :: %llx+%llx @item %d\n", 
                 aligned_ptr, size, eva_mem_mag.map[index].keypair, eva_mem_mag.map[index].end, index );
         if( aligned_ptr > eva_mem_mag.map[index].keypair ){
             eva_mem_mag.map[index].keypair = aligned_ptr;
         }
         
         if( new_end > eva_mem_mag.map[index].end ){
             eva_mem_mag.map[index].end = new_end;
         }

         
     }
 }

 int  eva_mem_access_check(uint64_t aligned_ptr, uint64_t size, int dir){
     int      index = eva_mem_seek(aligned_ptr, size);
     uint64_t new_end = aligned_ptr + size;
     int      error = 0;
     if(index < 0){
         eva_msg(" Error: [%s]: illige address access [0x%llx + %llx]! \n", dir ? "W" : "R", aligned_ptr, size );
         error = 1;
     }else{
         if( (aligned_ptr < eva_mem_mag.map[index].keypair &&
              new_end     > eva_mem_mag.map[index].end) ){
             eva_msg(" Error: [%s]: illige address boundary access [0x%llx + %llx] :: [0x%llx + %llx] !\n", 
                     dir ? "W" : "R", aligned_ptr, size, eva_mem_mag.map[index].keypair, eva_mem_mag.map[index].end
                     );
             error = 1;
         }else{
             if(dir == 1){ // write
                 eva_mem_mag.cache_wr.keypair = eva_mem_mag.map[index].keypair;
                 eva_mem_mag.cache_wr.end     = eva_mem_mag.map[index].end;
             }else{
                 eva_mem_mag.cache_rd.keypair = eva_mem_mag.map[index].keypair;
                 eva_mem_mag.cache_rd.end     = eva_mem_mag.map[index].end;
             }
         }
     }

     return error;
 }

 int  eva_mem_access_check_write(uint64_t aligned_ptr, uint64_t size){
     int      error = 0;
     uint64_t new_end = aligned_ptr + size;
     
     if( !(aligned_ptr >= eva_mem_mag.cache_wr.keypair &&
           new_end     <= eva_mem_mag.cache_wr.end) ){
         if( eva_mem_access_check(aligned_ptr, size, 1) == 1 ){
             error = 1;
         }
     }
     
     return error;
 }

 int  eva_mem_access_check_read(uint64_t aligned_ptr, uint64_t size){
     int      error = 0;
     uint64_t new_end = aligned_ptr + size;
     
     if( !(aligned_ptr >= eva_mem_mag.cache_rd.keypair &&
           new_end     <= eva_mem_mag.cache_rd.end) ){
         if( eva_mem_access_check(aligned_ptr, size, 0) == 1 ){
             error = 1;
         }
     }
     
     return error;
 }

 void  eva_mem_list_show(){
     int cc;
     fprintf(stderr," *** EVA MEMORY MAP LIST ***\n");
     for(cc=0; cc < eva_mem_mag.map_nums; cc++ ){
         fprintf(stderr," %3d): [0x%llx -> 0x%llx] :: %llu bytes\n", 
                 cc, eva_mem_mag.map[cc].keypair, eva_mem_mag.map[cc].end,
                 eva_mem_mag.map[cc].end - eva_mem_mag.map[cc].keypair
                 );
     }
     fprintf(stderr,"\n");
 }

 void* eva_malloc(size_t size, size_t align){
     void*    aligned_ptr = aligned_malloc( size, align);
     uint64_t aligned_ptr_base = (uint64_t) aligned_ptr;
     
     eva_mem_register(aligned_ptr_base, size );

     return aligned_ptr;
 }

 void  eva_mem_map(uint64_t aligned_ptr, uint64_t size){
     eva_mem_register(aligned_ptr, size );
 }

 void eva_free(void * aligned_ptr){
     aligned_free( aligned_ptr );
 }
