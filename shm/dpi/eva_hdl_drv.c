#include "eva_hdl_drv.h"


EVA_HDL_t eva_bus_t;

void eva_hdl_init(){
  memset(&eva_bus_t, sizeof(EVA_HDL_t) , 0);

  eva_bus_t.eva_t = eva_map(1);

  eva_bus_t.eva_t->control = EVA_BUS_INIT;

  while(eva_bus_t.eva_t->control == EVA_BUS_INIT ){
  }
  
  if( eva_bus_t.eva_t->control != EVA_BUS_ACK){
    fprintf(stderr, " @EVA DEMO is not response correct, exit .\n");  
    exit(EXIT_FAILURE);  
  }

  eva_bus_t.eva_t->control = EVA_BUS_ALIVE;
  fprintf(stderr, " @EVA HDL is set ALIVE OK .\n");  
 
}

void eva_hdl_stop( svBit *stop ){

  if( eva_bus_t.eva_t->control == EVA_BUS_STOP){
    fprintf(stderr, " @EVA DEMO set STOP detected , ready out ...\n");  

    eva_bus_t.eva_t->ahb_sync = EVA_SYNC_ACK;
    eva_bus_t.eva_t->control  = EVA_BUS_INIT;

    *stop = 1;
  }else{
    *stop = 0;
  }

}

void eva_hdl_pause(){

  if( eva_bus_t.eva_t->control == EVA_BUS_PAUSE){
    fprintf(stderr, " @EVA DEMO set PAUSE detected , wait alive ...\n");  
    
    eva_hdl_init();
  }

}

void eva_ahb_bus_func_i( const svBit        hready,
			 const svBitVecVal *hresp,
			 const svBitVecVal *hrdata
			 ){
  eva_bus_t->hready = hready;
  eva_bus_t->hresp  = *hresp;
  eva_bus_t->hrdata = *hrdata;
  
}

void eva_ahb_bus_func_o( svBitVecVal *htrans,
			 svBit       *hwrite,
			 svBitVecVal *haddr,
			 svBitVecVal *hwdata
			 ){


  uint32_t m_hrdata = *hrdata;

  //*hsize  = 2; // FIXME
  //*hburst = 0; // FIXME
  //*hprot  = 0; // FIXME
  
  switch(eva_bus_t.ahb_fsm){
  case EVA_AHB_IDLE:
    if(eva_bus_t.eva_t->ahb_sync == EVA_SYNC){
      *htrans = EVA_AHB_NONSEQ;
      *haddr  = eva_bus_t.eva_t->ahb_addr;
      *hwrite = eva_bus_t.eva_t->ahb_write;
      if(eva_bus_t.eva_t->ahb_write)
	*hwdata = eva_bus_t.eva_t->ahb_data;

      eva_bus_t.ahb_fsm = EVA_AHB_NONSEQ;
    }
    break;
  case EVA_AHB_NONSEQ:
    if(eva_bus_t.eva_t->ahb_write)
      *hwdata = eva_bus_t.eva_t->ahb_data;
    if(eva_bus_t->hready){
      *htrans = 0;
      if(eva_bus_t.eva_t->ahb_write)
	eva_bus_t.ahb_fsm = EVA_AHB_IDLE;
      else
	eva_bus_t.ahb_fsm = EVA_AHB_SEQ;
    }
    break;
  case EVA_AHB_SEQ:
    if(eva_bus_t->hready){
      eva_bus_t.eva_t->ahb_data = eva_bus_t->hrdata;
      
      eva_bus_t.ahb_fsm = EVA_AHB_IDLE;

      eva_bus_t.eva_t->ahb_sync = EVA_SYNC_ACK;
    }
    break;
  default:
    fprintf(stderr, " @EVA AHB FSM error status detected !\n");  
    eva_bus_t.ahb_fsm = EVA_AHB_IDLE;
    break;
  }

}

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
			){
  


  eva_bus_t->arvalid		=  arvalid;   
  eva_bus_t->arid		= *arid       & 0xF;      
  eva_bus_t->araddr_low		= *araddr_low;
  eva_bus_t->araddr_high	= *araddr_high;
  eva_bus_t->arlen		= *arlen      & 0x3F;     
  eva_bus_t->arsize		= *arsize     & 0x3;    
  eva_bus_t->arburst		= *arburst    & 0x7;   
  eva_bus_t->arlock		=  arlock;
  eva_bus_t->arcache		= *arcache    & 0xF;   
  eva_bus_t->arport		= *arport     & 0x7;    
  eva_bus_t->arregion		= *arregion   & 0xF;  
  eva_bus_t->arqos		= *arqos      & 0xF;     
  eva_bus_t->aruser		= *aruser     & 0xFF;    
				              
  eva_bus_t->rready		=  rready;
  eva_bus_t->rresp		= *rresp       & 0x3;

}

