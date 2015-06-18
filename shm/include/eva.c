#include "eva.h"

void *eva_map(int do_init){
  void *shm = NULL;  
  key_t key = ftok(".", 1); 
  EVA_BUS_ST_p bus;
  int   shmid = shmget(key, sizeof(EVA_BUS_ST_t), 0666|IPC_CREAT);  
  if(shmid == -1)  
    {  
      fprintf(stderr, "shmget failed\n");  
      exit(EXIT_FAILURE);  
    }  

  shm = shmat(shmid, NULL , 0);  

  if(shm == (void*)-1)  
    {  
      fprintf(stderr, "shmat failed\n");  
      exit(EXIT_FAILURE);  
    }  
  fprintf(stderr, " @EVA initialed @key %x\n",key);  

  if(do_init){
    bus = (EVA_BUS_ST_t *)shm;

    bus->resv       = 0;
    bus->intr       = 0;
    bus->ahb_sync   = EVA_SYNC_ACK;
    bus->axi_w_sync = EVA_SYNC_ACK;
    bus->axi_r_sync = EVA_SYNC_ACK;
  }

  return shm;
}

void eva_unmap(void *map){
  if(shmdt(map) == -1)  
    {  
      fprintf(stderr, "shmdt failed\n");  
      exit(EXIT_FAILURE);  
    }  
}


void eva_destory(){
  void *shm = NULL;  
  key_t key = ftok(".", 1); 
  int   shmid = shmget(key, sizeof(EVA_BUS_ST_t), 0666|IPC_CREAT);  
  if(shmid == -1)  
    {  
      fprintf(stderr, "shmget failed\n");  
      exit(EXIT_FAILURE);  
    }  

  shm = shmat(shmid, NULL , 0);  
  
  if(shm == (void*)-1)  
    {  
      fprintf(stderr, "shmat failed\n");  
      exit(EXIT_FAILURE);  
    }  

  if(shmdt(shm) == -1)  
    {  
      fprintf(stderr, "shmdt failed\n");  
      exit(EXIT_FAILURE);  
    }  

  //删除共享内存  
  if(shmctl(shmid, IPC_RMID, 0) == -1)  
    {  
      fprintf(stderr, "shmctl(IPC_RMID) failed\n");  
      exit(EXIT_FAILURE);  
    }  

  fprintf(stderr, " @EVA Destory @key %x\n",key);  
  exit(EXIT_SUCCESS);  
}

