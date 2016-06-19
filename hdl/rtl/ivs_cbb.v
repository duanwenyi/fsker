//-----------------------------------------------------------------------------
// Title         : IVS CBB
// Project       : Fsker
//-----------------------------------------------------------------------------
// File          : ivs_cbb.v
// Author        : Apachee  <apachee@CCC>
// Created       : 19.06.2016
// Last modified : 19.06.2016
//-----------------------------------------------------------------------------
// Description :
// 
//-----------------------------------------------------------------------------
// Copyright (c) 2016 by SpAcW This model is the confidential and
// proprietary property of SpAcW and the possession or use of this
// file requires a written license from SpAcW.
//------------------------------------------------------------------------------
// Modification history :
// 19.06.2016 : created
//-----------------------------------------------------------------------------

//----------------------------------------------------
// A three level, round-robin arbiter.
//----------------------------------------------------
module IVS_DMA_RR_I2(/*autoarg*/
    // Outputs
    ack,
    comreq,
    grant_o,
    // Inputs
    clk,
    rst_n,
    req,
    resp
    );

    input               clk;
    input               rst_n;

    input [1:0]         req;
    input               resp;

    output [1:0]        ack;
    output              comreq;
    output              grant_o;    // 

    reg                 arb;
    reg                 grant_o;

    
    wire                wake_arb = ~arb & (|req);
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        arb       <= 1'b0;
      else if(wake_arb)
        arb       <= 1'b1;
      else if( arb & resp)
        arb       <= 1'b0;
    
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        grant_o       <= 1'b0;
      else if(wake_arb)
        case(grant_o)
            1'b0:  grant_o <= req[1];
            1'b1:  grant_o <= req[0];
        endcase // case (grant_o)

    assign ack = {2{resp}} & {grant_o, ~grant_o };

    assign comreq = arb;
    
endmodule

//----------------------------------------------------
// A three level, round-robin arbiter.
//----------------------------------------------------
module IVS_DMA_RR_I3(/*autoarg*/
    // Outputs
    ack,
    comreq,
    grant_o,
    // Inputs
    clk,
    rst_n,
    req,
    resp
    );

    input               clk;
    input               rst_n;

    input [2:0]         req;
    input               resp;

    output [2:0]        ack;
    output              comreq;
    output [1:0]        grant_o;    // 

    reg                 arb;
    reg [1:0]           grant_o;

    
    wire                wake_arb = ~arb & (|req);
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        arb       <= 1'b0;
      else if(wake_arb)
        arb       <= 1'b1;
      else if( arb & resp)
        arb       <= 1'b0;
    
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        grant_o       <= 2'b00;
      else if(wake_arb)
        case(grant_o)
            2'b00:
              case(req)
                  3'b001: grant_o <= 2'b00;
                  3'b010: grant_o <= 2'b01;
                  3'b100: grant_o <= 2'b10;
                  3'b011: grant_o <= 2'b01;
                  3'b101: grant_o <= 2'b10;
                  3'b110: grant_o <= 2'b01;
                  3'b111: grant_o <= 2'b01;
                  default: grant_o <= 2'b00;
              endcase
            2'b01:
              case(req)
                  3'b001: grant_o <= 2'b00;
                  3'b010: grant_o <= 2'b01;
                  3'b100: grant_o <= 2'b10;
                  3'b011: grant_o <= 2'b00;
                  3'b101: grant_o <= 2'b10;
                  3'b110: grant_o <= 2'b10;
                  3'b111: grant_o <= 2'b10;
                  default: grant_o <= 2'b01;
              endcase
            2'b10:
              case(req)
                  3'b001: grant_o <= 2'b00;
                  3'b010: grant_o <= 2'b01;
                  3'b100: grant_o <= 2'b10;
                  3'b011: grant_o <= 2'b00;
                  3'b101: grant_o <= 2'b00;
                  3'b110: grant_o <= 2'b01;
                  3'b111: grant_o <= 2'b00;
                  default: grant_o <= 2'b10;
              endcase
            default:      grant_o <= 2'b00;
        endcase // case (grant_o)

    assign ack = {3{resp}} & {grant_o == 2'b10, 
                              grant_o == 2'b01,
                              grant_o == 2'b00 };

    assign comreq = arb;
    
endmodule


//----------------------------------------------------
// A four level, round-robin arbiter.
//----------------------------------------------------
module IVS_DMA_RR_I4(/*autoarg*/
    // Outputs
    ack,
    comreq,
    grant_o,
    // Inputs
    clk,
    rst_n,
    req,
    resp
    );

    input           clk;    
    input           rst_n;    

    input [3:0]     req;
    input           resp;

    output [3:0]    ack;
    output          comreq;
    output [1:0]    grant_o;    // 

    reg             arb;
    reg [1:0]       grant_o;

    wire [3:0]      lgnt;

    wire            wake_arb = ~arb & (|req);
    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        arb       <= 1'b0;
      else if(wake_arb)
        arb       <= 1'b1;
      else if( arb & resp)
        arb       <= 1'b0;

    assign lgnt[0]  = ( ((grant_o == 2'b0 ) & ~req3 & ~req2 & ~req1 ) |
                        ((grant_o == 2'b1 ) & ~req3 & ~req2 &       ) |
                        ((grant_o == 2'b2 ) & ~req3 &               ) |
                        ((grant_o == 2'b3 )                         ) ) & req0;
    assign lgnt[1]  = ( ((grant_o == 2'b1 ) & ~req3 & ~req2 & ~req0 ) |
                        ((grant_o == 2'b2 ) & ~req3 &         ~req0 ) |
                        ((grant_o == 2'b3 ) &                 ~req0 ) |
                        ((grant_o == 2'b0 )                         ) ) & req1;
    assign lgnt[2]  = ( ((grant_o == 2'b2 ) & ~req3 & ~req1 & ~req0 ) |
                        ((grant_o == 2'b3 ) &         ~req1 & ~req0 ) |
                        ((grant_o == 2'b0 ) &         ~req1         ) |
                        ((grant_o == 2'b1 )                         ) ) & req2;
    assign lgnt[3]  = ( ((grant_o == 2'b3 ) & ~req2 & ~req1 & ~req0 ) |
                        ((grant_o == 2'b0 ) & ~req2 & ~req1         ) |
                        ((grant_o == 2'b1 ) & ~req2                 ) |
                        ((grant_o == 2'b2 )                         ) ) & req3;

    assign  lgnt =  {(lgnt3 | lgnt2),(lgnt3 | lgnt1)};

    always @(posedge clk or negedge rst_n)
      if(~rst_n)
        grant_o       <= 2'b00;
      else if(wake_arb)
        grant_o       <= lgnt;
    
    assign ack = {4{resp}} & {grant_o == 2'b11,
                              grant_o == 2'b10, 
                              grant_o == 2'b01,
                              grant_o == 2'b00 };

    assign comreq = arb;
endmodule
