
#include <signal.h> 
#include "eva_hdl_drv.h"
#include "vpi_user.h"

#ifndef USING_VCS_COMPILER
#include "vpi_user_cds.h"
#endif

#include <string.h>

EVA_HDL_t eva_bus_t;

//#define EVA_DEBUG
//#define EVA_AXI_DEBUG
//#define EVA_CONTROL_C_OUT

void eva_handler(int s){
    fprintf(stderr, " @EVA catch a SYSTEM interrupt .\n");  
    eva_bus_t.sys_sigint = 1;

}  


void eva_hdl_init(){
    memset(&eva_bus_t, 0, sizeof(EVA_HDL_t));

#ifdef EVA_CONTROL_C_OUT
    struct sigaction sigIntHandler;
    sigIntHandler.sa_handler = eva_handler;
    sigemptyset(&sigIntHandler.sa_mask);
    sigIntHandler.sa_flags = 0;
  
    sigaction(SIGINT, &sigIntHandler, NULL); 
#endif

    eva_bus_t.eva_t = (EVA_BUS_ST*)eva_map(1);

    eva_bus_t.eva_t->control = EVA_BUS_INIT;

    while(eva_bus_t.eva_t->control == EVA_BUS_INIT ){
        EVA_UNIT_DELAY;
        if(eva_bus_t.sys_sigint == 1){
            eva_bus_t.sys_sigint = 0;
            //pause();
            break;
        }
    }
  
    if( eva_bus_t.eva_t->control != EVA_BUS_ACK){
        fprintf(stderr, " @EVA DEMO is not response correct, exit .\n");  
        exit(EXIT_FAILURE);  
    }

    eva_bus_t.eva_t->control    = EVA_BUS_ALIVE;
    eva_bus_t.eva_t->ahb_sync   = EVA_SYNC_ACK;
    eva_bus_t.eva_t->axi_w_sync = EVA_SYNC_ACK;
    eva_bus_t.eva_t->axi_r_sync = EVA_SYNC_ACK;

    fprintf(stderr, " @EVA HDL is set ALIVE OK .\n");  
 
}

void eva_hdl_alive( svBit *stop,
                   svBit *error
                   ){
    *stop  = 0;
    *error = 0;

    if( eva_bus_t.eva_t->control == EVA_BUS_STOP){
        fprintf(stderr, " @EVA DEMO set STOP detected , ready out ...\n");  

        eva_bus_t.eva_t->ahb_sync = EVA_SYNC_ACK;
        eva_bus_t.eva_t->control  = EVA_BUS_INIT;

        *stop = 1;
    }else if(eva_bus_t.eva_t->control == EVA_BUS_ERROR){
        *error = 1;
        eva_bus_t.eva_t->control  = EVA_BUS_INIT;
    }
    
    evaScopeGetHandle();
}

void eva_ahb_bus_func_i( const svBit        hready,
                         const svBitVecVal *hresp,
                         const svBitVecVal *hrdata
                         ){
    eva_bus_t.hready = hready;
    eva_bus_t.hresp  = *hresp & 0x3;
    eva_bus_t.hrdata = *hrdata;

}

