
module IVS_PI_MGR(/*autoarg*/
    // Outputs
    dma_cmd_fetch_req, dma_rdata_rdy, dma_ar_len, dma_ar_base,
    dma_cmd_resp, frm_mode, frm_format, frm_line_stride, frm_width,
    frm_height, frm_x_steps, frm_y_steps, frm_x_stride, frm_y_stride,
    frm_i_base, frm_o_base, slot_load_par,
    // Inputs
    clk, rst_n, dma_ci, dma_cmd_base, dma_ar_rdy, dma_rdata_vld,
    dma_rdata_last, dma_rdata, slot_pro_done
    );
    parameter  IDLE      = 0;
    parameter  SEL_CHNL  = 1;
    parameter  FETCH_CMD = 2;
    parameter  LOAD_PAR  = 3;
    parameter  WAKE_PRO  = 4;
    parameter  WAIT_PROC = 5;
    parameter  CLR_PROC  = 6;

    input              clk;
    input              rst_n;

    input [31:0]       dma_ci;
    input [31:0]       dma_cmd_base;
  
    input              dma_ar_rdy;
    input              dma_rdata_vld;
    input              dma_rdata_last;
    input [63:0]       dma_rdata;
    
    output             dma_cmd_fetch_req;
    output             dma_rdata_rdy;
    output [4:0]       dma_ar_len;
    output [31:0]      dma_ar_base;
    output             dma_cmd_resp;


    output [2:0]       frm_mode;
    output [2:0]       frm_format;
    
    output [15:0]      frm_line_stride;
    output [15:0]      frm_width;
    output [15:0]      frm_height;
    output [15:0]      frm_x_steps;
    output [15:0]      frm_y_steps;

    output [15:0]      frm_x_stride;
    output [15:0]      frm_y_stride;
    
    output [31:0]      frm_i_base;
    output [31:0]      frm_o_base;

    output             slot_load_par;
    input              slot_pro_done;



    reg [2:0]          curr_slot_fsm;
    reg [2:0]          next_slot_fsm;
    
    reg [31:0]         slot_sel_bin;
    reg [4:0]          slot_sel_dec;

    wire               slot_idle      = curr_slot_fsm == IDLE     ;
    wire               slot_sel_chnl  = curr_slot_fsm == SEL_CHNL ;
    wire               slot_fetch_cmd = curr_slot_fsm == FETCH_CMD;
    wire               slot_load_par  = curr_slot_fsm == LOAD_PAR ;
    wire               slot_wake_pro  = curr_slot_fsm == WAKE_PRO ;
    wire               slot_wait_proc = curr_slot_fsm == WAIT_PROC;
    wire               slot_clr_proc  = curr_slot_fsm == CLR_PROC ;

    wire               slot_active = |dma_ci;

    wire [31:0]        slot_sel_bin_s;
    wire [4:0]         slot_sel_dec_s;

    assign dma_cmd_fetch_req = slot_fetch_cmd;

    IVS_ONEHOT_BIN_SEL U_IVS_ONEHOT_BIN_SEL
      (
       .ori   (dma_ci),
       .bin   (slot_sel_bin_s)
       );

    IVS_ONEHOT_DEC_SEL U_IVS_ONEHOT_DEC_SEL
      (
       .ori   (dma_ci),
       .dec   (slot_sel_dec_s)
       );

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        slot_sel_bin   <= 32'b0;
      else if(slot_sel_chnl)
        slot_sel_bin   <= slot_sel_bin_s;

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        slot_sel_dec   <= 32'b0;
      else if(slot_sel_chnl)
        slot_sel_dec   <= slot_sel_dec_s;

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        curr_slot_fsm   <= IDLE;
      else
        curr_slot_fsm   <= next_slot_fsm;

    always @( curr_slot_fsm )
      begin
          case( curr_slot_fsm )
              IDLE      : if(slot_active)       next_slot_fsm = SEL_CHNL;
              SEL_CHNL  :                       next_slot_fsm = FETCH_CMD;
              FETCH_CMD : if(dma_cmd_resp)      next_slot_fsm = LOAD_PAR;
              LOAD_PAR  :                       next_slot_fsm = WAKE_PRO;
              WAKE_PRO  :                       next_slot_fsm = WAIT_PROC;
              WAIT_PROC : if(slot_pro_done)     next_slot_fsm = CLR_PROC;
              CLR_PROC  :                       next_slot_fsm = IDLE;
              default   : next_slot_fsm = IDLE;
          endcase
      end


    IVS_SLOT_CMD_MGR U_IVS_SLOT_CMD_MGR(
                                        // Outputs
                                        .dma_cmd_fetch_req (dma_cmd_fetch_req),
                                        .dma_rdata_rdy     (dma_rdata_rdy),
                                        .dma_ar_len        (dma_ar_len),
                                        .dma_ar_base       (dma_ar_base),
                                        .dma_cmd_resp      (dma_cmd_resp),
                                        .frm_mode          (frm_mode),
                                        .frm_format        (frm_format),
                                        .frm_line_stride   (frm_line_stride),
                                        .frm_width         (frm_width),
                                        .frm_height        (frm_height),
                                        .frm_x_steps       (frm_x_steps),
                                        .frm_y_steps       (frm_y_steps),
                                        .frm_x_stride      (frm_x_stride),
                                        .frm_y_stride      (frm_y_stride),
                                        .frm_i_base        (frm_i_base),
                                        .frm_o_base        (frm_o_base),
                                        // Inputs
                                        .clk               (clk),
                                        .rst_n             (rst_n),
                                        .dma_cmd_base      (dma_cmd_base),
                                        .slot_fetch_en     (slot_fetch_en),
                                        .slot_sel_dec      (slot_sel_dec),
                                        .dma_ar_rdy        (dma_ar_rdy),
                                        .dma_rdata_vld     (dma_rdata_vld),
                                        .dma_rdata_last    (dma_rdata_last),
                                        .dma_rdata         (dma_rdata)
                                        );
    

endmodule // IVS_PI_MGR
