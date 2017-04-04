
module IVS_SLOT_CMD_MGR(/*autoarg*/
    // Outputs
    dma_cmd_fetch_req,
    dma_rdata_rdy,
    dma_ar_len,
    dma_ar_base,
    dma_cmd_resp,
    frm_mode,
    frm_format,
    frm_line_stride,
    frm_width,
    frm_height,
    frm_x_steps,
    frm_y_steps,
    frm_x_stride,
    frm_y_stride,
    frm_i_base,
    frm_o_base,
    // Inputs
    clk,
    rst_n,
    dma_cmd_base,
    slot_fetch_en,
    slot_sel_dec,
    dma_ar_rdy,
    dma_rdata_vld,
    dma_rdata_last,
    dma_rdata
    );

    parameter  IDLE      = 0;
    parameter  HOLD_REQ  = 1;
    parameter  PRO_CMD   = 2;
    parameter  RESP_CMD  = 3;

    parameter DATA_LEN   = 6;

    input               clk;
    input               rst_n;

    input [31:0]        dma_cmd_base;
    input               slot_fetch_en;
    input [4:0]         slot_sel_dec;

    input               dma_ar_rdy;
    input               dma_rdata_vld;
    input               dma_rdata_last;
    input [63:0]        dma_rdata;
    
    output              dma_cmd_fetch_req;
    output              dma_rdata_rdy;
    output [4:0]        dma_ar_len;
    output reg [31:0]   dma_ar_base;
    output              dma_cmd_resp;

    output [2:0]        frm_mode;
    output [2:0]        frm_format;
    
    output [15:0]       frm_line_stride;
    output [15:0]       frm_width;
    output [15:0]       frm_height;
    output [15:0]       frm_x_steps;
    output [15:0]       frm_y_steps;

    output [15:0]       frm_x_stride;
    output [15:0]       frm_y_stride;
    
    output [31:0]       frm_i_base;
    output [31:0]       frm_o_base;
    

    /* SLOT CMD Table*/
    reg [31:0]          slot_cmd_cfg0;
    reg [31:0]          slot_cmd_cfg1;
    reg [31:0]          slot_cmd_cfg2;
    reg [31:0]          slot_cmd_cfg3;
    reg [31:0]          slot_cmd_cfg4;
    reg [31:0]          slot_cmd_cfg5;

    reg [1:0]           vld_cnt;
    

    reg [1:0]           curr_cmdfet_fsm;
    reg [1:0]           next_cmdfet_fsm;

    wire                cmdfet_idle      = curr_cmdfet_fsm == IDLE    ;
    wire                cmdfet_hold_req  = curr_cmdfet_fsm == HOLD_REQ;
    wire                cmdfet_pro_cmd   = curr_cmdfet_fsm == PRO_CMD ;
    wire                cmdfet_resp_cmd  = curr_cmdfet_fsm == RESP_CMD;

    wire                slot_data_en = cmdfet_pro_cmd & dma_rdata_vld;
    wire                slot_last_data_en = dma_rdata_last & slot_data_en;

    wire [2:0]          vld_cnt_bin = { vld_cnt == 3'd0,
                                        vld_cnt == 3'd1,
                                        vld_cnt == 3'd2 };

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        dma_ar_base   <= 32'h0;
      else if(slot_fetch_en & cmdfet_idle)
        dma_ar_base   <= dma_cmd_base + {slot_sel_dec, 2'b0};

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        curr_cmdfet_fsm   <= IDLE;
      else
        curr_cmdfet_fsm   <= next_cmdfet_fsm;

    always @( curr_cmdfet_fsm )
      begin
          case( curr_cmdfet_fsm )
              IDLE      : if(slot_fetch_en)     next_cmdfet_fsm = HOLD_REQ;
              HOLD_REQ  : if(dma_ar_rdy)        next_cmdfet_fsm = PRO_CMD;
              PRO_CMD   : if(slot_last_data_en) next_cmdfet_fsm = RESP_CMD;
              RESP_CMD  :                       next_cmdfet_fsm = IDLE;
          endcase
      end
    
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        vld_cnt   <= 3'd0;
      else if(cmdfet_hold_req & dma_ar_rdy)
        vld_cnt   <= 3'd0;
      else if(slot_data_en)
        vld_cnt   <= vld_cnt + 1;
    

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        {slot_cmd_cfg1, slot_cmd_cfg0}   <= 32'h0;
      else if(slot_data_en & vld_cnt_bin[0] )
        {slot_cmd_cfg1, slot_cmd_cfg0}   <= dma_rdata[63:0];

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        {slot_cmd_cfg3, slot_cmd_cfg2}   <= 32'h0;
      else if(slot_data_en & vld_cnt_bin[1] )
        {slot_cmd_cfg3, slot_cmd_cfg2}   <= dma_rdata[63:0];
    
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        {slot_cmd_cfg5, slot_cmd_cfg4}   <= 32'h0;
      else if(slot_data_en & vld_cnt_bin[2] )
        {slot_cmd_cfg5, slot_cmd_cfg4}   <= dma_rdata[63:0];

    assign dma_ar_len = 5'd2;

    assign {frm_format, frm_mode} = slot_cmd_cfg0;
    assign frm_line_stride        = slot_cmd_cfg0[31:15];

    assign {frm_height, frm_width}  = slot_cmd_cfg1;
    assign {frm_y_steps, frm_x_steps} = slot_cmd_cfg2;

    assign frm_i_base = slot_cmd_cfg3;
    assign frm_o_base = slot_cmd_cfg4;

    assign {frm_y_stride, frm_x_stride} = slot_cmd_cfg5;

endmodule // IVS_SLOT_CMD_MGR
