
module IVS_TOP(/*AUTOARG*/
    // Outputs
    hready_out,
    hresp,
    hrdata,
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
    awvalid,
    awid,
    awaddr,
    awlen,
    awsize,
    awburst,
    awlock,
    awcache,
    awport,
    awregion,
    awqos,
    awuser,
    wvalid,
    wlast,
    wid,
    wdata,
    wstrb,
    // Inputs
    hclk,
    hrst_n,
    hsel,
    htrans,
    hwrite,
    haddr,
    hwdata,
    hsize,
    hburst,
    hprot,
    hready_in,
    aclk,
    arst_n,
    arready,
    rvalid,
    rid,
    rdata,
    rlast,
    rresp,
    awready,
    wready
    );

    input                hclk;
    input                hrst_n;
    
    // AHB BUS
    input                hsel;      
    input [1:0]          htrans;      
    input                hwrite;      
    input [31:0]         haddr;       
    input [31:0]         hwdata;      
    input [2:0]          hsize;     
    input [2:0]          hburst;    
    input [3:0]          hprot;     
    input                hready_in;
    
    output               hready_out;
    output [1:0]         hresp; 
    output [31:0]        hrdata;

    input                aclk;
    input                arst_n;

    input                arready;                     
    output               arvalid;                     
    output [3:0]         arid;        // [3:0]        
    output [31:0]        araddr;                  
    output [5:0]         arlen;       // [5:0]        
    output [2:0]         arsize;      // [2:0]  3'b100
    output [1:0]         arburst;     // [1:0]  2'b01 
    output               arlock;                      
    output [3:0]         arcache;     // [3:0]        
    output [2:0]         arport;      // [2:0]        
    output [3:0]         arregion;    // [3:0]        
    output [3:0]         arqos;       // [3:0]        
    output [7:0]         aruser;      // [7:0]        
    
    output               rready;                      
    input                rvalid;                      
    input [3:0]          rid;                // [3:0] 
    input [`BDWD-1:0]    rdata;            // [31:0]
    input                rlast;                       
    input [1:0]          rresp;   // [1:0] 


    input                awready;                     
    output               awvalid;                      
    output [3:0]         awid;        // [3:0]         
    output [31:0]        awaddr;                   
    output [5:0]         awlen;       // [5:0]         
    output [2:0]         awsize;      // [2:0]  3'b100 
    output [1:0]         awburst;     // [1:0]  2'b01  
    output               awlock;                       
    output [3:0]         awcache;     // [3:0]         
    output [2:0]         awport;      // [2:0]         
    output [3:0]         awregion;    // [3:0]         
    output [3:0]         awqos;       // [3:0]         
    output [7:0]         awuser;      // [7:0]         
    
    input                wready;                       
    output               wvalid;                       
    output               wlast;                        
    output [3:0]         wid;                // [3:0]  
    output [`BDWD-1:0]   wdata;            // [31:0]    
    output [15:0]        wstrb ;   // [15:0] 

    /*AUTOWIRE*/
    // Beginning of automatic wires (for undeclared instantiated-module outputs)
    wire [31:0]         cfg_par0;               // From U_IVS_SLV of IVS_SLV.v
    wire [31:0]         cfg_par1;               // From U_IVS_SLV of IVS_SLV.v
    wire [31:0]         cfg_par2;               // From U_IVS_SLV of IVS_SLV.v
    wire [31:0]         cfg_par3;               // From U_IVS_SLV of IVS_SLV.v
    wire [31:0]         cfg_par4;               // From U_IVS_SLV of IVS_SLV.v
    wire [31:0]         cfg_par5;               // From U_IVS_SLV of IVS_SLV.v
    wire [31:0]         cfg_par6;               // From U_IVS_SLV of IVS_SLV.v
    wire [31:0]         cfg_par7;               // From U_IVS_SLV of IVS_SLV.v
    wire [31:0]         dma_ar_base;            // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [4:0]          dma_ar_len;             // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire                dma_cmd_fetch_req;      // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire                dma_cmd_resp;           // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire                dma_rdata_rdy;          // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire                dr0_ack;                // From U_IVS_DMA_RD_INF of IVS_DMA_RD_INF.v
    wire [`BDWD-1:0]    dr0_rdata;              // From U_IVS_DMA_RD_INF of IVS_DMA_RD_INF.v
    wire                dr0_valid;              // From U_IVS_DMA_RD_INF of IVS_DMA_RD_INF.v
    wire                dr1_ack;                // From U_IVS_DMA_RD_INF of IVS_DMA_RD_INF.v
    wire [`BDWD-1:0]    dr1_rdata;              // From U_IVS_DMA_RD_INF of IVS_DMA_RD_INF.v
    wire                dr1_valid;              // From U_IVS_DMA_RD_INF of IVS_DMA_RD_INF.v
    wire                dr2_ack;                // From U_IVS_DMA_RD_INF of IVS_DMA_RD_INF.v
    wire [`BDWD-1:0]    dr2_rdata;              // From U_IVS_DMA_RD_INF of IVS_DMA_RD_INF.v
    wire                dr2_valid;              // From U_IVS_DMA_RD_INF of IVS_DMA_RD_INF.v
    wire                dw0_ack;                // From U_IVS_DMA_WR_INF of IVS_DMA_WR_INF.v
    wire                dw0_last;               // From U_IVS_DMA_WR_INF of IVS_DMA_WR_INF.v
    wire                dw0_valid;              // From U_IVS_DMA_WR_INF of IVS_DMA_WR_INF.v
    wire                dw0_wrdy;               // From U_IVS_DMA_WR_INF of IVS_DMA_WR_INF.v
    wire                dw1_ack;                // From U_IVS_DMA_WR_INF of IVS_DMA_WR_INF.v
    wire                dw1_last;               // From U_IVS_DMA_WR_INF of IVS_DMA_WR_INF.v
    wire                dw1_valid;              // From U_IVS_DMA_WR_INF of IVS_DMA_WR_INF.v
    wire                dw1_wrdy;               // From U_IVS_DMA_WR_INF of IVS_DMA_WR_INF.v
    wire [2:0]          frm_format;             // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [15:0]         frm_height;             // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [31:0]         frm_i_base;             // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [15:0]         frm_line_stride;        // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [2:0]          frm_mode;               // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [31:0]         frm_o_base;             // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [15:0]         frm_width;              // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [15:0]         frm_x_steps;            // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [15:0]         frm_x_stride;           // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [15:0]         frm_y_steps;            // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [15:0]         frm_y_stride;           // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire [31:0]         glb_ctrl;               // From U_IVS_SLV of IVS_SLV.v
    wire                slot_load_par;          // From UIVS_PI_MGR of IVS_PI_MGR.v
    wire                sw_rst;                 // From U_IVS_SLV of IVS_SLV.v
    // End of automatics
    
    IVS_SLV U_IVS_SLV(/*AUTOINST*/
                      // Outputs
                      .hready_out       (hready_out),
                      .hresp            (hresp[1:0]),
                      .hrdata           (hrdata[31:0]),
                      .cfg_par0         (cfg_par0[31:0]),
                      .cfg_par1         (cfg_par1[31:0]),
                      .cfg_par2         (cfg_par2[31:0]),
                      .cfg_par3         (cfg_par3[31:0]),
                      .cfg_par4         (cfg_par4[31:0]),
                      .cfg_par5         (cfg_par5[31:0]),
                      .cfg_par6         (cfg_par6[31:0]),
                      .cfg_par7         (cfg_par7[31:0]),
                      .glb_ctrl         (glb_ctrl[31:0]),
                      .sw_rst           (sw_rst),
                      // Inputs
                      .hclk             (hclk),
                      .hrst_n           (hrst_n),
                      .hsel             (hsel),
                      .htrans           (htrans[1:0]),
                      .hwrite           (hwrite),
                      .haddr            (haddr[31:0]),
                      .hwdata           (hwdata[31:0]),
                      .hsize            (hsize[2:0]),
                      .hburst           (hburst[2:0]),
                      .hprot            (hprot[3:0]),
                      .hready_in        (hready_in));


    IVS_PI_MGR UIVS_PI_MGR(/*autoinst*/
                           // Outputs
                           .dma_cmd_fetch_req   (dma_cmd_fetch_req),
                           .dma_rdata_rdy       (dma_rdata_rdy),
                           .dma_ar_len          (dma_ar_len[4:0]),
                           .dma_ar_base         (dma_ar_base[31:0]),
                           .dma_cmd_resp        (dma_cmd_resp),
                           .frm_mode            (frm_mode[2:0]),
                           .frm_format          (frm_format[2:0]),
                           .frm_line_stride     (frm_line_stride[15:0]),
                           .frm_width           (frm_width[15:0]),
                           .frm_height          (frm_height[15:0]),
                           .frm_x_steps         (frm_x_steps[15:0]),
                           .frm_y_steps         (frm_y_steps[15:0]),
                           .frm_x_stride        (frm_x_stride[15:0]),
                           .frm_y_stride        (frm_y_stride[15:0]),
                           .frm_i_base          (frm_i_base[31:0]),
                           .frm_o_base          (frm_o_base[31:0]),
                           .slot_load_par       (slot_load_par),
                           // Inputs
                           .clk                 (clk),
                           .rst_n               (rst_n),
                           .dma_ci              (dma_ci[31:0]),
                           .dma_cmd_base        (dma_cmd_base[31:0]),
                           .dma_ar_rdy          (dma_ar_rdy),
                           .dma_rdata_vld       (dma_rdata_vld),
                           .dma_rdata_last      (dma_rdata_last),
                           .dma_rdata           (dma_rdata[63:0]),
                           .slot_pro_done       (slot_pro_done));


    IVS_DMA_RD_INF U_IVS_DMA_RD_INF(/*autoinst*/
                                    // Outputs
                                    .arvalid            (arvalid),
                                    .arid               (arid[3:0]),
                                    .araddr             (araddr[31:0]),
                                    .arlen              (arlen[5:0]),
                                    .arsize             (arsize[2:0]),
                                    .arburst            (arburst[1:0]),
                                    .arlock             (arlock),
                                    .arcache            (arcache[3:0]),
                                    .arport             (arport[2:0]),
                                    .arregion           (arregion[3:0]),
                                    .arqos              (arqos[3:0]),
                                    .aruser             (aruser[7:0]),
                                    .rready             (rready),
                                    .dr0_ack            (dr0_ack),
                                    .dr0_rdata          (dr0_rdata[`BDWD-1:0]),
                                    .dr0_valid          (dr0_valid),
                                    .dr1_ack            (dr1_ack),
                                    .dr1_rdata          (dr1_rdata[`BDWD-1:0]),
                                    .dr1_valid          (dr1_valid),
                                    .dr2_ack            (dr2_ack),
                                    .dr2_rdata          (dr2_rdata[`BDWD-1:0]),
                                    .dr2_valid          (dr2_valid),
                                    // Inputs
                                    .aclk               (aclk),
                                    .arst_n             (arst_n),
                                    .arready            (arready),
                                    .rvalid             (rvalid),
                                    .rid                (rid[3:0]),
                                    .rdata              (rdata[`BDWD-1:0]),
                                    .rlast              (rlast),
                                    .rresp              (rresp[1:0]),
                                    .dr0_req            (dr0_req),
                                    .dr0_base           (dr0_base[31:0]),
                                    .dr0_len            (dr0_len[5:0]),
                                    .dr1_req            (dr1_req),
                                    .dr1_base           (dr1_base[31:0]),
                                    .dr1_len            (dr1_len[5:0]),
                                    .dr2_req            (dr2_req),
                                    .dr2_base           (dr2_base[31:0]),
                                    .dr2_len            (dr2_len[5:0]));

    IVS_DMA_WR_INF U_IVS_DMA_WR_INF(/*autoinst*/
                                    // Outputs
                                    .awvalid            (awvalid),
                                    .awid               (awid[3:0]),
                                    .awaddr             (awaddr[31:0]),
                                    .awlen              (awlen[5:0]),
                                    .awsize             (awsize[2:0]),
                                    .awburst            (awburst[1:0]),
                                    .awlock             (awlock),
                                    .awcache            (awcache[3:0]),
                                    .awport             (awport[2:0]),
                                    .awregion           (awregion[3:0]),
                                    .awqos              (awqos[3:0]),
                                    .awuser             (awuser[7:0]),
                                    .wvalid             (wvalid),
                                    .wlast              (wlast),
                                    .wid                (wid[3:0]),
                                    .wdata              (wdata[`BDWD-1:0]),
                                    .wstrb              (wstrb[15:0]),
                                    .dw0_ack            (dw0_ack),
                                    .dw0_wrdy           (dw0_wrdy),
                                    .dw0_valid          (dw0_valid),
                                    .dw0_last           (dw0_last),
                                    .dw1_ack            (dw1_ack),
                                    .dw1_wrdy           (dw1_wrdy),
                                    .dw1_valid          (dw1_valid),
                                    .dw1_last           (dw1_last),
                                    // Inputs
                                    .aclk               (aclk),
                                    .arst_n             (arst_n),
                                    .awready            (awready),
                                    .wready             (wready),
                                    .dw0_req            (dw0_req),
                                    .dw0_base           (dw0_base[31:0]),
                                    .dw0_len            (dw0_len[31:0]),
                                    .dw0_wdata          (dw0_wdata[`BDWD-1:0]),
                                    .dw1_req            (dw1_req),
                                    .dw1_base           (dw1_base[31:0]),
                                    .dw1_len            (dw1_len[31:0]),
                                    .dw1_wdata          (dw1_wdata[`BDWD-1:0]));

endmodule // IVS_TOP

// Local Variables:
// verilog-library-directories:("." )
// verilog-library-files:("ivs_slv.v" "ivs_dma_core.v" "ivs_pi_mgr.v" "ivs_dma_rd_inf.v" "ivs_dma_wr_inf.v")
// verilog-library-extensions:(".v" ".h")
// End:
