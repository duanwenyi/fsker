#ifndef __EVA_H__
#define __EVA_H__


#include <unistd.h>  
#include <stdlib.h>  
#include <stdio.h>  
#include <stdint.h>  
#include <sys/shm.h>  
#include <sys/types.h>
#include <sys/ipc.h>

// EVA Initial Using
#define EVA_IDLE     0x00000000
#define EVA_INIT     0xC0C0C0C0
#define EVA_RDY      0x0C0C0C0C
#define EVA_PAUSE    0x10101010
#define EVA_STOP     0xE000002D
#define EVA_ERR      0xE0000E22

/*
  Normal:

  EVA BUS initial process :
  HDL:  IDLE | INIT | RDY --- | STOP 
  C  :  IDLE | INIT | RDY --- | STOP 

  Pause --> wake
  
  HDL:  IDLE | INIT | ---  | RDY  | PAUSE | RDY
  C  :              | ---  | RDY  | PAUSE | RDY
*/

// Get Using
#define EVA_SOF      0x9000050F
#define EVA_EOF      0x90000E0F
#define EVA_ACK      0x90000ACE
#define EVA_ACK_A    0x900A0ACE
#define EVA_ACK_B    0x900B0ACE
#define EVA_SEND_A   0x900A5E2D
#define EVA_SEND_B   0x900B5E2D
#define EVA_ROK      0x9000020E

// HDL:  IDLE |  ACK |  ACK_A |  ACK_B |  ACK_A | --- |  ROK |
// C  :       | SOF  | SEND_A | SEND_B | SEND_A | --- | EOF  | IDLE 

// BUS SYNC Using
#define EVA_SYNC       0xEE5c5c5c
#define EVA_SYNC_ACK   0xEEc5c5c5


#define EVA_UNIT_DELAY usleep(1)
#define GEN_DMA_ADDR64(high, low) ( ( (uint64_t)(high) <<32 ) | (low))

#define EVA_MAX_INT_NUM 32

// 
/* About configure
   
   SLV
   uint8_t haw;          // Slave Address Width
   uint8_t hdw;          // Slave Data Width
   uint8_t type;         // Slave Type : 0:AHB  1:APB 2:AXI
   uint8_t rsv;          // SYNC control

   MST:
   uint8_t mwaw;         // Master(AXI) Write Address Width
   uint8_t mwdw;         // Master(AXI) Write Data Width
   uint8_t mraw;         // Master(AXI) Read Address Width
   uint8_t mrdw;         // Master(AXI) Read Data Width
 
*/ 

typedef struct EVA_BUS_MST_ST {
    uint32_t sync;       // Master(AXI) Write/Read SYNC control
    uint32_t strb;       // Master(AXI) Write Strobe

    uint32_t addr_l;    // Master(AXI) Write/Read Address low 32 bits
    uint32_t addr_u;    // Master(AXI) Write/Read Address upper 32 bits

    uint32_t data_0;    // Master(AXI) Write/Read Data 0
    uint32_t data_1;    // Master(AXI) Write/Read Data 1
    uint32_t data_2;    // Master(AXI) Write/Read Data 2
    uint32_t data_3;    // Master(AXI) Write/Read Data 3

}EVA_BUS_MST_ST_t, *EVA_BUS_MST_ST_p;

typedef struct EVA_BUS_SLV_ST {
    uint32_t addr_l;      // Address low 32 bits
    uint32_t addr_u;      // Address upper 32 bits
    
    uint32_t data_l;     // Data low 32 bits
    uint32_t data_u;     // Data high 32 bits

    uint32_t sync;        // SYNC control
    uint8_t  write;       // 
    uint8_t  size;        // hsize
    uint8_t  rsz_0;       // Reserved
    uint8_t  rsz_1;       // Reserved

}EVA_BUS_SLV_ST_t, *EVA_BUS_SLV_ST_p;

typedef struct EVA_BUS_INT_ST {
    uint32_t intx;       // Interrputs
}EVA_BUS_INT_ST_t, *EVA_BUS_INT_ST_p;

typedef struct EVA_BUS_GET_ST {
    uint32_t sync;       // get signal  sync : from app 
    char     str[32];    // re-used by wait & get syn process , each 64 bytes
}EVA_BUS_GET_ST_t, *EVA_BUS_GET_ST_p;

typedef struct EVA_BUS_SYNC_ST {
    uint32_t  dut;       // DUT SYNC
    uint32_t  sw;        // Software SYNC
}EVA_BUS_SYNC_ST_t, *EVA_BUS_SYNC_ST_p;

typedef struct EVA_BUS_ST {

    EVA_BUS_SYNC_ST_t sync;  // SYNC

    EVA_BUS_MST_ST_t  mst_wr; // Master write
                       
    EVA_BUS_MST_ST_t  mst_rd; // Master read
                       
    EVA_BUS_SLV_ST_t  slv;    // Slave

    EVA_BUS_INT_ST_t  intx;   // Intrrupt

    EVA_BUS_GET_ST_t  get;     // one can using "get" to implement "wait"

    // One 32 bits counter be full to 0xFFFF_FFFF only need about ~ 3 hour
    // So 64 bits is better
    uint64_t tick;

}EVA_BUS_ST_t, *EVA_BUS_ST_p;

void *eva_map(int do_init);
void  eva_unmap();

void  eva_destory();

/* Optimization barrier */  
#define barrier() __asm__ __volatile__("": : :"memory")  

#define eva_msg(...) do{fprintf(stderr,"@[%s]:", __FUNCTION__),fprintf(stderr,##__VA_ARGS__);}while(0)
#endif
