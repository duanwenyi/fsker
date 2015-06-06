
module TH;

   // Clock & reset domain
   wire 	    aclk;
   wire 	    hclk;
   
   wire 	    arest_n;
   wire 	    hrest_n;

   // AHB BUS
   wire [1:0] 	    htrans;      
   wire 	    hwrite;      
   wire [31:0] 	    haddr;       
   wire [31:0] 	    hwdata;      
   wire [1:0] 	    hsize;     
   wire [2:0] 	    hburst;    
   wire [3:0] 	    hprot;     
   wire 	    hready_out;
   
   wire 	    hready_in;
   wire [1:0] 	    hresp; 
   wire [31:0] 	    hrdata;
   
   
   
   // AXI BUS
   wire 	    arready;                     
   wire 	    arvalid;                     
   wire [3:0] 	    arid;        // [3:0]        
   wire [31:0] 	    araddr;                  
   wire [5:0] 	    arlen;       // [5:0]        
   wire [2:0] 	    arsize;      // [2:0]  3'b100
   wire [1:0] 	    arburst;     // [1:0]  2'b01 
   wire 	    arlock;                      
   wire [3:0] 	    arcache;     // [3:0]        
   wire [2:0] 	    arport;      // [2:0]        
   wire [3:0] 	    arregion;    // [3:0]        
   wire [3:0] 	    arqos;       // [3:0]        
   wire [7:0] 	    aruser;      // [7:0]        
   
   wire 	    rready;                      
   wire 	    rvalid;                      
   wire [3:0] 	    rid;                // [3:0] 
   wire [127:0]     rdata;            // [31:0]
   wire 	    rlast;                       
   wire [1:0] 	    rresp;   // [1:0] 


   wire 	    awready;                     
   wire 	    awvalid;                      
   wire [3:0] 	    awid;        // [3:0]         
   wire [31:0] 	    awaddr;                   
   wire [5:0] 	    awlen;       // [5:0]         
   wire [2:0] 	    awsize;      // [2:0]  3'b100 
   wire [1:0] 	    awburst;     // [1:0]  2'b01  
   wire 	    awlock;                       
   wire [3:0] 	    awcache;     // [3:0]         
   wire [2:0] 	    awport;      // [2:0]         
   wire [3:0] 	    awregion;    // [3:0]         
   wire [3:0] 	    awqos;       // [3:0]         
   wire [7:0] 	    awuser;      // [7:0]         
   
   wire 	    wready;                       
   wire 	    wvalid;                       
   wire 	    wlast;                        
   wire [3:0] 	    wid;                // [3:0]  
   wire [127:0]     wdata;            // [31:0]    
   wire [15:0] 	    wstrb ;   // [15:0] 

   //Replace regexp (default \(\w+\)\(,\) -> \1^I^I(\1^I),^J): 
   TB_EVA eva(// Outputs
	      .htrans		(htrans		),
	      .hwrite		(hwrite		),
	      .haddr		(haddr		),
	      .hwdata		(hwdata		),
	      .hsize		(hsize		),
	      .hburst		(hburst		),
	      .hprot		(hprot		),
	      .hready_out	(hready_out	),

	      .arready		(arready	),
	      .rvalid		(rvalid		),
	      .rid		(rid		),
	      .rdata		(rdata		),
	      .rlast		(rlast		),
	      .awready		(awready	),
	      .wready		(wready		),

	      // Inputs
	      .hclk		(hclk		),
	      .hrest_n		(hrest_n	),
	      .hready_in	(hready_in	),
	      .hresp		(hresp		),
	      .hrdata		(hrdata		),
	      .aclk		(aclk		),
	      .arest_n		(arest_n	),
	      .arvalid		(arvalid	),

	      .arid		(arid		),
	      .araddr		(araddr		),
	      .arlen		(arlen		),
	      .arsize		(arsize		),
	      .arburst		(arburst	),
	      .arlock		(arlock		),
	      .arcache		(arcache	),
	      .arport		(arport		),

	      .arregion		(arregion	),
	      .arqos		(arqos		),
	      .aruser		(aruser		),
	      .rready		(rready		),
	      .rresp		(rresp		),
	      .awvalid		(awvalid	),
	      .awid		(awid		),
	      .awaddr		(awaddr		),

	      .awlen		(awlen		),
	      .awsize		(awsize		),
	      .awburst		(awburst	),
	      .awlock		(awlock		),
	      .awcache		(awcache	),
	      .awport		(awport		),
	      .awregion		(awregion	),
	      .awqos		(awqos		),

	      .awuser		(awuser		),
	      .wvalid		(wvalid		),
	      .wlast		(wlast		),
	      .wid		(wid		),
	      .wdata		(wdata		),
	      .wstrb		(wstrb		)
	      );

   
   IVS_CLK_GEN ivs_clk_gen(
			   // Outputs
			   .aclk	(aclk	),
			   .hclk	(hclk	),
			   .arst_n	(arest_n),
			   .hrst_n	(hrest_n)
			   );

   IVS_TOP U_IVS_TOP(// Outputs
		     .hready_out	(hready_in),
		     .hresp		(hresp[1:0]),
		     .hrdata		(hrdata[31:0]),
		     // Inputs
		     .hclk		(hclk),
		     .hrst_n		(hrest_n),
		     .hsel		(1'b1),
		     .htrans		(htrans[1:0]),
		     .hwrite		(hwrite),
		     .haddr		(haddr[31:0]),
		     .hwdata		(hwdata[31:0]),
		     .hsize		(hsize[1:0]),
		     .hburst		(hburst[2:0]),
		     .hprot		(hprot[3:0]),
		     .hready_in		(hready_out)
		     );

   EVA_MEM_WRAP #(32,64,1) U_RAM32x64(// Outputs
				      .rdata		(rdata),
				      // Inputs
				      .clk		(hclk),
				      .rst_n		(hrest_n),
				      .rd		(rd),
				      .we		(we),
				      .addr		(addr),
				      .wdata		(wdata)
				      );
   
endmodule // TH

// Local Variables:
// verilog-library-directories:("."  "../rtl")
// verilog-library-files:("../rtl/ivs_top.v")
// verilog-library-extensions:(".v" ".h")
// End:
