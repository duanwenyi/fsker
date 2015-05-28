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

  // One should store blocking signals for non-blocking using
  // AHB 
  uint32_t hready;
  uint32_t hresp;
  uint32_t hrdata;

  // AXI read
  uint32_t arvalid;
  uint32_t arid;        // [3:0]
  uint32_t araddr_low;
  uint32_t araddr_high;
  uint32_t arlen;       // [5:0]
  uint32_t arsize;      // [2:0]  3'b100  (16 bytes)
  uint32_t arburst;     // [1:0]  2'b01
  uint32_t arlock;
  uint32_t arcache;     // [3:0]
  uint32_t arport;      // [2:0]
  uint32_t arregion;    // [3:0]
  uint32_t arqos;       // [3:0]
  uint32_t aruser;      // [7:0]
  uint32_t rready;
  uint32_t rresp;               // [1:0]

  // AXI write
  uint32_t awvalid;
  uint32_t awid;        // [3:0]
  uint32_t awaddr_low;
  uint32_t awaddr_high;
  uint32_t awlen;       // [5:0]
  uint32_t awsize;      // [2:0]  3'b100  (16 bytes)
  uint32_t awburst;     // [1:0]  2'b01
  uint32_t awlock;
  uint32_t awcache;     // [3:0]
  uint32_t awport;      // [2:0]
  uint32_t awregion;    // [3:0]
  uint32_t awqos;       // [3:0]
  uint32_t awuser;      // [7:0]

  uint32_t wvalid;
  uint32_t wlast;
  uint32_t wid;                // [3:0]
  uint32_t wdata_0;            // [31:0]
  uint32_t wdata_1; 
  uint32_t wdata_2;
  uint32_t wdata_3;
  uint32_t wstrb;               // [15:0]

}EVA_HDL_t, *EVA_HDL_p;

void eva_hdl_init();
void eva_hdl_stop( svBit *stop );
void eva_hdl_pause();

void eva_ahb_bus_func_i( const svBit        hready,
			 const svBitVecVal *hresp,
			 const svBitVecVal *hrdata
			 );

void eva_ahb_bus_func_o( svBitVecVal *htrans,
			 svBit       *hwrite,
			 svBitVecVal *haddr,
			 svBitVecVal *hwdata
			 );

void eva_axi_rd_func_i( const svBit        arvalid,
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
			const svBitVecVal *rresp               // [1:0]
			);

void eva_axi_rd_func_o( svBit             *arready,
			svBit             *rvalid,
			svBitVecVal       *rid,                // [3:0]
			svBitVecVal       *rdata_0,            // [31:0]
			svBitVecVal       *rdata_1, 
			svBitVecVal       *rdata_2,
			svBitVecVal       *rdata_3,
			svBit             *rlast
			);


void eva_axi_wr_func_i( const svBit        awvalid,
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
		      
			const svBit        wvalid,
			const svBit        wlast,
			const svBitVecVal *wid,                // [3:0]
			const svBitVecVal *wdata_0,            // [31:0]
			const svBitVecVal *wdata_1, 
			const svBitVecVal *wdata_2,
			const svBitVecVal *wdata_3,
			const svBitVecVal *wstrb               // [15:0]
			);

void eva_axi_wr_func_o( svBit  *awready,
			svBit  *wready
			);

#endif