void eva_ahb_bus_func_o( svBitVecVal *htrans,
                         svBit       *hwrite,
                         svBitVecVal *haddr,
                         svBitVecVal *hwdata
                         ){
    //*hsize  = 2; // FIXME
    //*hburst = 0; // FIXME
    //*hprot  = 0; // FIXME
  
    switch(eva_bus_t.ahb_fsm){
    case EVA_AHB_IDLE:
        if(eva_bus_t.eva_t->ahb_sync == EVA_SYNC){
            *htrans = EVA_AHB_NONSEQ;
            *haddr  = eva_bus_t.eva_t->ahb_addr;
            *hwrite = eva_bus_t.eva_t->ahb_write;
            //if(eva_bus_t.eva_t->ahb_write)
            // 	*hwdata = eva_bus_t.eva_t->ahb_data;

            eva_bus_t.ahb_fsm = EVA_AHB_NONSEQ;

#ifdef EVA_DEBUG
            fprintf(stderr," @AHB [IDLE] addr: 0x%8x data: 0x%8x write: %x\n",
                    eva_bus_t.eva_t->ahb_addr, eva_bus_t.eva_t->ahb_data , eva_bus_t.eva_t->ahb_write);
#endif
        }
        break;
    case EVA_AHB_NONSEQ:
        if(eva_bus_t.eva_t->ahb_write)
            *hwdata = eva_bus_t.eva_t->ahb_data;
        if(eva_bus_t.hready){
            *htrans = 0;
            *hwrite = 0;
            eva_bus_t.ahb_fsm = EVA_AHB_SEQ;
        }
#ifdef EVA_DEBUG
        fprintf(stderr," @AHB [NONSEQ] addr: 0x%8x data: 0x%8x write: %x hready: %x\n",
                eva_bus_t.eva_t->ahb_addr, eva_bus_t.eva_t->ahb_data , eva_bus_t.eva_t->ahb_write, eva_bus_t.hready);
#endif
        break;
    case EVA_AHB_SEQ:
        if(eva_bus_t.hready){
            eva_bus_t.eva_t->ahb_data = eva_bus_t.hrdata;
      
            eva_bus_t.ahb_fsm = EVA_AHB_IDLE;

            eva_bus_t.eva_t->ahb_sync = EVA_SYNC_ACK;
        }
#ifdef EVA_DEBUG
        fprintf(stderr," @AHB [SEQ] addr: 0x%8x data: 0x%8x write: %x hready: %x\n",
                eva_bus_t.eva_t->ahb_addr, eva_bus_t.eva_t->ahb_data , eva_bus_t.eva_t->ahb_write, eva_bus_t.hready);
#endif
        break;
    default:
        fprintf(stderr, " @EVA AHB FSM error status detected !\n");  
        eva_bus_t.ahb_fsm = EVA_AHB_IDLE;
        break;
    }

}

void eva_axi_rd_func_i( const svBit        arvalid,
                        const svBitVecVal *arid,        // [5:0]
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
		      
                        const svBit        rready
                        ){
  


    eva_bus_t.arvalid		=  arvalid;   
    eva_bus_t.arid		= *arid       & 0x3F;      
    eva_bus_t.araddr_low		= *araddr_low;
    eva_bus_t.araddr_high 	= *araddr_high;
    eva_bus_t.arlen		= *arlen      & 0x3F;     
    eva_bus_t.arsize		= *arsize     & 0x7;    
    eva_bus_t.arburst		= *arburst    & 0x7;   
    eva_bus_t.arlock		=  arlock;
    eva_bus_t.arcache		= *arcache    & 0xF;   
    eva_bus_t.arport		= *arport     & 0x7;    
    eva_bus_t.arregion		= *arregion   & 0xF;  
    eva_bus_t.arqos		= *arqos      & 0xF;     
    eva_bus_t.aruser		= *aruser     & 0xFF;    
				              
    eva_bus_t.rready		=  rready;

    eva_bus_t.eva_t->tick++;
}

