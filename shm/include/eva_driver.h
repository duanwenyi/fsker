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


#endif
