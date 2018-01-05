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

void  eva_show(EVA_BUS_ST_p p , char *info){
    
    sprintf(info, " +EVA Rate MAX:%6d    MIN:%6d      CUR:%6d - Tick:%lld \n\
 +SLV (%c): Addr %08x %08x - Data %08x %08x - SIZE %3x\n\
 +MST (W): Addr %08x %08x - Data %08x %08x %08x %08x - STRB %08x\n\
 +MST (R): Addr %08x %08x - Data %08x %08x %08x %08x\n\
",
            p->max_rate,p->min_rate,p->cur_rate, p->tick,
            p->slv.write ? 'W':'R',p->slv.addr_u,p->slv.addr_l,p->slv.data_u,p->slv.data_l,p->slv.size,
            p->mst_wr.addr_u,p->mst_wr.addr_l,p->mst_wr.data_3,p->mst_wr.data_2,p->mst_wr.data_1,p->mst_wr.data_0,p->mst_wr.strb,
            p->mst_rd.addr_u,p->mst_rd.addr_l,p->mst_rd.data_3,p->mst_rd.data_2,p->mst_rd.data_1,p->mst_rd.data_0
            
            );
    
    
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