void eva_axi_rd_func_o( svBit             *arready,
                        svBit             *rvalid,
                        svBitVecVal       *rid,                // [4:0]
                        svBitVecVal       *ruser,              // [4:0]
                        svBitVecVal       *rdata_0,            // [31:0]
                        svBitVecVal       *rdata_1, 
                        svBitVecVal       *rdata_2,
                        svBitVecVal       *rdata_3,
                        svBit             *rlast,
                        svBitVecVal       *rresp               // [1:0]
                        ){

    int cc;
    int timeout = 0;
    int mark_active = 0;

    // PART I : COMMAND PROCESS
    if(eva_bus_t.arvalid && (eva_bus_t.axi_rcmd_nums < EVA_AXI_MAX_OUTSTANDING) ){
    
        if( (eva_bus_t.arburst != 1) //|| (eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].size != 4) 
            ){
            fprintf(stderr," @EVA HDL not support parameter detected in AXI read command  burst %x , size %x\n",
                    eva_bus_t.axi_r[eva_bus_t.arid].burst, eva_bus_t.axi_r[eva_bus_t.arid].size );
      
            //eva_bus_t.axi_r[eva_bus_t.arid].burst      = 1;  // INCR
            //eva_bus_t.axi_r[eva_bus_t.axi_rcmd_nums].size       = 4;  // 16bytes
            return ;
        }else if(eva_bus_t.axi_r[eva_bus_t.arid].valid){
            //fprintf(stderr," @EVA HDL detected repeat ID [%d] in AXI read command \n", eva_bus_t.awid );
        }else if(!eva_bus_t.axi_r[eva_bus_t.arid].valid){

            eva_bus_t.axi_r[eva_bus_t.arid].addr_base  = GEN_DMA_ADDR64( eva_bus_t.araddr_high, eva_bus_t.araddr_low);
            eva_bus_t.axi_r[eva_bus_t.arid].cur_addr   = eva_bus_t.axi_r[eva_bus_t.arid].addr_base;
            eva_bus_t.axi_r[eva_bus_t.arid].length     = eva_bus_t.arlen + 1;
            eva_bus_t.axi_r[eva_bus_t.arid].remain_len = eva_bus_t.axi_r[eva_bus_t.arid].length;
            eva_bus_t.axi_r[eva_bus_t.arid].burst      = eva_bus_t.arburst;
            eva_bus_t.axi_r[eva_bus_t.arid].size       = eva_bus_t.arsize;
            eva_bus_t.axi_r[eva_bus_t.arid].valid      = 1;
            eva_bus_t.axi_cur_rlock = rand()%10;
    
#ifdef EVA_AXI_DEBUG
            fprintf(stderr," @AXI [R] ID[%d] - addr: 0x%llx  length: %d - burst: %d  size: %d\n",
                    eva_bus_t.arid,
                    eva_bus_t.axi_r[eva_bus_t.arid].addr_base,
                    eva_bus_t.axi_r[eva_bus_t.arid].length,
                    eva_bus_t.axi_r[eva_bus_t.arid].burst,
                    eva_bus_t.axi_r[eva_bus_t.arid].size
                    );
#endif

            eva_bus_t.axi_rcmd_nums++;
            mark_active = 1;
        }
    }
  
    if((eva_bus_t.axi_rcmd_nums <= EVA_AXI_MAX_OUTSTANDING) &&
       mark_active && 
       eva_bus_t.axi_r[eva_bus_t.arid].valid &&
       (!eva_bus_t.axi_pre_arready)
       )
        *arready = 1;
    else
        *arready = 0;

    eva_bus_t.axi_pre_arready = *arready;

    // PART II : DATA PROCESS
    if( (eva_bus_t.axi_rcmd_nums > 0 ) && !eva_bus_t.axi_cur_ractive ){
        eva_bus_t.axi_cur_ractive = rand()%2  && (eva_bus_t.axi_cur_rlock == 0);
    
        if(eva_bus_t.axi_cur_ractive){
            for(cc=0; cc< EVA_AXI_MAX_PORT; cc++){
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
           ( eva_bus_t.rready && (eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].remain_len > 0)) ) {

            //*rvalid = rand()%2 || (eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].remain_len > 0);
            *rvalid = (rand()%16) < 4; 
      
            if(*rvalid){
                eva_bus_t.eva_t->axi_r_addr = eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].cur_addr;
                if(eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].size == 4)
                    eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].cur_addr += 16;
                else if(eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].size == 3)
                    eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].cur_addr += 8;

                barrier();
                eva_bus_t.eva_t->axi_r_sync = EVA_SYNC;
                barrier();
	
                timeout = 0;
                while(eva_bus_t.eva_t->axi_r_sync == EVA_SYNC){
                    timeout++;
                    if(timeout > 100000000){ // 1 million
                        fprintf(stderr," @EVA HDL axi_r_sync timeout , check SYSTEM !\n");
                        return ;
                    }
                }
	
                *rdata_0 = eva_bus_t.eva_t->axi_r_data0;
                *rdata_1 = eva_bus_t.eva_t->axi_r_data1;
                *rdata_2 = eva_bus_t.eva_t->axi_r_data2;
                *rdata_3 = eva_bus_t.eva_t->axi_r_data3;

                *ruser   = (eva_bus_t.eva_t->axi_r_addr >> 4) & 0xF;

                if(eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].remain_len > 0)
                    eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].remain_len--;

                if(eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].remain_len == 0){
                    *rlast = 1;
                }
            }

        }else{
            if(eva_bus_t.rready){
                eva_bus_t.axi_cur_ractive = 0;
                *rvalid = 0;
                *rlast  = 0;
                eva_bus_t.axi_r[eva_bus_t.axi_cur_rport].valid = 0;
	
                if(eva_bus_t.axi_rcmd_nums > 0)
                    eva_bus_t.axi_rcmd_nums--;
                else
                    fprintf(stderr," ERROR @EVA HDL rlast when no read command detected! @%x\n", eva_bus_t.dbg_id);

            }
        }
    }

    if(eva_bus_t.axi_cur_rlock > 0)
        eva_bus_t.axi_cur_rlock--;
  

}

