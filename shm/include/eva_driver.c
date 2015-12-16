#include <string.h>
#include <pthread.h>
#include "eva_driver.h"

static EVA_BUS_ST_p eva_t = NULL;
pthread_t eva_axi_wr,eva_axi_rd;
pthread_t eva_intr;
pthread_t eva_monitor;

#define EVA_SAFE_MODE
//#define EVA_DEBUG
//#define EVA_AXI_DEBUG

EVA_INTR_REG_t intr_reg;

EVA_TC_REG_t eva_tc;

void eva_cpu_wr(uint32_t addr, uint32_t data){
#ifdef EVA_SAFE_MODE
	while(eva_t->ahb_sync != EVA_SYNC_ACK){
		usleep(1);
	}
#endif
	eva_t->ahb_write = 1;
	eva_t->ahb_addr  = addr;
	eva_t->ahb_data  = data;
	barrier();
	eva_t->ahb_sync  = EVA_SYNC;
#ifdef EVA_DEBUG
	fprintf(stderr," @AHB write addr: 0x%8x  data: 0x%8x\n",eva_t->ahb_addr, eva_t->ahb_data );
#endif
	while(eva_t->ahb_sync == EVA_SYNC){
		usleep(1);
	}
#ifdef EVA_DEBUG
	fprintf(stderr," @AHB write addr: 0x%8x  data: 0x%8x OK\n",eva_t->ahb_addr, eva_t->ahb_data );
#endif
}


uint32_t eva_cpu_rd(uint32_t addr){
#ifdef EVA_SAFE_MODE
	while(eva_t->ahb_sync != EVA_SYNC_ACK){
		usleep(1);
	}
#endif
	eva_t->ahb_write = 0;
	eva_t->ahb_addr  = addr;
	barrier();
	eva_t->ahb_sync  = EVA_SYNC;

#ifdef EVA_DEBUG
	fprintf(stderr," @AHB read addr: 0x%8x \n",eva_t->ahb_addr );
#endif

	while(eva_t->ahb_sync == EVA_SYNC){
		usleep(1);
	}
#ifdef EVA_DEBUG
	fprintf(stderr," @AHB read addr: 0x%8x  data: 0x%8x OK\n",eva_t->ahb_addr, eva_t->ahb_data );
#endif
  
	return eva_t->ahb_data;
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
                fprintf(stderr, "\n @EVA Monitor: Simulator seem to be dead! Killing self ...\n");
                usleep(200);
                exit(0);
            }
        }else{
            die_cnt = 0;
        }

        fprintf(stderr, " @EVA Monitor: %llu S %c HDL: 0x%llu CYCLE  --> %llu (CYCLE/S) [MAX/MIN][%llu / %llu] CYCLE/S\r",
                local_time, rota[local_time%4], eva_t->tick, eva_rate, max_rate,  min_rate);  

        initial = 0;
    }
}


