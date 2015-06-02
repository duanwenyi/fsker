#include "eva_driver.h"

int main(int argc, char **argv){
  int rd_val;

  eva_drv_init();
  
  eva_cpu_wr(0x4,1);

  eva_cpu_wr(0x0, 0x7);

  eva_cpu_wr(0x100, 0x3);
  eva_cpu_wr(0x104, 0x4);
  eva_cpu_wr(0x108, 0xFFFF0000);

  rd_val = eva_cpu_rd(0x100);
  fprintf(stderr," read addr 0x100:  0x%x\n", rd_val);
  rd_val = eva_cpu_rd(0x104);
  fprintf(stderr," read addr 0x104:  0x%x\n", rd_val);
  rd_val = eva_cpu_rd(0x108);
  fprintf(stderr," read addr 0x108:  0x%x\n", rd_val);

  eva_drv_stop();

  return 0;
}
