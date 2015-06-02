
module IVS_TOP(/*AUTOARG*/
   // Outputs
   hready_out, hresp, hrdata,
   // Inputs
   hclk, hrst_n, hsel, htrans, hwrite, haddr, hwdata, hsize, hburst,
   hprot, hready_in
   );

   input                hclk;
   input 		hrst_n;
   
   // AHB BUS
   input 		hsel;      
   input [1:0] 		htrans;      
   input 		hwrite;      
   input [31:0] 	haddr;       
   input [31:0] 	hwdata;      
   input [1:0] 		hsize;     
   input [2:0] 		hburst;    
   input [3:0] 		hprot;     
   input 		hready_in;
   
   output 		hready_out;
   output [1:0] 	hresp; 
   output [31:0] 	hrdata;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [31:0]		cfg_par0;		// From U_IVS_SLV of IVS_SLV.v
   wire [31:0]		cfg_par1;		// From U_IVS_SLV of IVS_SLV.v
   wire [31:0]		cfg_par2;		// From U_IVS_SLV of IVS_SLV.v
   wire [31:0]		cfg_par3;		// From U_IVS_SLV of IVS_SLV.v
   wire [31:0]		cfg_par4;		// From U_IVS_SLV of IVS_SLV.v
   wire [31:0]		cfg_par5;		// From U_IVS_SLV of IVS_SLV.v
   wire [31:0]		cfg_par6;		// From U_IVS_SLV of IVS_SLV.v
   wire [31:0]		cfg_par7;		// From U_IVS_SLV of IVS_SLV.v
   wire [31:0]		glb_ctrl;		// From U_IVS_SLV of IVS_SLV.v
   wire			sw_rst;			// From U_IVS_SLV of IVS_SLV.v
   // End of automatics
   
   IVS_SLV U_IVS_SLV(/*AUTOINST*/
		     // Outputs
		     .hready_out	(hready_out),
		     .hresp		(hresp[1:0]),
		     .hrdata		(hrdata[31:0]),
		     .cfg_par0		(cfg_par0[31:0]),
		     .cfg_par1		(cfg_par1[31:0]),
		     .cfg_par2		(cfg_par2[31:0]),
		     .cfg_par3		(cfg_par3[31:0]),
		     .cfg_par4		(cfg_par4[31:0]),
		     .cfg_par5		(cfg_par5[31:0]),
		     .cfg_par6		(cfg_par6[31:0]),
		     .cfg_par7		(cfg_par7[31:0]),
		     .glb_ctrl		(glb_ctrl[31:0]),
		     .sw_rst		(sw_rst),
		     // Inputs
		     .hclk		(hclk),
		     .hrst_n		(hrst_n),
		     .hsel		(hsel),
		     .htrans		(htrans[1:0]),
		     .hwrite		(hwrite),
		     .haddr		(haddr[31:0]),
		     .hwdata		(hwdata[31:0]),
		     .hsize		(hsize[1:0]),
		     .hburst		(hburst[2:0]),
		     .hprot		(hprot[3:0]),
		     .hready_in		(hready_in));


endmodule // IVS_TOP

// Local Variables:
// verilog-library-directories:("." )
// verilog-library-files:("ivs_slv.v")
// verilog-library-extensions:(".v" ".h")
// End:
