#include "eva_driver.h"

static EVA_BUS_ST_p eva_t = NULL;
pthread_t eva_axi_wr,eva_axi_rd;

#define EVA_SAFE_MODE
//#define EVA_DEBUG

void eva_cpu_wr(uint32_t addr, uint32_t data){
#ifdef EVA_SAFE_MODE
  while(eva_t->ahb_sync != EVA_SYNC_ACK){
    usleep(1);
  }
#endif
  eva_t->ahb_write = 1;
  eva_t->ahb_addr  = addr;
  eva_t->ahb_data  = data;
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

void eva_axi_rd_handler(void){
  
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

      eva_t->axi_r_sync = EVA_SYNC_ACK;
    }else{
      usleep(1);
    }
  }

}

void eva_axi_wr_handler(void){
  
  uint32_t *ptr;
  while(1){
    if(eva_t->axi_w_sync == EVA_SYNC){
      ptr = (uint32_t *)eva_t->axi_w_addr;
      *ptr = eva_t->axi_w_data0;
      ptr++;
      *ptr = eva_t->axi_w_data1;
      ptr++;
      *ptr = eva_t->axi_w_data2;
      ptr++;
      *ptr = eva_t->axi_w_data3;

      eva_t->axi_r_sync = EVA_SYNC_ACK;
    }else{
      usleep(1);
    }
  }

}

void eva_drv_init(){
  int ret;

  eva_t = eva_map(0);
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
