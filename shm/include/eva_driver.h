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

#endif
