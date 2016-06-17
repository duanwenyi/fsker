
module IVS_ONEHOT_DEC_SEL(/*autoarg*/
    // Outputs
    dec,
    // Inputs
    ori
    );
    input [31:0]    ori;
    output [4:0]    dec;

    assign dec = ori[ 0] ? 5'd0 :
                 ori[ 1] ? 5'd1 :
                 ori[ 2] ? 5'd2 :
                 ori[ 3] ? 5'd3 :
                 ori[ 4] ? 5'd4 :
                 ori[ 5] ? 5'd5 :
                 ori[ 6] ? 5'd6 :
                 ori[ 7] ? 5'd7 :
                 ori[ 8] ? 5'd8 :
                 ori[ 9] ? 5'd9 :
                 ori[10] ? 5'd10 :
                 ori[11] ? 5'd11 :
                 ori[12] ? 5'd12 :
                 ori[13] ? 5'd13 :
                 ori[14] ? 5'd14 :
                 ori[15] ? 5'd15 :
                 ori[16] ? 5'd16 :
                 ori[17] ? 5'd17 :
                 ori[18] ? 5'd18 :
                 ori[19] ? 5'd19 :
                 ori[20] ? 5'd20 :
                 ori[21] ? 5'd21 :
                 ori[22] ? 5'd22 :
                 ori[23] ? 5'd23 :
                 ori[24] ? 5'd24 :
                 ori[25] ? 5'd25 :
                 ori[26] ? 5'd26 :
                 ori[27] ? 5'd27 :
                 ori[28] ? 5'd28 :
                 ori[29] ? 5'd29 :
                 ori[30] ? 5'd30 :
                 ori[31] ? 5'd31 : 32'h0;
    
    
endmodule // IVS_ONEHOT_DEC_SEL


