//-----------------------------------------------------------------------------
// Title         : EVA BUS FUNC TOP
// Project       : EVA
//-----------------------------------------------------------------------------
// File          : tb_eva.sv
// Author        : Apachee  <apachee@localhost.localdomain>
// Created       : 26.05.2015
// Last modified : 26.05.2015
//-----------------------------------------------------------------------------
// Description :
// 
//-----------------------------------------------------------------------------
// Copyright (c) 2015 by Fsker This model is the confidential and
// proprietary property of Fsker and the possession or use of this
// file requires a written license from Fsker.
//------------------------------------------------------------------------------
// Modification history :
// 26.05.2015 : created
//-----------------------------------------------------------------------------



module TB_EVA(/*AUTOARG*/
   // Outputs
   htrans, hwrite, haddr, hwdata, hsize, hburst, hprot, hready_out,
   arready, rvalid, rid, ruser, rdata, rlast, rresp, awready, wready, 
   bvalid, bresp, bid,
   // Inputs
   hclk, hrest_n, aclk, arest_n, hready_in, hresp, hrdata, arvalid,
   arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot,
   arregion, arqos, aruser, rready, awvalid, awid, awaddr, awlen,
   awsize, awburst, awlock, awcache, awprot, awregion, awqos, awuser,
   wvalid, wlast, wid, wdata, wstrb, bready
   );

    parameter EVA_DLY_U = 0.1;

    parameter SLV_AW = 32;
    parameter SLV_DW = 32;

    import "DPI-C" function void eva_hdl_init( input bit en_slv,
                                               input bit [31:0] slv_cfg,
                                               input bit        en_mst,
                                               input bit [31:0] mst_cfg,
                                               input bit        en_int,
                                               input bit        en_get
                                               );
    import "DPI-C" function void eva_hdl_alive( output bit stop,
                                                output bit error
                                                );

    import "DPI-C" function void eva_ahb_bus_func_i( input bit        hready,
													 input bit [1:0]  hresp,
													 input bit [31:0] hrdata,
													 input bit [31:0] hrdata_u
													 );
    
    import "DPI-C" function void eva_ahb_bus_func_o( output bit [1:0]  htrans,
													 output bit        hwrite,
                                                     output bit [2:0]  hsize,
													 output bit [31:0] haddr,
													 output bit [31:0] haddr_u,
													 output bit [31:0] hwdata,
													 output bit [31:0] hwdata_u
													 );
    
    import "DPI-C" function void eva_axi_rd_func_i( input bit        arvalid,
												    input bit [5:0]  arid, // [5:0]
												    input bit [31:0] araddr_low,
												    input bit [31:0] araddr_high,
												    input bit [5:0]  arlen, // [5:0]
												    input bit [2:0]  arsize, // [2:0]  3'b100  (16 bytes)
												    input bit [1:0]  arburst, // [1:0]  2'b01
												    input bit        arlock,
												    input bit [3:0]  arcache, // [3:0]
												    input bit [2:0]  arprot, // [2:0]
												    input bit [3:0]  arregion, // [3:0]
												    input bit [3:0]  arqos, // [3:0]
												    input bit [7:0]  aruser, // [7:0]
    
												    input bit        rready
												    );

    import "DPI-C" function void eva_axi_rd_func_o( output bit        arready,
												    output bit        rvalid,
												    output bit [5:0]  rid,     // [5:0]
												    output bit [4:0]  ruser,   // [4:0]
												    output bit [31:0] rdata_0, // [31:0]
												    output bit [31:0] rdata_1, 
												    output bit [31:0] rdata_2,
												    output bit [31:0] rdata_3,
												    output bit        rlast,
												    output bit [1:0]  rresp               // [1:0]
												    );
    
    import "DPI-C" function void eva_axi_wr_func_i( input bit        awvalid,
												    input bit [5:0]  awid, // [5:0]
												    input bit [31:0] awaddr_low,
												    input bit [31:0] awaddr_high,
												    input bit [5:0]  awlen, // [5:0]
												    input bit [2:0]  awsize, // [2:0]  3'b100  (16 bytes)
												    input bit [1:0]  awburst, // [1:0]  2'b01
												    input bit        awlock,
												    input bit [3:0]  awcache, // [3:0]
												    input bit [2:0]  awprot, // [2:0]
												    input bit [3:0]  awregion, // [3:0]
												    input bit [3:0]  awqos, // [3:0]
												    input bit [7:0]  awuser, // [7:0]

												    input bit        bready,
    
												    input bit        wvalid,
												    input bit        wlast,
												    input bit [5:0]  wid, // [5:0]
												    input bit [31:0] wdata_0, // [31:0]
												    input bit [31:0] wdata_1, 
												    input bit [31:0] wdata_2,
												    input bit [31:0] wdata_3,
												    input bit [15:0] wstrb               // [15:0]
												    );

    import "DPI-C" function void eva_axi_wr_func_o( output bit        awready,
												    output bit        wready,
	    
												    output bit        bvalid,
												    output bit [ 1:0] bresp,
												    output bit [ 5:0] bid
												    );

    input                     hclk;
    input                     hrest_n;
    
    input                     aclk;
    input                     arest_n;
    
    output bit [1:0]          htrans;      
    output bit                hwrite;      
    output bit [SLV_AW-1:0]   haddr;       
    output bit [SLV_DW-1:0]   hwdata;      
    output bit [2:0]          hsize;     
    output bit [2:0]          hburst;    
    output bit [3:0]          hprot;     
    output bit                hready_out;
    
    input bit                 hready_in;
    input bit [1:0]           hresp; 
    input bit [SLV_DW-1:0]    hrdata;
    
    // AXI Read  Part
    output bit                arready;                     
    input bit                 arvalid;                     
    input bit [5:0]           arid;        // [3:0]        
    input bit [63:0]          araddr;                  
    input bit [5:0]           arlen;       // [5:0]        
    input bit [2:0]           arsize;      // [2:0]  3'b100
    input bit [1:0]           arburst;     // [1:0]  2'b01 
    input bit                 arlock;                      
    input bit [3:0]           arcache;     // [3:0]        
    input bit [2:0]           arprot;      // [2:0]        
    input bit [3:0]           arregion;    // [3:0]        
    input bit [3:0]           arqos;       // [3:0]        
    input bit [7:0]           aruser;      // [7:0]        
    
    input bit                 rready;                      
    output bit                rvalid;                      
    output bit [5:0]          rid;         // [5:0] 
    output bit [4:0]          ruser;       // [4:0] 
    output bit [127:0]        rdata;       // [31:0]
    output bit                rlast;                  
    output bit [1:0]          rresp;       // [1:0] 

    // AXI Write Part
    output bit                awready;                     
    input bit                 awvalid;                      
    input bit [5:0]           awid;        // [3:0]         
    input bit [63:0]          awaddr;                   
    input bit [5:0]           awlen;       // [5:0]         
    input bit [2:0]           awsize;      // [2:0]  3'b100 
    input bit [1:0]           awburst;     // [1:0]  2'b01  
    input bit                 awlock;                       
    input bit [3:0]           awcache;     // [3:0]         
    input bit [2:0]           awprot;      // [2:0]         
    input bit [3:0]           awregion;    // [3:0]         
    input bit [3:0]           awqos;       // [3:0]         
    input bit [7:0]           awuser;      // [7:0]         
    
    output bit                wready;                       
    input bit                 wvalid;                       
    input bit                 wlast;                        
    input bit [5:0]           wid;                // [3:0]  
    input bit [127:0]         wdata;            // [31:0]    
    input bit [15:0]          wstrb ;   // [15:0] 

    output bit                bvalid;
    output bit [ 1:0]         bresp;
    output bit [ 5:0]         bid;
    input                     bready;
    
    bit                       error;
    bit                       stop;
    reg [63:0]                tick;    // Using for debug

    reg                       active;

    bit [63:0]                haddr_tmp;
    bit [63:0]                hwdata_tmp;
    bit [63:0]                hrdata_tmp;

    assign haddr  = haddr_tmp[SLV_AW-1:0];
    assign hwdata = hwdata_tmp[SLV_DW-1:0];
    assign hrdata_tmp[SLV_DW-1:0] = hrdata;

    generate
        if(SLV_DW == 32 ) begin : GEN_HRDATA_UPPER_ZERO
          assign hrdata_tmp[63:32] = 32'h0;
        end else if(SLV_DW == 64 ) begin : GEN_HRDATA_UPPER
          assign hrdata_tmp[63:32] = hrdata;
        end
    endgenerate
    

    //assign (weak1,weak0)  arid = 6'b0;
    //assign (weak1,weak0)  wrid = 6'b0;
    

    //assign hsize  = 3'b10;
    assign hburst = 3'b0;
    assign hprot  = 4'b0;

    assign hready_out = hready_in;
    
    always @(posedge hclk)
      if(active) begin
		  eva_ahb_bus_func_i( hready_in,
							  hresp,
							  hrdata,
							  hrdata_tmp[63:32]
							  );

		  #EVA_DLY_U 
		    eva_ahb_bus_func_o( htrans,
							    hwrite,
                                hsize,
							    haddr_tmp[31:0],
							    haddr_tmp[63:32],
							    hwdata_tmp[31:0],
							    hwdata_tmp[63:32]
							    );
		  
      end

    
    always @(posedge aclk)
      if(active) begin
		  eva_axi_rd_func_i( arvalid,
						     arid,        // [5:0]
						     araddr[31:0],
						     araddr[63:32],
						     arlen,       // [5:0]
						     arsize,      // [2:0]  3'b100  (16 bytes)
						     arburst,     // [1:0]  2'b01
						     arlock,
						     arcache,     // [3:0]
						     arprot,      // [2:0]
						     arregion,    // [3:0]
						     arqos,       // [3:0]
						     aruser,      // [7:0]
		  
						     rready
						     );

		  #EVA_DLY_U 
		    eva_axi_rd_func_o( arready,
							   rvalid,
							   rid,                // [5:0]
                               ruser,
							   rdata[ 31: 0],      // [31:0]
							   rdata[ 63:32], 
							   rdata[ 95:64],
							   rdata[127:96],
							   rlast,
							   rresp               // [1:0]
							   );
      end

    always @(posedge aclk)
      if(active) begin
		  eva_axi_wr_func_i( awvalid,
						     awid,          // [5:0]
						     awaddr[31:0],
						     awaddr[63:32],
						     awlen,         // [5:0]
						     awsize,        // [2:0]  3'b100  (16 bytes)
						     awburst,       // [1:0]  2'b01
						     awlock,
						     awcache,       // [3:0]
						     awprot,        // [2:0]
						     awregion,      // [3:0]
						     awqos,         // [3:0]
						     awuser,        // [7:0]

						     bready,
		  
						     wvalid,
						     wlast,
						     wid,           // [3:0]
						     wdata[ 31: 0], // [31:0]
						     wdata[ 63:32], 
						     wdata[ 95:64],
						     wdata[127:96],
						     wstrb          // [15:0]
						     );

		  #EVA_DLY_U 
		    eva_axi_wr_func_o( awready,
							   wready,

							   bvalid,
							   bresp,
							   bid
							   );
      end
    
    initial begin
        active = 1'b0;

        @(posedge hrest_n );
        wait(arest_n == 1'b1);
        #10ns;
        @(posedge aclk );
        
        active = 1'b1;
        eva_hdl_init( 1'b1,
                      {8'd0,8'd0,8'd32,8'd32},
                      1'b1,
                      {8'd128,8'd64,8'd128,8'd64},
                      1'b1,
                      1'b1
                      );
    end
    
    always @(posedge aclk or negedge arest_n)
      if(~arest_n)
        tick  <= 64'b0;
      else
        tick  <= tick + 1;
    
    always @(posedge aclk)
      if(active) begin
		  eva_hdl_alive(stop, error);

		  if(stop)begin
		      $display(" @EVA SW STOPED ");
		      #1us;
		      $finish();
		  end
      end
    
endmodule // TB_EVA


module TB_EVA_INTR(
				   // Inputs
				   clk, rst_n, interrupt
				   );
    import "DPI-C" function void eva_hdl_intr( input bit [31:0]   intr);

    input          clk;
    input          rst_n;
    
    input [31:0]   interrupt;

    reg [31:0]     intr_ff;

    always @(posedge clk)
      if(~rst_n)
        intr_ff   <= 32'b0;
      else
        intr_ff   <= interrupt;

    // calculate the rose trigger
    wire [31:0]    intr_msi = interrupt & ~intr_ff;

    always @(posedge clk)
      if(rst_n & (|intr_msi))
        eva_hdl_intr( intr_msi );
    
endmodule // TB_EVA_INTR
