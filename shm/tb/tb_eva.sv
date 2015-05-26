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
   arready, rvalid, rid, rdata, rlast, awready, wready,
   // Inputs
   hclk, hrest_n, hready_in, hresp, hrdata, aclk, arest_n, arvalid,
   arid, araddr, arlen, arsize, arburst, arlock, arcache, arport,
   arregion, arqos, aruser, rready, rresp, awvalid, awid, awaddr,
   awlen, awsize, awburst, awlock, awcache, awport, awregion, awqos,
   awuser, wvalid, wlast, wid, wdata, wstrb
   );

   parameter EVA_DLY_U = 0.1;
   
   input          hclk;
   input 	  hrest_n;


   output [1:0]   htrans;      
   output 	  hwrite;      
   output [31:0]  haddr;       
   output [31:0]  hwdata;      
   output [1:0]   hsize;     
   output [2:0]   hburst;    
   output [3:0]   hprot;     
   output 	  hready_out;
   
   input 	  hready_in;
   input [1:0] 	  hresp; 
   input [31:0]   hrdata;
    
   
   
   input 	  aclk;
   input 	  arest_n;
   
   output 	  arready;                     
   input 	  arvalid;                     
   input [3:0] 	  arid;        // [3:0]        
   input [31:0]   araddr;                  
   input [5:0] 	  arlen;       // [5:0]        
   input [2:0] 	  arsize;      // [2:0]  3'b100
   input [1:0] 	  arburst;     // [1:0]  2'b01 
   input 	  arlock;                      
   input [3:0] 	  arcache;     // [3:0]        
   input [2:0] 	  arport;      // [2:0]        
   input [3:0] 	  arregion;    // [3:0]        
   input [3:0] 	  arqos;       // [3:0]        
   input [7:0] 	  aruser;      // [7:0]        
   
   input 	  rready;                      
   output 	  rvalid;                      
   output [3:0]   rid;                // [3:0] 
   output [127:0] rdata;            // [31:0]
   output 	  rlast;                       
   input [1:0] 	  rresp;   // [1:0] 


   output 	  awready;                     
   input 	  awvalid;                      
   input [3:0] 	  awid;        // [3:0]         
   input [31:0]   awaddr;                   
   input [5:0] 	  awlen;       // [5:0]         
   input [2:0] 	  awsize;      // [2:0]  3'b100 
   input [1:0] 	  awburst;     // [1:0]  2'b01  
   input 	  awlock;                       
   input [3:0] 	  awcache;     // [3:0]         
   input [2:0] 	  awport;      // [2:0]         
   input [3:0] 	  awregion;    // [3:0]         
   input [3:0] 	  awqos;       // [3:0]         
   input [7:0] 	  awuser;      // [7:0]         
   
   output 	  wready;                       
   input 	  wvalid;                       
   input 	  wlast;                        
   input [3:0] 	  wid;                // [3:0]  
   input [127:0]  wdata;            // [31:0]    
   input [15:0]   wstrb ;   // [15:0] 



   assign hsize  = 2'b10;
   assign hburst = 3'b0;
   assign hprot  = 4'b0;

   reg 		  hready_in_s;
   reg [1:0] 	  hresp_s; 
   reg [31:0] 	  hrdata_s;

   always @(posedge hclk)
     begin
	hready_in_s <= hready_in;
	hresp_s     <= hresp;  	
	hrdata_s    <= hrdata; 	
     end

   assign hready_out = hready_in;
   
   always @(posedge hclk)
     if(hrest_n)
       #EVA_DLY_U eva_ahb_bus_func( htrans,
				    hwrite,
				    haddr,
				    hwdata,
				    //hsize,
				    //hburst,
				    //hprot,

				    hready_s,
				    hresp_s,
				    hrdata_s
				    );
   




   
endmodule // TB_EVA
