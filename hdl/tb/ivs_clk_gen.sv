
module IVS_CLK_GEN(/*AUTOARG*/
   // Outputs
   aclk, hclk, arst_n, hrst_n
   );

    output reg     aclk;
    output reg     hclk;
    
    output reg     arst_n;
    output reg     hrst_n;


    initial begin
        aclk = 1'b0;
        #3.3ns;
        // 800 MHz
        forever begin
	        #6.25ns;
	        aclk = ~aclk;
        end
    end
    
    initial begin
        hclk = 1'b0;
        #3.7ns;
        // 400 MHz
        forever begin
	        #12.5ns;
	        hclk = ~hclk;
        end
    end

    initial begin
        arst_n  = 1'b0;
        #500ns;
        arst_n  = 1'b1;
    end
    
    initial begin
        hrst_n  = 1'b0;
        #450ns;
        hrst_n  = 1'b1;
    end
    
endmodule // IVS_CLK_GEN

