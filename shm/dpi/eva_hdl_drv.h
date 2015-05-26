#ifndef __EVA_HDL_DRV_H__
#define __EVA_HDL_DRV_H__

#include "eva.h"
#include "svdpi.h"

#define EVA_AHB_IDLE    0
#define EVA_AHB_NONSEQ  2
#define EVA_AHB_SEQ     3

#define EVA_AXI_MAX_PORT 4

// AXI Port Cell
typedef struct AXI_PCELL{
  uint32_t valid;
  uint32_t addr_base;
  uint32_t cur_addr;
  
  uint32_t length;
  uint32_t remain_len;    // remain length of a burst
  uint32_t burst;
  uint32_t size;

}AXI_PCELL_t;

typedef struct EVA_HDL{
  uint32_t axi_wcmd_nums;
  uint32_t axi_rcmd_nums;
  uint32_t axi_cur_wactive;
  uint32_t axi_cur_ractive;
  uint32_t axi_cur_wlock;
  uint32_t axi_cur_rlock;
  uint32_t axi_cur_wport;
  uint32_t axi_cur_rport;

  uint32_t axi_pre_awready;
  uint32_t axi_pre_arready;

  AXI_PCELL_t axi_w[EVA_AXI_MAX_PORT];
  AXI_PCELL_t axi_r[EVA_AXI_MAX_PORT];

  uint32_t ahb_fsm;
  uint32_t dbg_id;
  
  EVA_BUS_ST_p  eva_t;
}EVA_HDL_t, *EVA_HDL_p;

void eva_hdl_init();
void eva_hdl_stop( svBit *stop );
void eva_hdl_pause();

void eva_ahb_bus_func( svBitVecVal *htrans,
		       svBit       *hwrite,
		       svBitVecVal *haddr,
		       svBitVecVal *hwdata,
		       //svBitVecVal *hsize,
		       //svBitVecVal *hburst,
		       //svBitVecVal *hprot,

		       const svBit        hready,
		       const svBitVecVal *hresp,
		       const svBitVecVal *hrdata
		       );

void eva_axi_rd_func( svBit             *arready,
		      const svBit        arvalid,
		      const svBitVecVal *arid,        // [3:0]
		      const svBitVecVal *araddr_low,
		      const svBitVecVal *araddr_high,
		      const svBitVecVal *arlen,       // [5:0]
		      const svBitVecVal *arsize,      // [2:0]  3'b100  (16 bytes)
		      const svBitVecVal *arburst,     // [1:0]  2'b01
		      const svBit        arlock,
		      const svBitVecVal *arcache,     // [3:0]
		      const svBitVecVal *arport,      // [2:0]
		      const svBitVecVal *arregion,    // [3:0]
		      const svBitVecVal *arqos,       // [3:0]
		      const svBitVecVal *aruser,      // [7:0]
		      
		      const svBit        rready,
		      svBit              rvalid,
		      svBitVecVal       *rid,                // [3:0]
		      svBitVecVal       *rdata_0,            // [31:0]
		      svBitVecVal       *rdata_1, 
		      svBitVecVal       *rdata_2,
		      svBitVecVal       *rdata_3,
		      svBit             *rlast,
		      const svBitVecVal *rresp               // [1:0]
		      );

void eva_axi_wr_func(       svBit       *awready,
		      const svBit        awvalid,
		      const svBitVecVal *awid,        // [3:0]
		      const svBitVecVal *awaddr_low,
		      const svBitVecVal *awaddr_high,
		      const svBitVecVal *awlen,       // [5:0]
		      const svBitVecVal *awsize,      // [2:0]  3'b100  (16 bytes)
		      const svBitVecVal *awburst,     // [1:0]  2'b01
		      const svBit        awlock,
		      const svBitVecVal *awcache,     // [3:0]
		      const svBitVecVal *awport,      // [2:0]
		      const svBitVecVal *awregion,    // [3:0]
		      const svBitVecVal *awqos,       // [3:0]
		      const svBitVecVal *awuser,      // [7:0]
		      
		      svBit             *wready,
		      const svBit       *wvalid,
		      const svBitVecVal *wid,                // [3:0]
		      const svBitVecVal *wdata_0,            // [31:0]
		      const svBitVecVal *wdata_1, 
		      const svBitVecVal *wdata_2,
		      const svBitVecVal *wdata_3,
		      const svBitVecVal *wstrb               // [15:0]
		      );

#endif
