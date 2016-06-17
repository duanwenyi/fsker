
module IVS_DMA_CORE(/*AUTOARG*/
   // Outputs
   arvalid, arid, araddr, arlen, arsize, arburst, arlock, arcache,
   arport, arregion, arqos, aruser, rready, awvalid, awid, awaddr,
   awlen, awsize, awburst, awlock, awcache, awport, awregion, awqos,
   awuser, wvalid, wlast, wid, wdata, wstrb,
   // Inputs
   aclk, arst_n, arready, rvalid, rid, rdata, rlast, rresp, awready,
   wready
   );
    input               aclk;
    input               arst_n;

    input               awready;                     
    output              awvalid;                      
    output [3:0]        awid;        // [3:0]         
    output [31:0]       awaddr;                   
    output [5:0]        awlen;       // [5:0]         
    output [2:0]        awsize;      // [2:0]  3'b100 
    output [1:0]        awburst;     // [1:0]  2'b01  
    output              awlock;                       
    output [3:0]        awcache;     // [3:0]         
    output [2:0]        awport;      // [2:0]         
    output [3:0]        awregion;    // [3:0]         
    output [3:0]        awqos;       // [3:0]         
    output [7:0]        awuser;      // [7:0]         
    
    input               wready;                       
    output              wvalid;                       
    output              wlast;                        
    output [3:0]        wid;                // [3:0]  
    output [127:0]      wdata;            // [31:0]    
    output [15:0]       wstrb ;   // [15:0] 

    input               dw_req;
    input [31:0]        dw_base;
    input [31:0]        dw_len;
    
endmodule // IVS_DMA_CORE