#ifdef __cplusplus
void *eva_axi_rd_handler(void *){
#else
void eva_axi_rd_handler(void){
#endif
  
	uint32_t *ptr;
	while(1){
		if(eva_t->axi_r_sync == EVA_SYNC){
			ptr = (uint32_t *)eva_t->axi_r_addr;
			eva_t->axi_r_data0 = *ptr;
			ptr++;
			eva_t->axi_r_data1 = *ptr;
			ptr++;
			eva_t->axi_r_data2 = *ptr;
			ptr++;
			eva_t->axi_r_data3 = *ptr;

#ifdef EVA_AXI_DEBUG
	fprintf(stderr," @AXI [R] addr: 0x%llu - data: %8x %8x %8x %8x \n",
			eva_t->axi_r_addr,
			eva_t->axi_r_data0,
			eva_t->axi_r_data1,
			eva_t->axi_r_data2,
			eva_t->axi_r_data3
			);
#endif
			barrier();
			eva_t->axi_r_sync = EVA_SYNC_ACK;
		}else{
			usleep(1);
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
	while(1){
		if(eva_t->axi_w_sync == EVA_SYNC){
#ifdef EVA_AXI_DEBUG
			fprintf(stderr," @AXI [W] addr: 0x%llu  strob: 0x%x - data: 0x%8x 0x%8x 0x%8x 0x%8x \n",
					eva_t->axi_w_addr, eva_t->axi_w_strb,
					eva_t->axi_w_data3,
					eva_t->axi_w_data2,
					eva_t->axi_w_data1,
					eva_t->axi_w_data0
					);
#endif
			if(eva_t->axi_w_strb == 0xFFFF){
				uint32_t * ptr = (uint32_t *)eva_t->axi_w_addr;
				*ptr = eva_t->axi_w_data0;
				ptr++;
				*ptr = eva_t->axi_w_data1;
				ptr++;
				*ptr = eva_t->axi_w_data2;
				ptr++;
				*ptr = eva_t->axi_w_data3;
	
			}else if(eva_t->axi_w_strb == 0xFF){
				uint32_t * ptr = (uint32_t *)eva_t->axi_w_addr;
				*ptr = eva_t->axi_w_data0;
				ptr++;
				*ptr = eva_t->axi_w_data1;
			}else{
				uint8_t * ptr = (uint8_t *)eva_t->axi_w_addr;
				// DW0
				if( eva_t->axi_w_strb & 0x1 )
					*ptr = eva_t->axi_w_data0 & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x2 )
					*ptr = (eva_t->axi_w_data0 >> 8 ) & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x4 )
					*ptr = (eva_t->axi_w_data0 >> 16 ) & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x8 )
					*ptr = (eva_t->axi_w_data0 >> 24 ) & 0xFF;
				ptr++;
				// DW1
				if( eva_t->axi_w_strb & 0x10 )
					*ptr = (eva_t->axi_w_data1 ) & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x20 )
					*ptr = (eva_t->axi_w_data1 >> 8 ) & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x40 )
					*ptr = (eva_t->axi_w_data1 >> 16 ) & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x80 )
					*ptr = (eva_t->axi_w_data1 >> 24 ) & 0xFF;
				ptr++;
				// DW2
				if( eva_t->axi_w_strb & 0x100 )
					*ptr = (eva_t->axi_w_data2 ) & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x200 )
					*ptr = (eva_t->axi_w_data2 >> 8 ) & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x400 )
					*ptr = (eva_t->axi_w_data2 >> 16 ) & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x800 )
					*ptr = (eva_t->axi_w_data2 >> 24 ) & 0xFF;
				ptr++;
				// DW3
				if( eva_t->axi_w_strb & 0x1000 )
					*ptr = (eva_t->axi_w_data3 ) & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x2000 )
					*ptr = (eva_t->axi_w_data3 >> 8 ) & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x4000 )
					*ptr = (eva_t->axi_w_data3 >> 16 ) & 0xFF;
				ptr++;
				if( eva_t->axi_w_strb & 0x8000 )
					*ptr = (eva_t->axi_w_data3 >> 24 ) & 0xFF;
				ptr++;
			}

			barrier();
			eva_t->axi_w_sync = EVA_SYNC_ACK;
		}else{
			usleep(1);
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
	while(1){
		if( (intr_reg.valid_bits != 0) && (eva_t->intr != 0)){
			fprintf(stderr, " @EVA recieved interrupt : 0x%8x    [Local Mask: 0x%8x]\n", eva_t->intr, intr_reg.valid_bits ); 
			for( cc=0; cc<EVA_MAX_INT_NUM; cc++){
				if( intr_reg.valid[cc] == 1){
					if( (eva_t->intr & (1<<cc)) != 0 ){
						// excute registered interrupt function
						(*intr_reg.func[cc])();
	    
						eva_t->intr = eva_t->intr & (~(1<<cc));
					}
				}
			}
		}else{
			usleep(1);
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
			 fprintf(stderr, " @EVA intrrupt register [ID: %d] [BASE: 0x%llu] is register OK. [0x%x]\n", intr_id, (uint64_t)user_func, intr_reg.valid_bits); 
		 }else{
			 fprintf(stderr, " @EVA intrrupt register : [ID]:%d have been registered , please choose other ID.\n", intr_id); 
		 }
	 }else{
		 fprintf(stderr, " @EVA intrrupt register : [ID]:%d exceed MAX support numbers [%d].\n", intr_id, EVA_MAX_INT_NUM); 
	 }
 }


 void eva_intr_unregister(int intr_id){
	 if(intr_id < EVA_MAX_INT_NUM){
		 intr_reg.func[intr_id]  = NULL;
		 intr_reg.valid[intr_id] = 0;
		 intr_reg.valid_bits &= ~(1<< intr_id);
		 fprintf(stderr, " @EVA intrrupt unregister [ID]:%d . [0x%x]\n", intr_id, intr_reg.valid_bits); 
	 }else{
		 fprintf(stderr, " @EVA intrrupt unregister : [ID]:%d exceed MAX support numbers [%d].\n", intr_id, EVA_MAX_INT_NUM); 
	 }
 }

