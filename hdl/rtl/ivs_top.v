
module IVS_TOP(/*AUTOARG*/
   // Outputs
   hready_out, hresp, hrdata, arvalid, arid, araddr, arlen, arsize,
   arburst, arlock, arcache, arport, arregion, arqos, aruser, rready,
   awvalid, awid, awaddr, awlen, awsize, awburst, awlock, awcache,
   awport, awregion, awqos, awuser, wvalid, wlast, wid, wdata, wstrb,
   // Inputs
   hclk, hrst_n, hsel, htrans, hwrite, haddr, hwdata, hsize, hburst,
   hprot, hready_in, aclk, arst_n, arready, rvalid, rid, rdata, rlast,
   rresp, awready, wready
   );

   input                hclk;
   input 				hrst_n;
   
   // AHB BUS
   input 				hsel;      
   input [1:0] 			htrans;      
   input 				hwrite;      
   input [31:0] 		haddr;       
   input [31:0] 		hwdata;      
   input [2:0] 			hsize;     
   input [2:0] 			hburst;    
   input [3:0] 			hprot;     
   input 				hready_in;
   
   output 				hready_out;
   output [1:0] 		hresp; 
   output [31:0] 		hrdata;

   input 				aclk;
   input 				arst_n;

   input 				arready;                     
   output 				arvalid;                     
   output [3:0] 		arid;        // [3:0]        
   output [31:0] 		araddr;                  
   output [5:0] 		arlen;       // [5:0]        
   output [2:0] 		arsize;      // [2:0]  3'b100
   output [1:0] 		arburst;     // [1:0]  2'b01 
   output 				arlock;                      
   output [3:0] 		arcache;     // [3:0]        
   output [2:0] 		arport;      // [2:0]        
   output [3:0] 		arregion;    // [3:0]        
   output [3:0] 		arqos;       // [3:0]        
   output [7:0] 		aruser;      // [7:0]        
   
   output 				rready;                      
   input 				rvalid;                      
   input [3:0] 			rid;                // [3:0] 
   input [127:0] 		rdata;            // [31:0]
   input 				rlast;                       
   input [1:0] 			rresp;   // [1:0] 


   input 				awready;                     
   output 				awvalid;                      
   output [3:0] 		awid;        // [3:0]         
   output [31:0] 		awaddr;                   
   output [5:0] 		awlen;       // [5:0]         
   output [2:0] 		awsize;      // [2:0]  3'b100 
   output [1:0] 		awburst;     // [1:0]  2'b01  
   output 				awlock;                       
   output [3:0] 		awcache;     // [3:0]         
   output [2:0] 		awport;      // [2:0]         
   output [3:0] 		awregion;    // [3:0]         
   output [3:0] 		awqos;       // [3:0]         
   output [7:0] 		awuser;      // [7:0]         
   
   input 				wready;                       
   output 				wvalid;                       
   output 				wlast;                        
   output [3:0] 		wid;                // [3:0]  
   output [127:0] 		wdata;            // [31:0]    
   output [15:0] 		wstrb ;   // [15:0] 

   /*AUTOWIRE*/
   
   IVS_SLV U_IVS_SLV(/*AUTOINST*/
					 // Outputs
					 .hready_out	(hready_out	),
					 .hresp			(hresp	),
					 .hrdata		(hrdata	),
					 .cfg_par0		(cfg_par0	),
					 .cfg_par1		(cfg_par1	),
					 .cfg_par2		(cfg_par2	),
					 .cfg_par3		(cfg_par3	),
					 .cfg_par4		(cfg_par4	),
					 .cfg_par5		(cfg_par5	),
					 .cfg_par6		(cfg_par6	),
					 .cfg_par7		(cfg_par7	),
					 .glb_ctrl		(glb_ctrl	),
					 .sw_rst		(sw_rst	),
					 // Inputs
					 .hclk			(hclk	),
					 .hrst_n		(hrst_n	),
					 .hsel			(hsel	),
					 .htrans		(htrans	),
					 .hwrite		(hwrite	),
					 .haddr			(haddr	),
					 .hwdata		(hwdata	),
					 .hsize			(hsize	),
					 .hburst		(hburst	),
					 .hprot			(hprot	),
					 .hready_in		(hready_in	)	
					 );

   
endmodule // IVS_TOP

// Local Variables:
// verilog-library-directories:("." )
// verilog-library-files:("ivs_slv.v" "ivs_dma_core.v")
// verilog-library-extensions:(".v" ".h")
// End:
