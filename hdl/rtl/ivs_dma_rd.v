
module IVS_DMA_RD(/*AUTOARG*/
   // Outputs
   arvalid, arid, araddr, arlen, arsize, arburst, arlock, arcache,
   arport, arregion, arqos, aruser, rready,
   // Inputs
   aclk, arst_n, arready, rvalid, rid, rdata, rlast, rresp
   );
   input               aclk;
   input 	       arst_n;

   input 	       arready;                     
   output 	       arvalid;                     
   output [3:0]        arid;        // [3:0]        
   output [31:0]       araddr;                  
   output [5:0]        arlen;       // [5:0]        
   output [2:0]        arsize;      // [2:0]  3'b100
   output [1:0]        arburst;     // [1:0]  2'b01 
   output 	       arlock;                      
   output [3:0]        arcache;     // [3:0]        
   output [2:0]        arport;      // [2:0]        
   output [3:0]        arregion;    // [3:0]        
   output [3:0]        arqos;       // [3:0]        
   output [7:0]        aruser;      // [7:0]        
   
   output 	       rready;                      
   input 	       rvalid;                      
   input [3:0] 	       rid;                // [3:0] 
   input [127:0]       rdata;            // [31:0]
   input 	       rlast;                       
   input [1:0] 	       rresp;   // [1:0] 

   input 	       dr_req;
   input [31:0]        dr_base;
   input [5:0] 	       dr_len;
   input [3:0] 	       dr_rid;

   // Using Ping-pong ram buffer 
   reg 		       pq_sel;

   // upgrate later 
   assign aruser    = 8'b0;
   assign arqos     = 4'b0;
   assign arregion  = 4'b0;
   assign arport    = 3'b0;
   assign arcache   = 4'b0;
   assign arlock    = 1'b0;
   assign arsize    = 3'b100;
   assign arid      = 4'b0;
   
   
   
   
   
   
   
endmodule // IVS_DMA_CORE