void eva_drv_init(){
	int ret;
	memset(&intr_reg, 0, sizeof(EVA_INTR_REG_t));

	eva_t = (EVA_BUS_ST_t *)eva_map(0);
	if( eva_t->control != EVA_BUS_INIT){
		fprintf(stderr, " @EVA HDL is not detected start first , waiting ....\n");  
		while(eva_t->control != EVA_BUS_INIT ){
			usleep(1);
		}
		//exit(EXIT_FAILURE);  
	}
  
	eva_t->control = EVA_BUS_ACK;

	while(eva_t->control == EVA_BUS_ACK ){
		usleep(1);
	}
  
	if( eva_t->control != EVA_BUS_ALIVE){
		fprintf(stderr, " @EVA HDL is not response correct, exit .\n");  
		exit(EXIT_FAILURE);  
	}else{
		fprintf(stderr, " @EVA HDL Handshake Over , set ALIVE OK.\n");  
	}

#ifdef __cplusplus
	ret = pthread_create(&eva_axi_wr, NULL, eva_axi_wr_handler, NULL);
	if(ret != 0){
		fprintf(stderr, " @EVA SW AXI write thread created failed , exit .\n");  
		exit(EXIT_FAILURE);  
	}
  
	ret = pthread_create(&eva_axi_rd, NULL, eva_axi_rd_handler, NULL);
	if(ret != 0){
		fprintf(stderr, " @EVA SW AXI read  thread created failed , exit .\n");  
		exit(EXIT_FAILURE);  
	}

	ret = pthread_create(&eva_intr, NULL, eva_interrupt_handler, NULL);
	if(ret != 0){
		fprintf(stderr, " @EVA SW Interrupt Handle  thread created failed , exit .\n");  
		exit(EXIT_FAILURE);  
	}

	ret = pthread_create(&eva_monitor, NULL, eva_monitor_handler, NULL);
	if(ret != 0){
		fprintf(stderr, " @EVA SW Monitor Handle  thread created failed , exit .\n");  
		exit(EXIT_FAILURE);  
	}
#else

	ret = pthread_create(&eva_axi_wr, NULL, (void *)eva_axi_wr_handler, NULL);
	if(ret != 0){
		fprintf(stderr, " @EVA SW AXI write thread created failed , exit .\n");  
		exit(EXIT_FAILURE);  
	}
  
	ret = pthread_create(&eva_axi_rd, NULL, (void *)eva_axi_rd_handler, NULL);
	if(ret != 0){
		fprintf(stderr, " @EVA SW AXI read  thread created failed , exit .\n");  
		exit(EXIT_FAILURE);  
	}

	ret = pthread_create(&eva_intr, NULL, (void *)eva_interrupt_handler, NULL);
	if(ret != 0){
		fprintf(stderr, " @EVA SW Interrupt Handle  thread created failed , exit .\n");  
		exit(EXIT_FAILURE);  
	}

	ret = pthread_create(&eva_monitor, NULL, (void *)eva_monitor_handler, NULL);
	if(ret != 0){
		fprintf(stderr, " @EVA SW Monitor Handle  thread created failed , exit .\n");  
		exit(EXIT_FAILURE);  
	}
#endif

	fprintf(stderr, " @EVA SW initial OVER @0x%llu\n",(size_t)eva_t);  
    EVA_TC_INIT();
}