void eva_axi_wr_func_i( const svBit        awvalid,
                        const svBitVecVal *awid,        // [5:0]
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
		      
                        const svBit        bready,

                        const svBit        wvalid,
                        const svBit        wlast,
                        const svBitVecVal *wid,                // [5:0]
                        const svBitVecVal *wdata_0,            // [31:0]
                        const svBitVecVal *wdata_1, 
                        const svBitVecVal *wdata_2,
                        const svBitVecVal *wdata_3,
                        const svBitVecVal *wstrb               // [15:0]
                        ){


	eva_bus_t.awvalid    =  awvalid; 
	eva_bus_t.awid       = *awid       & 0x3F; 
	eva_bus_t.awaddr_low = *awaddr_low; 
	eva_bus_t.awaddr_high= *awaddr_high; 
	eva_bus_t.awlen      = *awlen      & 0x3F; 
	eva_bus_t.awsize     = *awsize     & 0x7; 
	eva_bus_t.awburst    = *awburst    & 0x3; 
	eva_bus_t.awlock     =  awlock; 
	eva_bus_t.awcache    = *awcache    & 0xF; 
	eva_bus_t.awport     = *awport     & 0x7; 
	eva_bus_t.awregion   = *awregion   & 0xF; 
	eva_bus_t.awqos      = *awqos      & 0xF; 
	eva_bus_t.awuser     = *awuser     & 0xFF; 
			   
	eva_bus_t.bready     = bready;

	eva_bus_t.wvalid     =  wvalid; 
	eva_bus_t.wlast      =  wlast; 
	eva_bus_t.wid        = *wid        & 0xF; 
	eva_bus_t.wdata_0    = *wdata_0; 
	eva_bus_t.wdata_1    = *wdata_1; 
	eva_bus_t.wdata_2    = *wdata_2; 
	eva_bus_t.wdata_3    = *wdata_3; 
	eva_bus_t.wstrb      = *wstrb      & 0xFFFF; 



}

