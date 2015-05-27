#include "eva_driver.h"

EVA_BUS_ST_p eva_t = NULL;
pthread_t eva_axi_wr,eva_axi_rd;

void eva_cpu_wr(uint32_t addr, uint32_t data){
  while(eva_t->ahb_sync != EVA_SYNC_ACK){
    usleep(1);
  }
  eva_t->ahb_write = 1;
  eva_t->ahb_addr  = addr;
  eva_t->ahb_data  = data;
  eva_t->ahb_sync  = 1;

  while(eva_t->ahb_sync == EVA_SYNC){
    usleep(1);
  }
}

uint32_t eva_cpu_rd(uint32_t addr){
  while(eva_t->ahb_sync != EVA_SYNC_ACK){
    usleep(1);
  }
  eva_t->ahb_write = 0;
  eva_t->ahb_addr  = addr;
  eva_t->ahb_sync  = 1;

  while(eva_t->ahb_sync == EVA_SYNC){
    usleep(1);
  }
  
  return eva_t->ahb_data;
}

void eva_axi_rd_handler(void){
  
  uint32_t *ptr;
  while(1){
    if(eva_t->axi_r_sync == EVA_SYNC){
      ptr = (uint32_t *)axi_r_addr;
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
      ptr = (uint32_t *)axi_w_addr;
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

  eva_t = eva_map(1);
  if( eva_t->control != EVA_BUS_INIT){
    fprintf(stderr, " @EVA HDL is not detected start first , exit .\n");  
    exit(EXIT_FAILURE);  
  }
  
  eva_t->control = EVA_BUS_ACK;

  while(eva_t->control == EVA_BUS_ACK ){
    usleep(1);
  }
  
  if( eva_t->control != EVA_BUS_ALVIE){
    fprintf(stderr, " @EVA HDL is not response correct, exit .\n");  
    exit(EXIT_FAILURE);  
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

  fprintf(stderr, " @EVA SW initial OVER ^^ . @0x%8x\n",(uint32_t)eva_t);  
}

void eva_drv_stop(){

  if( eva_t->control != EVA_BUS_ALVIE){
    fprintf(stderr, " @EVA HDL is not alive when stop , exit .\n");  
    exit(EXIT_FAILURE);  
  }

  eva_t->control = EVA_BUS_STOP;

  while(eva_t->control == EVA_BUS_STOP ){
    usleep(1);
  }

  fprintf(stderr, " @EVA HDL STOP ACKED ...\n");  
  eva_destory();
}

void eva_drv_pause(){

  if( eva_t->control != EVA_BUS_ALVIE){
    fprintf(stderr, " @EVA HDL is not alive when pause , exit .\n");  
    exit(EXIT_FAILURE);  
  }

  eva_t->control = EVA_BUS_PAUSE;

  while(eva_t->control == EVA_BUS_PAUSE ){
    usleep(1);
  }

}
