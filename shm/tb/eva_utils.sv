
module EVA_MEM(/*AUTOARG*/
   // Outputs
   Q,
   // Inputs
   CLK, RST_N, CS, REN, WEN, A, D
   );

   parameter WIDTH    = 32;
   parameter DEPTH    = 128;
   parameter MASKBITS = 1;

   parameter EVA_DLY_U = 0.1;
   
   import "DPI-C" function chandle emem_init(input int width,
					     input int depth,
					     input int mskbits
					     );
   
   import "DPI-C" function void emem_wr_acc( chandle p,
					     input bit [31:0] addr,
					     input bit [31:0] wmsk,
					     input bit [7:0]  wdata[]
					     );

   import "DPI-C" function void emem_rd_acc_i( chandle p,
					       input bit [31:0] addr
					       );

   import "DPI-C" function void emem_rd_acc_o( chandle p,
					       output bit [7:0] rdata[]
					       );

   input                 CLK;
   input 		 RST_N;

   // not as real memory 
   input 		 CS;
   input 		 REN;
   input [MASKBITS-1:0]  WEN;
   input [DEPTH-1:0] 	 A;
   input [WIDTH-1:0] 	 D;
   output [WIDTH-1:0] 	 Q;

   chandle 		 mem;
   
   bit [7:0] 		 wdata[15:0];
   bit [7:0] 		 rdata[15:0];

   bit [31:0] 		 addr = A;
   bit [31:0] 		 wmsk = ~WEN & {MASKBITS{~CS}};

   initial begin
      mem = emem_init(WIDTH, DEPTH, MASKBITS);
   end

   integer     cc;
   always @(posedge CLK)
     if(~RST_N)begin
	for(cc=0; cc<(WIDTH/8); cc=cc+1)begin
	   wdata[cc] = D[(cc*8)+:8];
	end
     end
   
   assign Q = { rdata[15],rdata[14],rdata[13],rdata[12],
		rdata[11],rdata[10],rdata[9] ,rdata[8],
		rdata[7] ,rdata[6] ,rdata[5] ,rdata[4],
		rdata[3] ,rdata[2] ,rdata[1] ,rdata[0]
	       };
   
   always @(posedge CLK)
     if(~RST_N)
       emem_wr_acc( mem,
		    addr,
		    wmsk,
		    wdata
		    );
   
   always @(posedge CLK)
     if(~RST_N) begin
       emem_rd_acc_i( mem,
		      addr
		      );
	#EVA_DLY_U emem_rd_acc_o( mem,
				  rdata
				  );
     end
   

endmodule // EVA_MEM

// Add normal wrap for better HUMAN think !
module EVA_MEM_WRAP(/*AUTOARG*/
   // Outputs
   rdata,
   // Inputs
   clk, rst_n, rd, we, addr, wdata
   );

   parameter WIDTH    = 32;
   parameter DEPTH    = 128;
   parameter MASKBITS = 1;

   input                 clk;
   input 		 rst_n;

   input 		 rd;
   input [MASKBITS-1:0]	 we;
   input [DEPTH-1:0] 	 addr;
   input [WIDTH-1:0] 	 wdata;
   output [WIDTH-1:0] 	 rdata;

   wire 		 CS = ~(rd | (|we));
   wire 		 REN = ~rd;
   wire 		 WEN = ~we;
   
   
   EVA_MEM U_MEM( 
		 // Outputs
		 .Q			(rdata),
		 // Inputs
		 .CLK			(clk),
		 .RST_N			(rst_n),
		 .CS			(CS),
		 .REN			(REN),
		 .WEN			(WEN),
		 .A			(addr),
		 .D			(wdata)
		  );
   
endmodule // EVA_MEM_WRAP