void eva_axi_wr_func_o( svBit  *awready,
						svBit  *wready,

						svBit  *bvalid,
						svBitVecVal *bresp,
						svBitVecVal *bid
						){
	int timeout = 0;

	int mark_active = 0;
    int fake_new = 0;
	// PART I : COMMAND PROCESS
	if(eva_bus_t.awvalid && (eva_bus_t.axi_wcmd_nums < EVA_AXI_MAX_OUTSTANDING) ){
    
		if( (eva_bus_t.awburst != 1) //|| (eva_bus_t.awsize != 4) 
            ){
			fprintf(stderr," @EVA HDL not support parameter detected in AXI write command  burst %x , size %x\n",
					eva_bus_t.awburst, eva_bus_t.awsize );

			//eva_bus_t.axi_w[eva_bus_t.awid].burst      = 1;  // INCR
			//eva_bus_t.axi_w[eva_bus_t.awid].size       = 4;  // 16bytes
			return ;
		}else if(eva_bus_t.axi_w[eva_bus_t.awid].valid){
			//fprintf(stderr," @EVA HDL detected repeat ID [%d] in AXI write command \n", eva_bus_t.arid );
            fake_new = 1;
		}else if(!eva_bus_t.axi_w[eva_bus_t.awid].valid){

			eva_bus_t.axi_w[eva_bus_t.awid].addr_base  = GEN_DMA_ADDR64( eva_bus_t.awaddr_high, eva_bus_t.awaddr_low);
			eva_bus_t.axi_w[eva_bus_t.awid].cur_addr   = eva_bus_t.axi_w[eva_bus_t.awid].addr_base;
			eva_bus_t.axi_w[eva_bus_t.awid].length     = eva_bus_t.awlen + 1;
			eva_bus_t.axi_w[eva_bus_t.awid].remain_len = eva_bus_t.axi_w[eva_bus_t.awid].length;
			eva_bus_t.axi_w[eva_bus_t.awid].burst      = eva_bus_t.awburst;
			eva_bus_t.axi_w[eva_bus_t.awid].size       = eva_bus_t.awsize;

			eva_bus_t.axi_w[eva_bus_t.awid].valid      = 1;
			eva_bus_t.axi_cur_wlock = rand()%3;
    
#ifdef EVA_AXI_DEBUG
            fprintf(stderr," @AXI [W] ID[%d] - addr: 0x%llx  length: %d - burst: %d  size: %d\n",
                    eva_bus_t.awid,
                    eva_bus_t.axi_w[eva_bus_t.awid].addr_base,
                    eva_bus_t.axi_w[eva_bus_t.awid].length,
                    eva_bus_t.axi_w[eva_bus_t.awid].burst,
                    eva_bus_t.axi_w[eva_bus_t.awid].size
                    );
#endif

			eva_bus_t.axi_wcmd_nums++;
			mark_active = 1;
		}
	}
  
	if((eva_bus_t.axi_wcmd_nums <= EVA_AXI_MAX_OUTSTANDING) &&
	   mark_active && 
	   eva_bus_t.axi_w[eva_bus_t.awid].valid &&
	   (!eva_bus_t.axi_pre_awready)
	   )
		*awready = 1;
	else
		*awready = 0;

	eva_bus_t.axi_pre_awready = *awready;

	// PART II : DATA PROCESS
	if( (!eva_bus_t.axi_cur_wactive) && 
        (eva_bus_t.axi_wcmd_nums > 0 ) && 
        (!fake_new) &&
		eva_bus_t.axi_w[eva_bus_t.wid].valid &&
		eva_bus_t.wvalid 
		){
		eva_bus_t.axi_cur_wactive = 1;
		eva_bus_t.axi_cur_wport   = eva_bus_t.wid;
	}
	// not suport AXI write data ahead command now !

	if(eva_bus_t.axi_cur_wactive && eva_bus_t.wvalid && eva_bus_t.wready_pre){

      
		eva_bus_t.eva_t->axi_w_addr = eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].cur_addr;
        if(eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].size == 4)
            eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].cur_addr += 16;
        else if(eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].size == 3)
            eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].cur_addr += 8;
    
		eva_bus_t.eva_t->axi_w_strb  = eva_bus_t.wstrb;
		eva_bus_t.eva_t->axi_w_data0 = eva_bus_t.wdata_0;
		eva_bus_t.eva_t->axi_w_data1 = eva_bus_t.wdata_1;
		eva_bus_t.eva_t->axi_w_data2 = eva_bus_t.wdata_2;
		eva_bus_t.eva_t->axi_w_data3 = eva_bus_t.wdata_3;

		barrier();
		eva_bus_t.eva_t->axi_w_sync = EVA_SYNC;
		barrier();

		timeout = 0;
		while(eva_bus_t.eva_t->axi_w_sync == EVA_SYNC){
			timeout++;
			if(timeout > 100000000){ // 1 million
				fprintf(stderr," @EVA HDL axi_w_sync timeout , check SYSTEM !\n");
				return ;
			}
		}
      
      
		if(eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].remain_len > 0)
			eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].remain_len--;

		if(eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].remain_len == 0){
			if( !eva_bus_t.wlast )
				fprintf(stderr," ERROR @EVA HDL wlast not detected in a write burst last! @%x\n", eva_bus_t.dbg_id);

			eva_bus_t.axi_w[eva_bus_t.axi_cur_wport].valid = 0;
			eva_bus_t.axi_cur_wactive = 0;
      
			if(eva_bus_t.axi_wcmd_nums > 0)
				eva_bus_t.axi_wcmd_nums--;
			else
				fprintf(stderr," ERROR @EVA HDL wlast when no write command detected! @%x\n", eva_bus_t.dbg_id);
		}

	}

	// *wready should update after eva_bus_t.axi_cur_wactive changed !
	*wready = (rand()%5 != 0) && eva_bus_t.axi_cur_wactive;  
  
	if(eva_bus_t.axi_cur_wlock > 0)
		eva_bus_t.axi_cur_wlock--;

	// brespone part
	// simple method : using latest WR CMD
	if((eva_bus_t.wlast && eva_bus_t.wvalid && eva_bus_t.wready_pre) ||
	   (!eva_bus_t.bready && eva_bus_t.bvalid_pre) // for simulator not supprt DPI signal hold ability
	   ){
		*bid    = eva_bus_t.wid;
		*bvalid = 1;
	}else if(eva_bus_t.bready && eva_bus_t.bvalid_pre){
		*bvalid = 0;
	}

	*bresp  = 0;                     // No error inject now

	// Backup old value
	eva_bus_t.bvalid_pre = *bvalid;  
	eva_bus_t.wready_pre = *wready;
}

