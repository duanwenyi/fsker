#include "eva_driver.h"

void intr_sample(){
    fprintf(stderr,"I'm a lucky dog !\n");
}

int main(int argc, char **argv){
    int rd_val;
    int cc;
    int ahb_rw_test = 10000;

    eva_drv_init();
  
    eva_intr_register(intr_sample, 0);

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

    evaScopeWait( "TH.U_IVS_TOP.U_IVS_SLV.cfg_par2", 0xFFFF0000, 1 );

    eva_delay(10);
    eva_delay(50);
    eva_delay(100);
    eva_delay(1000);
    eva_delay(10000);
    fprintf(stderr," Begin %d times AHB write + read : \n", ahb_rw_test);
    for(cc=0; cc< ahb_rw_test; cc++){
        eva_cpu_wr(0x108, 0xFFFF0000);
        rd_val = eva_cpu_rd(0x100);
    }
    eva_delay(1);

    sleep(10);

    eva_drv_stop();

    return 0;
}