void eva_axi_rd_func_o( svBit             *arready,
			svBit             *rvalid,
			svBitVecVal       *rid,                // [3:0]
			svBitVecVal       *rdata_0,            // [31:0]
			svBitVecVal       *rdata_1, 
			svBitVecVal       *rdata_2,
			svBitVecVal       *rdata_3,
			svBit             *rlast
			){

  int cc;
  int timeout = 0;

  // PART I : COMMAND PROCESS
  if(eva_bus_t->arvalid && (eva_bus_t.axi_rcmd_nums < EVA_AXI_MAX_PORT) && eva_bus_t.axi_pre_arready){
    
    eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].addr_base  = eva_bus_t->araddr_low;
    eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].cur_add    = eva_bus_t->araddr_low;
    eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].length     = eva_bus_t->arlen + 1;
    eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].remain_len = eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].length;
    eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].burst      = eva_bus_t->arburst;
    eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].size       = eva_bus_t->arsize;

    if( (eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].burst != 4) || (eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].size != 1) ){
      fprintf(stderr," @EVA HDL not support parameter detected in AXI read command  burst %x , size %x",
	      eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].burst, eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].size );

    eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].burst      = 4;
    eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].size       = 1;
    }

    eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].valid      = 1;
    eva_bus_t.axi_cur_rlock = rand()%20 + 1;
    
    eva_bus_t.axi_rcmd_nums++;
  }
  
  if(eva_bus_t.axi_rcmd_nums < EVA_AXI_MAX_PORT)
    *arready = rand()%2;
  else
    *arready = 0;

  eva_bus_t.axi_pre_arready = *arready;

  // PART II : DATA PROCESS
  if( (eva_bus_t.axi_rcmd_nums > 0 ) && !eva_bus_t.axi_cur_ractive ){
    eva_bus_t.axi_cur_ractive = rand()%2  && (eva_bus_t.axi_cur_rlock == 0);
    
    if(eva_bus_t.axi_cur_ractive){
      for(cc=0; cc< eva_bus_t.axi_rcmd_nums; cc++){
	if(eva_bus_t.axi_r[cc].valid){
	  eva_bus_t.axi_cur_rport = cc;
	  break;
	}
      }
    }

  }
  
  if(eva_bus_t.axi_cur_ractive && (eva_bus_t.axi_cur_rlock == 0)){
    *rid   = eva_bus_t.axi_cur_rport;
    *rresp = 0; // FIXED , OK

    if(eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].remain_len == eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].length || // first
       ( rready && (eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].remain_len > 0)) ) {

      //*rvalid = rand()%2 || (eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].remain_len > 0);
      *rvalid = (rand()%16) < 4; 
      
      if(*rvalid){
	eva_bus_t.shm->axi_r_addr = eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].cur_addr;
	eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].cur_addr += 16;

	eva_bus_t.shm->axi_r_sync = 1;
	
	timeout = 0;
	while(eva_bus_t.shm->axi_r_sync == 1){
	  timeout++;
	  if(timeout > 100000000){ // 1 million
	    fprintf(stderr," @EVA HDL axi_r_sync timeout , check SYSTEM !");
	    return ;
	  }
	}
	
	*rdata_0 = eva_bus_t.shm->axi_r_data0;
	*rdata_1 = eva_bus_t.shm->axi_r_data1;
	*rdata_2 = eva_bus_t.shm->axi_r_data2;
	*rdata_3 = eva_bus_t.shm->axi_r_data3;

	if(eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].remain_len > 0)
	  eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].remain_len--;

	if(eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].remain_len == 0){
	  *rlast = 1;
	}
      }

    }else{
      if(eva_bus_t->rready){
	eva_bus_t.axi_cur_ractive = 0;
	*rvalid = 0;
	*rlast  = 0;
	eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].valid = 0;

	eva_bus_t.axi_rcmd_nums--;
      }
    }
  }

  if(eva_bus_t.axi_cur_rlock > 0)
    eva_bus_t.axi_cur_rlock--;
  

}

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
			){


  eva_bus_t->awvalid    =  awvalid; 
  eva_bus_t->awid       = *awid       & 0xF; 
  eva_bus_t->awaddr_low = *awaddr_low; 
  eva_bus_t->awaddr_high= *awaddr_high; 
  eva_bus_t->awlen      = *awlen      & 0x3F; 
  eva_bus_t->awsize     = *awsize     & 0x7; 
  eva_bus_t->awburst    = *awburst    & 0x3; 
  eva_bus_t->awlock     =  awlock; 
  eva_bus_t->awcache    = *awcache    & 0xF; 
  eva_bus_t->awport     = *awport     & 0x7; 
  eva_bus_t->awregion   = *awregion   & 0xF; 
  eva_bus_t->awqos      = *awqos      & 0xF; 
  eva_bus_t->awuser     = *awuser     & 0xFF; 
			   
  eva_bus_t->wvalid     =  wvalid; 
  eva_bus_t->wlast      =  wlast; 
  eva_bus_t->wid        = *wid        & 0xF; 
  eva_bus_t->wdata_0    = *wdata_0; 
  eva_bus_t->wdata_1    = *wdata_1; 
  eva_bus_t->wdata_2    = *wdata_2; 
  eva_bus_t->wdata_3    = *wdata_3; 
  eva_bus_t->wstrb      = *wstrb      & 0xFFFF; 



}

