
module TH;

    // Clock & reset domain
    wire 	             aclk;
    wire                 hclk;
    
    wire                 arest_n;
    wire                 hrest_n;

    // AHB BUS
    wire [1:0]           htrans;      
    wire                 hwrite;      
    wire [31:0]          haddr;       
    wire [31:0]          hwdata;      
    wire [2:0]           hsize;     
    wire [2:0]           hburst;    
    wire [3:0]           hprot;     
    wire                 hready_out;
    
    wire                 hready_in;
    wire [1:0]           hresp; 
    wire [31:0]          hrdata;
    
    
    
    // AXI BUS
    wire                 arready;                     
    wire                 arvalid;                     
    wire [5:0]           arid;        // [3:0]        
    wire [63:0]          araddr;                  
    wire [5:0]           arlen;       // [5:0]        
    wire [2:0]           arsize;      // [2:0]  3'b100
    wire [1:0]           arburst;     // [1:0]  2'b01 
    wire                 arlock;                      
    wire [3:0]           arcache;     // [3:0]        
    wire [2:0]           arprot;      // [2:0]        
    wire [3:0]           arregion;    // [3:0]        
    wire [3:0]           arqos;       // [3:0]        
    wire [7:0]           aruser;      // [7:0]        
    
    wire                 rready;                      
    wire                 rvalid;                      
    wire [5:0]           rid;              // [5:0] 
    wire [4:0]           ruser;            // [4:0] 
    wire [127:0]         rdata;            // [31:0]
    wire                 rlast;                       
    wire [1:0]           rresp;   // [1:0] 


    wire                 awready;                     
    wire                 awvalid;                      
    wire [5:0]           awid;        // [3:0]         
    wire [63:0]          awaddr;                   
    wire [5:0]           awlen;       // [5:0]         
    wire [2:0]           awsize;      // [2:0]  3'b100 
    wire [1:0]           awburst;     // [1:0]  2'b01  
    wire                 awlock;                       
    wire [3:0]           awcache;     // [3:0]         
    wire [2:0]           awprot;      // [2:0]         
    wire [3:0]           awregion;    // [3:0]         
    wire [3:0]           awqos;       // [3:0]         
    wire [7:0]           awuser;      // [7:0]         
    
    wire                 wready;                       
    wire                 wvalid;                       
    wire                 wlast;                        
    wire [5:0]           wid;                // [3:0]  
    wire [127:0]         wdata;            // [31:0]    
    wire [15:0]          wstrb ;   // [15:0] 

    wire                 bvalid;
    wire [ 1:0]          bresp;
    wire [ 5:0]          bid;
    wire                 bready;

    
    //Replace regexp (default \(\w+\)\(,\) -> \1^I^I(\1^I),^J): 
    TB_EVA eva(// Outputs
			   .htrans	   (htrans	   ),
			   .hwrite	   (hwrite	   ),
			   .haddr	   (haddr	   ),
			   .hwdata	   (hwdata	   ),
			   .hsize	   (hsize	   ),
			   .hburst	   (hburst	   ),
			   .hprot	   (hprot	   ),
			   .hready_out (hready_in  ),

			   .arready	   (arready    ),
			   .rvalid	   (rvalid	   ),
			   .rid		   (rid        ),
			   .ruser	   (ruser      ),
			   .rdata	   (rdata	   ),
			   .rlast	   (rlast	   ),
			   .awready	   (awready    ),
			   .wready	   (wready	   ),

			   // Inputs
			   .hclk	   (hclk	   ),
			   .hrest_n	   (hrest_n    ),
			   .hready_in  (hready_out ),
			   .hresp	   (hresp	   ),
			   .hrdata	   (hrdata	   ),
			   .aclk	   (aclk	   ),
			   .arest_n	   (arest_n    ),
			   .arvalid	   (arvalid    ),

			   .arid	   (arid	   ),
			   .araddr	   (araddr	   ),
			   .arlen	   (arlen	   ),
			   .arsize	   (arsize	   ),
			   .arburst	   (arburst    ),
			   .arlock	   (arlock	   ),
			   .arcache	   (arcache    ),
			   .arprot	   (arprot	   ),

			   .arregion   (arregion   ),
			   .arqos	   (arqos	   ),
			   .aruser	   (aruser	   ),
			   .rready	   (rready	   ),
			   .rresp	   (rresp	   ),
			   .awvalid	   (awvalid    ),
			   .awid	   (awid	   ),
			   .awaddr	   (awaddr	   ),

			   .awlen	   (awlen	   ),
			   .awsize	   (awsize	   ),
			   .awburst	   (awburst    ),
			   .awlock	   (awlock	   ),
			   .awcache	   (awcache    ),
			   .awprot	   (awprot	   ),
			   .awregion   (awregion   ),
			   .awqos	   (awqos	   ),

			   .awuser	   (awuser	   ),
			   .wvalid	   (wvalid	   ),
			   .wlast	   (wlast	   ),
			   .wid		   (wid        ),
			   .wdata	   (wdata	   ),
			   .wstrb	   (wstrb	   ),

			   .bvalid	   (bvalid	   ),
			   .bresp	   (bresp	   ),
			   .bid		   (bid        ),
			   .bready	   (bready	   )
			   );

    TB_EVA_INTR U_EVA_INTR(
			               // Inputs
			               .clk			(hclk),
			               .rst_n		(hrest_n),
			               .interrupt	({31'b0, U_IVS_TOP.U_IVS_SLV.sw_rst})
			               );
    
    
    IVS_CLK_GEN ivs_clk_gen(
			                // Outputs
			                .aclk	(aclk	),
			                .hclk	(hclk	),
			                .arst_n	(arest_n),
			                .hrst_n	(hrest_n)
			                );

    IVS_TOP U_IVS_TOP(/*autoinst*/
                      // Outputs
                      .hready_out       (hready_out),
                      .hresp            (hresp[1:0]),
                      .hrdata           (hrdata[31:0]),
                      .arvalid          (arvalid),
                      .arid             (arid[3:0]),
                      .araddr           (araddr[31:0]),
                      .arlen            (arlen[5:0]),
                      .arsize           (arsize[2:0]),
                      .arburst          (arburst[1:0]),
                      .arlock           (arlock),
                      .arcache          (arcache[3:0]),
                      .arprot           (arprot[2:0]),
                      .arregion         (arregion[3:0]),
                      .arqos            (arqos[3:0]),
                      .aruser           (aruser[7:0]),
                      .rready           (rready),
                      .awvalid          (awvalid),
                      .awid             (awid[3:0]),
                      .awaddr           (awaddr[31:0]),
                      .awlen            (awlen[5:0]),
                      .awsize           (awsize[2:0]),
                      .awburst          (awburst[1:0]),
                      .awlock           (awlock),
                      .awcache          (awcache[3:0]),
                      .awprot           (awprot[2:0]),
                      .awregion         (awregion[3:0]),
                      .awqos            (awqos[3:0]),
                      .awuser           (awuser[7:0]),
                      .wvalid           (wvalid),
                      .wlast            (wlast),
                      .wid              (wid[3:0]),
                      .wdata            (wdata[`BDWD-1:0]),
                      .wstrb            (wstrb[15:0]),
                      // Inputs
                      .hclk             (hclk),
                      .hrst_n           (hrest_n),
                      .hsel             (1'b1),
                      .htrans           (htrans[1:0]),
                      .hwrite           (hwrite),
                      .haddr            (haddr[31:0]),
                      .hwdata           (hwdata[31:0]),
                      .hsize            (hsize[2:0]),
                      .hburst           (hburst[2:0]),
                      .hprot            (hprot[3:0]),
                      .hready_in        (hready_in),
                      .aclk             (aclk),
                      .arst_n           (arest_n),
                      .arready          (arready),
                      .rvalid           (rvalid),
                      .rid              (rid[3:0]),
                      .rdata            (rdata[`BDWD-1:0]),
                      .rlast            (rlast),
                      .rresp            (rresp[1:0]),
                      .awready          (awready),
                      .wready           (wready));


    EVA_MEM_WRAP #(32,64,1) U_RAM32x64(// Outputs
				                       .rdata		(hrdata	),
				                       // Inputs
				                       .clk		(hclk	),
				                       .rst_n		(hrest_n	),
				                       .rd		(rd	),
				                       .we		(we	),
				                       .addr		(addr	),
				                       .wdata		(wdata	)
				      	               );
    
endmodule // TH

// Local Variables:
// verilog-library-directories:("."  "../rtl")
// verilog-library-files:("../rtl/ivs_top.v")
// verilog-library-extensions:(".v" ".h")
// End:

