#ifndef __EVA_H__
#define __EVA_H__


#include <unistd.h>  
#include <stdlib.h>  
#include <stdio.h>  
#include <stdint.h>  
#include <sys/shm.h>  
#include <sys/types.h>
#include <sys/ipc.h>

// control
#define EVA_BUS_INIT   0x55
#define EVA_BUS_ACK    0x5C
#define EVA_BUS_ALIVE  0xCC
#define EVA_BUS_PAUSE  0xC0
#define EVA_BUS_STOP   0x00

#define EVA_SYNC       0x5c5c5c5c
#define EVA_SYNC_ACK   0xc5c5c5c5

/*
  EVA BUS initial process :
HDL:  EVA_BUS_INIT |             | EVA_BUS_ALVIE |              | EVA_BUS_INIT --> end simulation
C  :               | EVA_BUS_ACK |               | EVA_BUS_STOP |
  
HDL:  EVA_BUS_INIT |             | EVA_BUS_ALVIE |               | EVA_BUS_INIT --> wait new ACK
C  :               | EVA_BUS_ACK |               | EVA_BUS_PAUSE |

*/

#define EVA_WAIT_SYNC_MSK 0x1

typedef struct EVA_BUS_ST {
  uint16_t control;  // 
  uint8_t  resv;     // reserved  [0]: 1:wait sync
  uint8_t  intr;     // Interrupt , every bit for one register interrupt .

  uint32_t ahb_sync;
  uint32_t ahb_write;
  uint32_t ahb_addr;
  uint32_t ahb_data;

  uint32_t axi_w_sync;
  uint32_t axi_w_addr;
  uint32_t axi_w_strb;
  uint32_t axi_w_data0;
  uint32_t axi_w_data1;
  uint32_t axi_w_data2;
  uint32_t axi_w_data3;

  uint32_t axi_r_sync;
  uint32_t axi_r_addr;
  uint32_t axi_r_data0;
  uint32_t axi_r_data1;
  uint32_t axi_r_data2;
  uint32_t axi_r_data3;

  //void *shm;
}EVA_BUS_ST_t, *EVA_BUS_ST_p;


void *eva_map(int do_init);
void eva_unmap();

void eva_destory();

#endif
