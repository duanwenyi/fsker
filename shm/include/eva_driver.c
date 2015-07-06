#include <string.h>
#include <pthread.h>
#include "eva_driver.h"

static EVA_BUS_ST_p eva_t = NULL;
pthread_t eva_axi_wr,eva_axi_rd;
pthread_t eva_intr;

#define EVA_SAFE_MODE
//#define EVA_DEBUG

EVA_INTR_REG_t intr_reg;

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
  uint32_t *ptr;
  while(1){
    if(eva_t->axi_w_sync == EVA_SYNC){
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
	  *ptr = eva_t->axi_w_data0;
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
void *eva_interrupt_handler(void *){
#else
void eva_interrupt_handler(void){
#endif
  memset(&intr_reg, sizeof(EVA_INTR_REG_t) , 0);
  
  int  cc = 0;
  while(1){
    if(eva_t->intr != 0){
      fprintf(stderr, " @EVA recieved interrupt : %x  INT MASK[%d %d %d %d - %d %d %d %d]\n", 
	      eva_t->intr, 
	      intr_reg.valid[7],intr_reg.valid[6],intr_reg.valid[5],intr_reg.valid[4],
	      intr_reg.valid[3],intr_reg.valid[2],intr_reg.valid[1],intr_reg.valid[0]
	      ); 
      for( cc=0; cc<8; cc++){
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

int eva_intr_register(void (*user_func)(), int intr_id){
  if(intr_reg.valid[intr_id] == 0){
    intr_reg.func[intr_id]  = user_func;
    intr_reg.valid[intr_id] = 1;
    fprintf(stderr, " @EVA intr_register [ID:%d] [BASE:0x%x] is register OK.\n", intr_id, user_func); 
    return 0;
  }else{
    fprintf(stderr, " @EVA intr_register : [ID]:%d have been registered , please choose other ID.\n", intr_id); 
    return 1;
  }

}

void eva_intr_unregister(int intr_id){
    intr_reg.func[intr_id]  = NULL;
    intr_reg.valid[intr_id] = 0;
}

void eva_drv_init(){
  int ret;

  eva_t = (EVA_BUS_ST_t *)eva_map(0);
  if( eva_t->control != EVA_BUS_INIT){
    fprintf(stderr, " @EVA HDL is not detected start first , exit .\n");  
    exit(EXIT_FAILURE);  
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
#endif

  fprintf(stderr, " @EVA SW initial OVER @0x%8x\n",(uint32_t)eva_t);  
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
    fprintf(stderr,"OK @wait %s == 0x%x : after %dus\n", path, value, tim);
  }else{
    fprintf(stderr,"OK @wait %s != 0x%x : after %dus\n", path, value, tim);
  }
}
