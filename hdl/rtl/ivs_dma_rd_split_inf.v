
module IVS_DMA_RD_SPLIT_INF (/*AUTOARG*/
    // Outputs
    ori_ack,
    ori_rdata,
    ori_valid,
    ori_rlast,
    split_req,
    split_base,
    split_len,
    split_rdy,
    // Inputs
    clk,
    rst_n,
    sw_rst,
    ori_req,
    ori_base,
    ori_bytes,
    split_ack,
    split_rdata,
    split_valid,
    split_rlast
    ) ;

    input               clk;
    input               rst_n;

    input               sw_rst;
    
    input               ori_req;
    input [31:0]        ori_base;
    input [7:0]         ori_bytes;
    output              ori_ack;

    //input               ori_rdy;
    output [`BDWD-1:0]  ori_rdata;
    output              ori_valid;
    output              ori_rlast;

    output              split_req;
    output [31:0]       split_base;
    output [3:0]        split_len;
    input               split_ack;

    output              split_rdy;
    input [`BDWD-1:0]   split_rdata;
    input               split_valid;
    input               split_rlast;

    /*
     Feature list:
     1. split long burst to max 16
     2. deal with 4k address across
     3. align rdata to 8 bytes 
     */

    parameter IDLE     = 0;
    parameter PRE_CAL  = 1;
    parameter CMD_REQ  = 2;
    parameter DATA_PRO = 3;
    parameter POS_CAL  = 4;

    reg [2:0]           curr_split_fsm;
    reg [2:0]           next_split_fsm;

    wire                split_idle      = curr_split_fsm == IDLE    ;
    wire                split_pre_cal   = curr_split_fsm == PRE_CAL ;
    wire                split_cmd_req   = curr_split_fsm == CMD_REQ ;
    wire                split_data_pro  = curr_split_fsm == DATA_PRO;
    wire                split_pos_cal   = curr_split_fsm == POS_CAL ;

    reg                 sw_rst_pro;

    reg [31:0]          cur_rbase;
    reg [7:0]           cur_left_bytes_minus1;
    reg [6:0]           cur_max_bytes;
    reg [3:0]           cur_len;

    reg [2:0]           bytes_ofst;

    reg                 split_last;   // last split burst

    reg [`BDWD-1:0]     split_rdata_ff;
    reg [`BDWD-1:0]     split_rdata_ff2;

    reg                 valid_i_da_en_ff;
    reg                 valid_i_da_en_ff2;
    
    wire                ori_init = ori_req & split_idle;
    wire                sw_rst_condi_met = ~split_cmd_req & ~split_data_pro;

    wire                valid_i_da_en      = split_valid & split_rdy;
    wire                valid_i_da_en_last = split_rlast & valid_i_da_en;

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        curr_split_fsm   <= IDLE;
      else
        curr_split_fsm   <= next_split_fsm;

    always @( curr_split_fsm )
      begin
          case( curr_split_fsm ):CURR_SPLIT_FSM_PRO
              IDLE      : begin
                  if(ori_req & ~sw_rst_pro)
                    next_split_fsm = PRE_CAL;
                  else
                    next_split_fsm = IDLE;
              end
              PRE_CAL   :begin
                  next_split_fsm = CMD_REQ;
              end
              CMD_REQ   : begin
                  if(split_ack)   
                    next_split_fsm = DATA_PRO;
                  else
                    next_split_fsm = CMD_REQ;
              end
              DATA_PRO  : begin
                  if(valid_i_da_en_last) 
                    next_split_fsm = POS_CAL;
                  else
                    next_split_fsm = DATA_PRO;
              end
              POS_CAL   :begin
                  if(~split_last & ~sw_rst_pro)
                    next_split_fsm = PRE_CAL;
                  else
                    next_split_fsm = IDLE;
              end
              default   :   next_split_fsm = IDLE;
          endcase
      end

    
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        sw_rst_pro   <= 1'b0;
      else if(sw_rst)
        sw_rst_pro   <= 1'b1;
      else if(sw_rst_condi_met)
        sw_rst_pro   <= 1'b0;

    /*
     Cross 4K  & Split Brust algorithm:
     */
    wire [31:0]         final_pos = cur_rbase + cur_left_bytes_minus1;
    wire                cur_cross_4k = final_pos[12]^cur_rbase[12];
    wire                left_bytes_not_full = ~cur_left_bytes_minus1[7] & ~( &cur_left_bytes_minus1);
    wire [6:0]          cur_max_bytes_minus1 = ( cur_cross_4k ? (~cur_rbase[6:0]) :
                                                 left_bytes_not_full ? cur_left_bytes_minus1[6:0]:
                                                 7'h7F );

    wire [3:0]          cur_max_burst = cur_max_bytes_minus1[6:3];

    
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        bytes_ofst   <= 32'b0;
      else if(ori_init)
        bytes_ofst   <= ori_base[2:0];

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        split_last   <= 32'b0;
      else if(split_req & split_ack)
        split_last   <= left_bytes_not_full & ~cur_cross_4k;

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        cur_rbase   <= 32'b0;
      else if(ori_init)
        cur_rbase   <= ori_base;
      else if(split_req & split_ack)
        cur_rbase   <= cur_rbase + cur_max_bytes;

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        cur_left_bytes_minus1   <= 8'b0;
      else if(ori_init)
        cur_left_bytes_minus1   <= ori_bytes - 1;
      else if(split_req & split_ack)
        cur_left_bytes_minus1   <= cur_left_bytes_minus1 - cur_max_bytes;

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        cur_max_bytes   <= 7'b0;
      else if(split_pre_cal)
        cur_max_bytes   <= cur_max_bytes_minus1 + 1;
    
    
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        cur_len   <= 4'b0;
      else if(split_pre_cal)
        cur_len   <= cur_max_burst;


    /*
     8 Bytes alignment
     */

    wire                bt_not_aligned = bytes_ofst != 3'd0;
    wire                fake_i_da_en   = (split_last & split_pos_cal & bt_not_aligned);
    wire                fix_i_da_en    = valid_i_da_en | fake_i_da_en;

    wire                fix_i_da_last  = fake_i_da_en | (~bt_not_aligned & valid_i_da_en_last);

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        fix_i_da_last_ff   <= 1'b0;
      else if(fix_i_da_last^fix_i_da_last_ff)
        fix_i_da_last_ff   <= fix_i_da_last;

    assign ori_rlast = fix_i_da_last_ff;
    
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        split_rdata_ff   <= 32'b0;
      else if(fix_i_da_en)
        split_rdata_ff   <= split_rdata;
      
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        split_rdata_ff2   <= 32'b0;
      else if(fix_i_da_en)
        split_rdata_ff2   <= split_rdata_ff;

    assign ori_rdata = ( {64{bytes_ofst == 3'd0}} & split_rdata_ff |
                         {64{bytes_ofst == 3'd1}} & {split_rdata_ff2[ 7:0], split_rdata_ff[63:8]} |
                         {64{bytes_ofst == 3'd2}} & {split_rdata_ff2[15:0], split_rdata_ff[63:16]} |
                         {64{bytes_ofst == 3'd3}} & {split_rdata_ff2[23:0], split_rdata_ff[63:24]} |
                         {64{bytes_ofst == 3'd4}} & {split_rdata_ff2[31:0], split_rdata_ff[63:32]} |
                         {64{bytes_ofst == 3'd5}} & {split_rdata_ff2[39:0], split_rdata_ff[63:40]} |
                         {64{bytes_ofst == 3'd6}} & {split_rdata_ff2[47:0], split_rdata_ff[63:48]} |
                         {64{bytes_ofst == 3'd7}} & {split_rdata_ff2[55:0], split_rdata_ff[63:56]} )
                         
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        valid_i_da_en_ff   <= 32'b0;
      else if(fix_i_da_en^valid_i_da_en_ff)
        valid_i_da_en_ff   <= valid_i_da_en;
    
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        valid_i_da_en_ff2   <= 32'b0;
      else if(valid_i_da_en_ff^valid_i_da_en_ff2)
        valid_i_da_en_ff2   <= valid_i_da_en_ff;

    assign ori_valid = valid_i_da_en_ff2;
    

endmodule // IVS_DMA_SPLIT_INF
