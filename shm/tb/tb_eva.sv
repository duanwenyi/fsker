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
   arready, rvalid, rid, rdata, rlast, rresp, awready, wready,
   // Inputs
   hclk, hrest_n, hready_in, hresp, hrdata, aclk, arest_n, arvalid,
   arid, araddr, arlen, arsize, arburst, arlock, arcache, arport,
   arregion, arqos, aruser, rready, awvalid, awid, awaddr,
   awlen, awsize, awburst, awlock, awcache, awport, awregion, awqos,
   awuser, wvalid, wlast, wid, wdata, wstrb
   );

   parameter EVA_DLY_U = 0.1;

   import "DPI-C" function void eva_hdl_init();
   import "DPI-C" function void eva_hdl_stop(output bit stop);

   import "DPI-C" function void eva_ahb_bus_func_i( input bit       hready,
						    input bit [1:0] hresp,
						    input bit [31:0] hrdata
						    );
   
   import "DPI-C" function void eva_ahb_bus_func_o( output bit [1:0]  htrans,
						    output bit 	      hwrite,
						    output bit [31:0] haddr,
						    output bit [31:0] hwdata
						    );
   
   import "DPI-C" function void eva_axi_rd_func_i( input bit        arvalid,
						   input bit [3:0]  arid,        // [3:0]
						   input bit [31:0] araddr_low,
						   input bit [31:0] araddr_high,
						   input bit [5:0]  arlen,       // [5:0]
						   input bit [2:0]  arsize,      // [2:0]  3'b100  (16 bytes)
						   input bit [1:0]  arburst,     // [1:0]  2'b01
						   input bit        arlock,
						   input bit [3:0]  arcache,     // [3:0]
						   input bit [2:0]  arport,      // [2:0]
						   input bit [3:0]  arregion,    // [3:0]
						   input bit [3:0]  arqos,       // [3:0]
						   input bit [7:0]  aruser,      // [7:0]
   
						   input bit        rready
						   );

   import "DPI-C" function void eva_axi_rd_func_o( output bit        arready,
						   output bit        rvalid,
						   output bit [3:0]  rid,                // [3:0]
						   output bit [31:0] rdata_0,            // [31:0]
						   output bit [31:0] rdata_1, 
						   output bit [31:0] rdata_2,
						   output bit [31:0] rdata_3,
						   output bit        rlast,
						   output bit [1:0]  rresp               // [1:0]
						   );
   
   import "DPI-C" function void eva_axi_wr_func_i( input bit        awvalid,
						   input bit [3:0]  awid, // [3:0]
						   input bit [31:0] awaddr_low,
						   input bit [31:0] awaddr_high,
						   input bit [5:0]  awlen, // [5:0]
						   input bit [2:0]  awsize, // [2:0]  3'b100  (16 bytes)
						   input bit [1:0]  awburst, // [1:0]  2'b01
						   input bit 	    awlock,
						   input bit [3:0]  awcache, // [3:0]
						   input bit [2:0]  awport, // [2:0]
						   input bit [3:0]  awregion, // [3:0]
						   input bit [3:0]  awqos, // [3:0]
						   input bit [7:0]  awuser, // [7:0]
   
						   input bit 	    wvalid,
						   input bit 	    wlast,
						   input bit [3:0]  wid, // [3:0]
						   input bit [31:0] wdata_0, // [31:0]
						   input bit [31:0] wdata_1, 
						   input bit [31:0] wdata_2,
						   input bit [31:0] wdata_3,
						   input bit [15:0] wstrb               // [15:0]
						   );

   import "DPI-C" function void eva_axi_wr_func_o( output bit awready,
						   output bit wready
						   );

   
   input                    hclk;
   input 		    hrest_n;

   input 		    aclk;
   input 		    arest_n;

   output bit [1:0] 	    htrans;      
   output bit 		    hwrite;      
   output bit [31:0] 	    haddr;       
   output bit [31:0] 	    hwdata;      
   output bit [1:0] 	    hsize;     
   output bit [2:0] 	    hburst;    
   output bit [3:0] 	    hprot;     
   output bit 		    hready_out;
   
   input bit 		    hready_in;
   input bit [1:0] 	    hresp; 
   input bit [31:0] 	    hrdata;
   
   
   
   
   output bit 		    arready;                     
   input bit 		    arvalid;                     
   input bit [3:0] 	    arid;        // [3:0]        
   input bit [31:0] 	    araddr;                  
   input bit [5:0] 	    arlen;       // [5:0]        
   input bit [2:0] 	    arsize;      // [2:0]  3'b100
   input bit [1:0] 	    arburst;     // [1:0]  2'b01 
   input bit 		    arlock;                      
   input bit [3:0] 	    arcache;     // [3:0]        
   input bit [2:0] 	    arport;      // [2:0]        
   input bit [3:0] 	    arregion;    // [3:0]        
   input bit [3:0] 	    arqos;       // [3:0]        
   input bit [7:0] 	    aruser;      // [7:0]        
   
   input bit 		    rready;                      
   output bit 		    rvalid;                      
   output bit [3:0] 	    rid;                // [3:0] 
   output bit [127:0] 	    rdata;            // [31:0]
   output bit 		    rlast;                       
   output bit [1:0] 	    rresp;   // [1:0] 


   output bit 		    awready;                     
   input bit 		    awvalid;                      
   input bit [3:0] 	    awid;        // [3:0]         
   input bit [31:0] 	    awaddr;                   
   input bit [5:0] 	    awlen;       // [5:0]         
   input bit [2:0] 	    awsize;      // [2:0]  3'b100 
   input bit [1:0] 	    awburst;     // [1:0]  2'b01  
   input bit 		    awlock;                       
   input bit [3:0] 	    awcache;     // [3:0]         
   input bit [2:0] 	    awport;      // [2:0]         
   input bit [3:0] 	    awregion;    // [3:0]         
   input bit [3:0] 	    awqos;       // [3:0]         
   input bit [7:0] 	    awuser;      // [7:0]         
   
   output bit 		    wready;                       
   input bit 		    wvalid;                       
   input bit 		    wlast;                        
   input bit [3:0] 	    wid;                // [3:0]  
   input bit [127:0] 	    wdata;            // [31:0]    
   input bit [15:0] 	    wstrb ;   // [15:0] 


   bit 			    stop;

   assign hsize  = 2'b10;
   assign hburst = 3'b0;
   assign hprot  = 4'b0;

   assign hready_out = hready_in;
   
   always @(posedge hclk)
     if(hrest_n) begin
       eva_ahb_bus_func_i( hready_in,
			   hresp,
			   hrdata
			   );

	#EVA_DLY_U 
	  eva_ahb_bus_func_o( htrans,
			      hwrite,
			      haddr,
			      hwdata
			      );
 
     end
   
   always @(posedge aclk)
     if(arest_n) begin
	eva_axi_rd_func_i( arvalid,
			   arid,        // [3:0]
			   araddr,
			   32'b0,
			   arlen,       // [5:0]
			   arsize,      // [2:0]  3'b100  (16 bytes)
			   arburst,     // [1:0]  2'b01
			   arlock,
			   arcache,     // [3:0]
			   arport,      // [2:0]
			   arregion,    // [3:0]
			   arqos,       // [3:0]
			   aruser,      // [7:0]
	
			   rready
			   );

	#EVA_DLY_U 
	  eva_axi_rd_func_o( arready,
			     rvalid,
			     rid,                // [3:0]
			     rdata[ 31: 0],            // [31:0]
			     rdata[ 63:32], 
			     rdata[ 95:64],
			     rdata[127:96],
			     rlast,
			     rresp               // [1:0]
			     );
     end

   always @(posedge aclk)
     if(arest_n) begin
	eva_axi_wr_func_i( awvalid,
			   awid, // [3:0]
			   awaddr,
			   32'b0,
			   awlen, // [5:0]
			   awsize, // [2:0]  3'b100  (16 bytes)
			   awburst, // [1:0]  2'b01
			   awlock,
			   awcache, // [3:0]
			   awport, // [2:0]
			   awregion, // [3:0]
			   awqos, // [3:0]
			   awuser, // [7:0]
	
			   wvalid,
			   wlast,
			   wid, // [3:0]
			   wdata[ 31: 0], // [31:0]
			   wdata[ 63:32], 
			   wdata[ 95:64],
			   wdata[127:96],
			   wstrb               // [15:0]
			   );

	#EVA_DLY_U 
	  eva_axi_wr_func_o( awready,
			     wready
			     );
     end

   initial begin
      @(posedge hrest_n);
      eva_hdl_init();
   end
   
   
   always @(posedge aclk)
     if(arest_n) begin
	eva_hdl_stop(stop);

	if(stop)begin
	   $display(" @EVA SW STOPED ");
	   #50ns;
	   $finish();
	end
     end

   always @(posedge aclk)
     if(arest_n) begin
	$evaScopeGetHandle;
     end
   
endmodule // TB_EVA
