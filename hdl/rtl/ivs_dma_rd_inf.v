
module IVS_DMA_RD_INF(/*AUTOARG*/
    // Outputs
    arvalid,
    arid,
    araddr,
    arlen,
    arsize,
    arburst,
    arlock,
    arcache,
    arport,
    arregion,
    arqos,
    aruser,
    rready,
    dr0_ack,
    dr0_rdata,
    dr0_valid,
    dr1_ack,
    dr1_rdata,
    dr1_valid,
    dr2_ack,
    dr2_rdata,
    dr2_valid,
    // Inputs
    aclk,
    arst_n,
    arready,
    rvalid,
    rid,
    rdata,
    rlast,
    rresp,
    dr0_req,
    dr0_base,
    dr0_len,
    dr1_req,
    dr1_base,
    dr1_len,
    dr2_req,
    dr2_base,
    dr2_len
    );
    input               aclk;
    input               arst_n;

    // BUS Interface
    input               arready;                     
    output              arvalid;                     
    output [3:0]        arid;        // [3:0]        
    output [31:0]       araddr;                  
    output [5:0]        arlen;       // [5:0]        
    output [2:0]        arsize;      // [2:0]  3'b100
    output [1:0]        arburst;     // [1:0]  2'b01 
    output              arlock;                      
    output [3:0]        arcache;     // [3:0]        
    output [2:0]        arport;      // [2:0]        
    output [3:0]        arregion;    // [3:0]        
    output [3:0]        arqos;       // [3:0]        
    output [7:0]        aruser;      // [7:0]        
    
    output              rready;                      
    input               rvalid;                      
    input [3:0]         rid;         // [3:0] 
    input [`BDWD-1:0]   rdata;       // [31:0]
    input               rlast;                       
    input [1:0]         rresp;       // [1:0] 

    // Port Interface
    input               dr0_req;     // dr: data read 
    input [31:0]        dr0_base;
    input [5:0]         dr0_len;
    output              dr0_ack;
    output [`BDWD-1:0]  dr0_rdata;
    output              dr0_valid;

    input               dr1_req;
    input [31:0]        dr1_base;
    input [5:0]         dr1_len;
    output              dr1_ack;
    output [`BDWD-1:0]  dr1_rdata;
    output              dr1_valid;

    input               dr2_req;
    input [31:0]        dr2_base;
    input [5:0]         dr2_len;
    output              dr2_ack;
    output [`BDWD-1:0]  dr2_rdata;
    output              dr2_valid;

    // Using Ping-pong ram buffer 
    reg                 pq_sel;

    // upgrate later 
    assign aruser    = 8'b0;
    assign arqos     = 4'b0;
    assign arregion  = 4'b0;
    assign arport    = 3'b0;
    assign arcache   = 4'b0;
    assign arlock    = 1'b0;
    assign arsize    = 3'b100;
    assign arid      = 4'b0;

    
    assign dr0_valid = rvalid & (rid == 4'd0);
    assign dr1_valid = rvalid & (rid == 4'd1);
    assign dr2_valid = rvalid & (rid == 4'd2);
    
    
endmodule // IVS_DMA_RD_INF