void eva_hdl_intr( const svBitVecVal *intr ){
    uint32_t intr_s = *intr & 0xFFFFFFFF;
    if( (intr_s & eva_bus_t.eva_t->intr) == 0 )
        eva_bus_t.eva_t->intr = intr_s;
}

int evaScopeGet(char *path){
    vpiHandle   net;
    s_vpi_value val;

    net = vpi_handle_by_name(path, NULL);

    if( net == NULL){
        fprintf(stderr,"@evaScopeGet: %s  not exist !\n", path);
        return 0;
    }

    int Vector_size = vpi_get(vpiSize, net);

    if(Vector_size > 32){
        fprintf(stderr,"@evaScopeGet: %s vector size %d > 32 not support !\n", path, Vector_size);
        return 0;
    }{
        val.format = vpiIntVal;
        vpi_get_value(net, & val);

        return val.value.integer;
    }
  
}

void evaScopeGetHandle(){
    // do Get Process
    if( eva_bus_t.eva_t->get == EVA_GET_SYNC_REQ ){
        eva_bus_t.eva_t->getValue = evaScopeGet( eva_bus_t.eva_t->str );
        eva_bus_t.eva_t->get = EVA_GET_SYNC_ACK;
    }

}

#if 0
static s_vpi_systf_data systfList[] = {
    {vpiSysTask, 0, "$evaScopeGetHandle", evaScopeGetHandle, 0, 0, 0},
    {0},
};

void setup_eva_callbacks()
{
    p_vpi_systf_data systf_data_p = &(systfList[0]);

    while (systf_data_p->type)
        {
            vpi_register_systf(systf_data_p++);
            if (vpi_chk_error(NULL))
                {
                    vpi_printf("Error occured while setting up user %s\n",
                               "defined system tasks and functions.");
                    return;
                }
        }
}


void (*vlog_startup_routines[VPI_MAXARRAY])() =
{
    setup_eva_callbacks,
    0 /*** final entry must be 0 ***/
};
#endif