void eva_axi_wr_func_o( svBit  *awready,
			svBit  *wready
			){
  int cc;
  int timeout = 0;

  // PART I : COMMAND PROCESS
  if(eva_bus_t->awvalid && (eva_bus_t.axi_wcmd_nums < EVA_AXI_MAX_PORT) && eva_bus_t.axi_pre_awready){
    
    eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].addr_base  = eva_bus_t->awaddr_low;
    eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].cur_add    = eva_bus_t->awaddr_low;
    eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].length     = eva_bus_t->awlen + 1;
    eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].remain_len = eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].length;
    eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].burst      = eva_bus_t->awburst;
    eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].size       = eva_bus_t->awsize;

    if( (eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].burst != 4) || (eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].size != 1) ){
      fprintf(stderr," @EVA HDL not support parameter detected in AXI write command  burst %x , size %x",
	      eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].burst, eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].size );

    eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].burst      = 4;
    eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].size       = 1;
    }

    eva_bus_t.axi_w[eva_bus_t.axi_wcmd_nums].valid      = 1;
    eva_bus_t.axi_cur_wlock = rand()%20 + 1;
    
    eva_bus_t.axi_wcmd_nums++;
  }
  
  if(eva_bus_t.axi_wcmd_nums < EVA_AXI_MAX_PORT)
    *awready = rand()%2;
  else
    *awready = 0;

  eva_bus_t.axi_pre_awready = *awready;

  // PART II : DATA PROCESS
  if( (eva_bus_t.axi_wcmd_nums > 0 ) && !eva_bus_t.axi_cur_wactive & eva_bus_t->wvalid ){
    eva_bus_t.axi_cur_wactive = 1;
    eva_bus_t.axi_cur_wport   = *wid & 0xF;
  }
  
  *wready = rand()%2 && (eva_bus_t.axi_cur_wlock == 0);  

  if(eva_bus_t.axi_cur_wactive && eva_bus_t->wvalid && *wready){

      
    eva_bus_t.shm->axi_w_addr = eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].cur_addr;
    eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].cur_addr += 16;
    
    eva_bus_t.shm->axi_w_strb  = *wstrb & 0xFFFF;
    eva_bus_t.shm->axi_w_data0 = *wdata_0;
    eva_bus_t.shm->axi_w_data1 = *wdata_1;
    eva_bus_t.shm->axi_w_data2 = *wdata_2;
    eva_bus_t.shm->axi_w_data3 = *wdata_3;

    eva_bus_t.shm->axi_w_sync = 1;

    timeout = 0;
    while(eva_bus_t.shm->axi_w_sync == 1){
      timeout++;
      if(timeout > 100000000){ // 1 million
	fprintf(stderr," @EVA HDL axi_w_sync timeout , check SYSTEM !");
	return ;
      }
    }
      
      
    if(eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].remain_len > 0)
      eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].remain_len--;

    if(eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].remain_len == 0){
      if( !eva_bus_t->wlast )
	fprintf(stderr," ERROR @EVA HDL rlast not detected in a write burst last! %x");

      eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].valid = 0;
      eva_bus_t.axi_cur_wactive = 0;

      eva_bus_t.axi_wcmd_nums--;
    }

  }
  
  if(eva_bus_t.axi_cur_wlock > 0)
    eva_bus_t.axi_cur_wlock--;

}

