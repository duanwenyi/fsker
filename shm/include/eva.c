#include <string.h>
#include "eva.h"


void *eva_map(int do_init){
    void *shm = NULL;  
    key_t key = ftok(".", 1); 
    EVA_BUS_ST_p bus;
    int   shmid = shmget(key, sizeof(EVA_BUS_ST_t), 0666|IPC_CREAT);  
    if(shmid == -1)  
        {  
            eva_msg("shmget failed\n");  
            exit(EXIT_FAILURE);  
        }  

    shm = shmat(shmid, NULL , 0);  

    if(shm == (void*)-1)  
        {  
            eva_msg("shmat failed\n");  
            exit(EXIT_FAILURE);  
        }  
    eva_msg("generate key: [0x%x]\n",key);  

    if(do_init){
        bus = (EVA_BUS_ST_t *)shm;

        memset(bus, 0, sizeof(EVA_BUS_ST_t));
    }

    return shm;
}

void eva_unmap(void *map){
    if(shmdt(map) == -1)  
        {  
            eva_msg("shmdt failed\n");  
            exit(EXIT_FAILURE);  
        }  
}


void eva_destory(){
    void *shm = NULL;  
    key_t key = ftok(".", 1); 
    int   shmid = shmget(key, sizeof(EVA_BUS_ST_t), 0666|IPC_CREAT);  
    if(shmid == -1)  
        {  
            eva_msg("shmget failed\n");  
            exit(EXIT_FAILURE);  
        }  

    shm = shmat(shmid, NULL , 0);  
  
    if(shm == (void*)-1)  
        {  
            eva_msg("shmat failed\n");  
            exit(EXIT_FAILURE);  
        }  

    if(shmdt(shm) == -1)  
        {  
            eva_msg("shmdt failed\n");  
            exit(EXIT_FAILURE);  
        }  

    //删除共享内存  
    if(shmctl(shmid, IPC_RMID, 0) == -1)  
        {  
            eva_msg("shmctl(IPC_RMID) failed\n");  
            exit(EXIT_FAILURE);  
        }  

    eva_msg("Destory key : [%x]\n",key);  
    exit(EXIT_SUCCESS);  
}