void eva_drv_stop(){

  if( eva_t->control != EVA_BUS_ALIVE){
    fprintf(stderr, " @EVA HDL is not alive when stop , exit .\n");  
    exit(EXIT_FAILURE);  
  }

  eva_t->control = EVA_BUS_STOP;
  fprintf(stderr, " @EVA SW STOP ...\n");  

  while(eva_t->control == EVA_BUS_STOP ){
    usleep(1);
  }

  fprintf(stderr, " @EVA HDL STOP ACKED ...\n");  
  eva_destory();
}

 void eva_drv_pause(){

	 if( eva_t->control != EVA_BUS_ALIVE){
		 fprintf(stderr, " @EVA HDL is not alive when pause , exit .\n");  
		 exit(EXIT_FAILURE);  
	 }

	 eva_t->control = EVA_BUS_PAUSE;

	 while(eva_t->control == EVA_BUS_PAUSE ){
		 usleep(1);
	 }

 }

 void evaScopeWait(char *path, uint32_t value, uint32_t mode ){
	 /*
	   path like "top.module.wire"
	   value
	   mode : 1: be equal to out  0: be not equal to out
	 */
	 FILE *fp = fopen("./evaScopeGet.txt","w");
	 int   tim = 0;
	 if(fp == NULL){
		 fprintf(stderr, "@evaScopeWait: Open file ./evaScopeGet.txt FAILED !\n");
		 return ;
	 }
	 fprintf(fp,"%s 0x%x %d\n", path, value, mode);
	 fclose(fp);

	 eva_t->resv = eva_t->resv | EVA_WAIT_SYNC_MSK;
  
	 while( ((eva_t->resv & EVA_WAIT_SYNC_MSK) == EVA_WAIT_SYNC_MSK)){
		 usleep(1);
		 tim++;
	 }

	 if(mode == 1){
		 fprintf(stderr,"OK @wait %s == 0x%x : after %dus @HDL : %llu CYCLE\n", path, value, tim, eva_t->tick);
	 }else{
		 fprintf(stderr,"OK @wait %s != 0x%x : after %dus @HDL : %llu CYCLE\n", path, value, tim, eva_t->tick);
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
			 usleep(1);
	 }while( grap < cycle);
  
	 fprintf(stderr," @EVA delayed  %d HDL CYCLE [%llu -> %llu]\n", cycle, mark, mark2 );
 }


 void  EVA_TC_INIT(){
     memset(&eva_tc, 0, sizeof(EVA_TC_REG_t));
 }

 void  EVA_TC_REGISTER(void (*func)(), const char *name){
     if(eva_tc.tc_nums < EVA_MAX_TC_NUM){
         eva_tc.tc[eva_tc.tc_nums].func = func;
         strcpy( eva_tc.tc[eva_tc.tc_nums].name , name );
         fprintf(stderr," @EVA Register TC  %3d) %s \n",  eva_tc.tc_nums, eva_tc.tc[eva_tc.tc_nums].name );
         eva_tc.tc_nums++;
     }
 }

 void  EVA_TC_SHOW_LIST(){
     int cc;
	 fprintf(stderr," *** EVA TC List *** \n" );
     for(cc=0; cc<eva_tc.tc_nums; cc++){
         fprintf(stderr," %3d) %s \n",  cc, eva_tc.tc[cc].name );
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
         EVA_TC_RUN_BY_ID(id);
     }else{
         fprintf(stderr," TC : %s is not found !\n", name );
         EVA_TC_SHOW_LIST();
     }
 }
 
 void  EVA_TC_RUN_BY_ID(int id){
     if(id < eva_tc.tc_nums){
         eva_tc.tc[id].func();
     }
 }
