
module IVS_DMA_WR_INF(/*AUTOARG*/
    // Outputs
    awvalid,
    awid,
    awaddr,
    awlen,
    awsize,
    awburst,
    awlock,
    awcache,
    awprot,
    awregion,
    awqos,
    awuser,
    wvalid,
    wlast,
    wid,
    wdata,
    wstrb,
    dw0_ack,
    dw0_wrdy,
    dw0_valid,
    dw0_last,
    dw1_ack,
    dw1_wrdy,
    dw1_valid,
    dw1_last,
    // Inputs
    aclk,
    arst_n,
    awready,
    wready,
    dw0_req,
    dw0_base,
    dw0_len,
    dw0_wdata,
    dw1_req,
    dw1_base,
    dw1_len,
    dw1_wdata
    );
    input               aclk;
    input               arst_n;

    // BUS Interface
    input               awready;                     
    output              awvalid;                      
    output [3:0]        awid;        // [3:0]         
    output [31:0]       awaddr;                   
    output [5:0]        awlen;       // [5:0]         
    output [2:0]        awsize;      // [2:0]  3'b100 
    output [1:0]        awburst;     // [1:0]  2'b01  
    output              awlock;                       
    output [3:0]        awcache;     // [3:0]         
    output [2:0]        awprot;      // [2:0]         
    output [3:0]        awregion;    // [3:0]         
    output [3:0]        awqos;       // [3:0]         
    output [7:0]        awuser;      // [7:0]         
    
    input               wready;                       
    output              wvalid;                       
    output              wlast;                        
    output [3:0]        wid;         // [3:0]  
    output [`BDWD-1:0]  wdata;       // [31:0]    
    output [15:0]       wstrb ;      // [15:0] 

    // Port Interface
    input               dw0_req;     // dr: data write 
    input [31:0]        dw0_base;
    input [31:0]        dw0_len;
    output              dw0_ack;
    output              dw0_wrdy;
    input [`BDWD-1:0]   dw0_wdata;
    output              dw0_valid;
    output              dw0_last;
    
    input               dw1_req;     // dr: data write 
    input [31:0]        dw1_base;
    input [31:0]        dw1_len;
    output              dw1_ack;
    output              dw1_wrdy;
    input [`BDWD-1:0]   dw1_wdata;
    output              dw1_valid;
    output              dw1_last;
    
    
endmodule // IVS_DMA_WR_INF

