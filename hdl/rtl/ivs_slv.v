`include "ivs_def.v"

module IVS_SLV(/*AUTOARG*/
   // Outputs
   hready_out, hresp, hrdata, cfg_par0, cfg_par1, cfg_par2, cfg_par3,
   cfg_par4, cfg_par5, cfg_par6, cfg_par7, glb_ctrl, sw_rst,
   // Inputs
   hclk, hrst_n, hsel, htrans, hwrite, haddr, hwdata, hsize, hburst,
   hprot, hready_in
   );

   input                hclk;
   input 				hrst_n;
   
   // AHB BUS
   input 				hsel;      
   input [1:0] 			htrans;      
   input 				hwrite;      
   input [31:0] 		haddr;       
   input [31:0] 		hwdata;      
   input [2:0] 			hsize;     
   input [2:0] 			hburst;    
   input [3:0] 			hprot;     
   input 				hready_in;
   
   output 				hready_out;
   output [1:0] 		hresp; 
   output reg [31:0] 	hrdata;

   output reg [31:0] 	cfg_par0;
   output reg [31:0] 	cfg_par1;
   output reg [31:0] 	cfg_par2;
   output reg [31:0] 	cfg_par3;
   output reg [31:0] 	cfg_par4;
   output reg [31:0] 	cfg_par5;
   output reg [31:0] 	cfg_par6;
   output reg [31:0] 	cfg_par7;

   output reg [31:0] 	glb_ctrl;
   output reg 			sw_rst;

   reg [9:0] 			addr_ofst;

   reg 					cs_en_ff;
   reg 					wr_en_ff;
   reg 					rd_en_ff;

   wire 				cs_en = hsel & (htrans != 2'b0) & hready_in;
   wire 				wr_en = cs_en &  hwrite;
   wire 				rd_en = cs_en & ~hwrite;

   wire [31:0] 			hrdata_s = ( {32{addr_ofst == `IVS_CTRL}} & glb_ctrl |
      
									 {32{addr_ofst == `IVS_PAR0}} & cfg_par0 |
									 {32{addr_ofst == `IVS_PAR1}} & cfg_par1 |
									 {32{addr_ofst == `IVS_PAR2}} & cfg_par2 |
									 {32{addr_ofst == `IVS_PAR3}} & cfg_par3 |
									 {32{addr_ofst == `IVS_PAR4}} & cfg_par4 |
									 {32{addr_ofst == `IVS_PAR5}} & cfg_par5 |
									 {32{addr_ofst == `IVS_PAR6}} & cfg_par6 |
									 {32{addr_ofst == `IVS_PAR7}} & cfg_par7
									 );

   wire 				sw_rst_s = wr_en_ff && (addr_ofst == `IVS_TRIG) && hwdata[0];

   assign hready_out = ~cs_en_ff;
   assign hresp      = 2'b0;

   always @(posedge hclk)
     if(~hrst_n)
       wr_en_ff  <= 1'b0;
     else if(wr_en^wr_en_ff)
       wr_en_ff  <= wr_en;
   
   always @(posedge hclk)
     if(~hrst_n)
       rd_en_ff  <= 1'b0;
     else if(rd_en^rd_en_ff)
       rd_en_ff  <= rd_en;

   always @(posedge hclk)
     if(~hrst_n)
       cs_en_ff  <= 1'b0;
     else if(cs_en^cs_en_ff)
       cs_en_ff  <= cs_en;

   // haddr[1:0] always be zero , optimized later .
   always @(posedge hclk)
     if(~hrst_n)
       addr_ofst  <= 10'b0;
     else if(cs_en)
       addr_ofst  <= haddr[11:0];

   always @(posedge hclk)
     if(~hrst_n)begin
	glb_ctrl  <= 32'h0;
	
	cfg_par0  <= 32'h0;
	cfg_par1  <= 32'h0;
	cfg_par2  <= 32'h0;
	cfg_par3  <= 32'h0;
	cfg_par4  <= 32'h0;
	cfg_par5  <= 32'h0;
	cfg_par6  <= 32'h0;
	cfg_par7  <= 32'h0;
     end
     else if(wr_en_ff)
       case(addr_ofst)
	 10'h000:   glb_ctrl  <= hwdata;
	 
	 10'h100:   cfg_par0  <= hwdata;
	 10'h104:   cfg_par1  <= hwdata;
	 10'h108:   cfg_par2  <= hwdata;
	 10'h10c:   cfg_par3  <= hwdata;
	 10'h110:   cfg_par4  <= hwdata;
	 10'h114:   cfg_par5  <= hwdata;
	 10'h118:   cfg_par6  <= hwdata;
	 10'h11c:   cfg_par7  <= hwdata;
       endcase // case (addr_ofst)
   
   
   
   always @(posedge hclk)
     if(~hrst_n)
       hrdata  <= 32'b0;
     else if(rd_en_ff)
       hrdata  <= hrdata_s;

   always @(posedge hclk)
     if(~hrst_n)
       sw_rst  <= 1'b0;
     else if(sw_rst_s^sw_rst)
       sw_rst  <= sw_rst_s;

   
endmodule // IVS_SLV
