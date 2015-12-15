#ifndef __EVA_DRIVER_H__
#define __EVA_DRIVER_H__
#include "eva.h"

void eva_drv_init();
void eva_drv_stop();
void eva_drv_pause();

void eva_axi_rd_handler(void);
void eva_axi_wr_handler(void);

void eva_cpu_wr(uint32_t addr, uint32_t data);
uint32_t eva_cpu_rd(uint32_t addr);

void eva_intr_register(void (*user_func)(), int intr_id);
void evaScopeWait(char *path, uint32_t value, uint32_t mode );

void eva_delay(int cycle);


typedef struct EVA_INTR_REG {
    uint32_t valid[EVA_MAX_INT_NUM];
    void (*func[EVA_MAX_INT_NUM])(void);
    uint32_t valid_bits;
}EVA_INTR_REG_t;

// PART II : multi-testcase struct frame

#define EVA_MAX_TC_NUM 64

typedef struct EVA_TC_UNIT {
    char name[256];
    void (*func)(void);
}EVA_TC_UNIT_t;

typedef struct EVA_TC_REG {
    int           tc_nums;
    EVA_TC_UNIT_t tc[EVA_MAX_TC_NUM];
}EVA_TC_REG_t;

extern EVA_TC_REG_t eva_tc;

void  EVA_TC_INIT();
void  EVA_TC_REGISTER(void (*func)(), const char *name);
void  EVA_TC_SHOW_LIST();
char *EVA_TC_GET_NAME_BY_ID(int id);
int   EVA_TC_GET_ID_BY_NAME(char *name);
void  EVA_TC_RUN_BY_NAME(char *name);
void  EVA_TC_RUN_BY_ID(int id);


#endif
