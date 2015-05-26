#include "eva_driver.h"

EVA_BUS_ST_p eva_t = NULL;

void eva_drv_init(){
  eva_t = eva_init();

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
