module top(
	input wire refclk,
	
	input wire [15:0] j,
	output wire [1:0] js,
	input wire as,
	input wire rw,
	input wire romoe,
	input wire portadrs,
	input wire clk4mb,
	input wire clk68k,
	input wire portwel,
	input wire portweu,
	input wire portoel,
	input wire portoeu,
	input wire romoeu,
	input wire romoel,
	
	input wire reset,
	output wire resetout,
	
	inout wire [15:0] d68k,
	output wire d68kdir,
	output wire d68koel,
	output wire d68koeh,
	
	input wire [15:0] f,
	output wire [1:0] fs,
	input wire ca4,
	input wire sa3,
	input wire load,
	input wire half,
	input wire even,
	input wire pck1b,
	input wire pck2b,
	
	output wire [7:0] g,
	output wire [2:0] gc,
	output wire goe,
	
	output wire [14:0] mem_a,
	output wire [2:0] mem_ba,
	output wire mem_ck,
	output wire mem_ck_n,
	output wire mem_cke,
	output wire mem_cs_n,
	output wire mem_ras_n,
	output wire mem_we_n,
	output wire mem_reset_n,
	inout wire [7:0] mem_dq,
	inout wire mem_dqs,
	inout wire mem_dqs_n
);

	assign resetout = 0;
	
	wire resets;
	sync resetsync(clk, reset, resets);
	reg [7:0] rstctr;
	reg rst;
	initial begin
		rstctr = 0;
		rst = 1;
	end
	always @(posedge clk) begin
		rst <= rstctr != 255;
		if(rstctr != 255)
			rstctr <= rstctr + 1;
		if(!resets)
			rstctr <= 0;
	end
	
	/*AUTOWIRE*/
	// Beginning of automatic wires (for undeclared instantiated-module outputs)
	wire		a68kack;		// From buscpld of buscpld.v
	wire [18:0]	a68kaddr;		// From buscpld of buscpld.v
	wire		a68kreq;		// From bus68k of bus68k.v
	wire		afi_clk;		// From ddr3 of ddr3.v
	wire		afi_half_clk;		// From ddr3 of ddr3.v
	wire		afi_phy_clk;		// From ddr3 of ddr3.v
	wire		afi_reset_export_n;	// From ddr3 of ddr3.v
	wire		afi_reset_n;		// From ddr3 of ddr3.v
	wire		asack;			// From buscpld of buscpld.v
	wire [16:0]	asaddr;			// From buscpld of buscpld.v
	wire		asreq;			// From buscs of buscs.v
	wire [25:0]	avl_addr;		// From switch of switch.v
	wire		avl_burstbegin;		// From switch of switch.v
	wire [31:0]	avl_rdata;		// From ddr3 of ddr3.v
	wire		avl_rdata_valid;	// From ddr3 of ddr3.v
	wire		avl_read_req;		// From switch of switch.v
	wire		avl_ready;		// From ddr3 of ddr3.v
	wire [2:0]	avl_size;		// From switch of switch.v
	wire [31:0]	avl_wdata;		// From switch of switch.v
	wire		avl_write_req;		// From switch of switch.v
	wire		bootack;		// From rom68k of rom68k.v
	wire [15:0]	bootaddr;		// From switch of switch.v
	wire [15:0]	bootdata;		// From rom68k of rom68k.v
	wire		bootreq;		// From switch of switch.v
	wire [7:0]	dsdata;			// From buscs of buscs.v
	wire		dsreq;			// From buscs of buscs.v
	wire		local_cal_fail;		// From ddr3 of ddr3.v
	wire		local_cal_success;	// From ddr3 of ddr3.v
	wire		local_init_done;	// From ddr3 of ddr3.v
	wire		m68kack;		// From switch of switch.v
	wire [19:0]	m68kaddr;		// From bus68k of bus68k.v
	wire [15:0]	m68krdata;		// From switch of switch.v
	wire		m68kreq;		// From bus68k of bus68k.v
	wire [15:0]	m68kwdata;		// From bus68k of bus68k.v
	wire		m68kwr;			// From bus68k of bus68k.v
	wire		mem_cas_n;		// From ddr3 of ddr3.v
	wire		mem_odt;		// From ddr3 of ddr3.v
	wire		msack;			// From romfix of romfix.v
	wire [16:0]	msaddr;			// From buscs of buscs.v
	wire [15:0]	msdata;			// From romfix of romfix.v
	wire		msreq;			// From buscs of buscs.v
	wire		pll_addr_cmd_clk;	// From ddr3 of ddr3.v
	wire		pll_avl_clk;		// From ddr3 of ddr3.v
	wire		pll_avl_phy_clk;	// From ddr3 of ddr3.v
	wire		pll_config_clk;		// From ddr3 of ddr3.v
	wire		pll_locked;		// From ddr3 of ddr3.v
	wire		pll_mem_clk;		// From ddr3 of ddr3.v
	wire		pll_mem_phy_clk;	// From ddr3 of ddr3.v
	wire		pll_write_clk;		// From ddr3 of ddr3.v
	wire		pll_write_clk_pre_phy_clk;// From ddr3 of ddr3.v
	// End of automatics
	
	wire clk = pll_avl_clk;
	
	buscpld buscpld(/*AUTOINST*/
			// Outputs
			.js		(js[1:0]),
			.fs		(fs[1:0]),
			.a68kaddr	(a68kaddr[18:0]),
			.a68kack	(a68kack),
			.asaddr		(asaddr[16:0]),
			.asack		(asack),
			// Inputs
			.clk		(clk),
			.j		(j[15:0]),
			.f		(f[15:0]),
			.a68kreq	(a68kreq),
			.asreq		(asreq));
	
	bus68k bus68k(/*AUTOINST*/
		      // Outputs
		      .d68kdir		(d68kdir),
		      .d68koel		(d68koel),
		      .d68koeh		(d68koeh),
		      .a68kreq		(a68kreq),
		      .m68kreq		(m68kreq),
		      .m68kaddr		(m68kaddr[19:0]),
		      .m68kwdata	(m68kwdata[15:0]),
		      .m68kwr		(m68kwr),
		      // Inouts
		      .d68k		(d68k[15:0]),
		      // Inputs
		      .clk		(clk),
		      .rst		(rst),
		      .as		(as),
		      .rw		(rw),
		      .romoe		(romoe),
		      .portadrs		(portadrs),
		      .portwel		(portwel),
		      .portweu		(portweu),
		      .portoel		(portoel),
		      .portoeu		(portoeu),
		      .romoeu		(romoeu),
		      .romoel		(romoel),
		      .a68kaddr		(a68kaddr[18:0]),
		      .a68kack		(a68kack),
		      .m68kack		(m68kack),
		      .m68krdata	(m68krdata[15:0]));
		     
	buscs buscs(/*AUTOINST*/
		    // Outputs
		    .asreq		(asreq),
		    .msreq		(msreq),
		    .msaddr		(msaddr[16:0]),
		    .dsreq		(dsreq),
		    .dsdata		(dsdata[7:0]),
		    // Inputs
		    .clk		(clk),
		    .rst		(rst),
		    .load		(load),
		    .half		(half),
		    .even		(even),
		    .pck1b		(pck1b),
		    .pck2b		(pck2b),
		    .sa3		(sa3),
		    .asaddr		(asaddr[16:0]),
		    .asack		(asack),
		    .msack		(msack),
		    .msdata		(msdata[15:0]));
	
	busgh busgh(/*AUTOINST*/
		    // Outputs
		    .g			(g[7:0]),
		    .gc			(gc[2:0]),
		    // Inputs
		    .clk		(clk),
		    .dsreq		(dsreq),
		    .dsdata		(dsdata[7:0]));

	switch switch(/*AUTOINST*/
		      // Outputs
		      .m68kack		(m68kack),
		      .m68krdata	(m68krdata[15:0]),
		      .bootreq		(bootreq),
		      .bootaddr		(bootaddr[15:0]),
		      .avl_burstbegin	(avl_burstbegin),
		      .avl_addr		(avl_addr[25:0]),
		      .avl_wdata	(avl_wdata[31:0]),
		      .avl_read_req	(avl_read_req),
		      .avl_write_req	(avl_write_req),
		      .avl_size		(avl_size[2:0]),
		      // Inputs
		      .clk		(clk),
		      .m68kreq		(m68kreq),
		      .m68kaddr		(m68kaddr[19:0]),
		      .m68kwdata	(m68kwdata[15:0]),
		      .m68kwr		(m68kwr),
		      .bootack		(bootack),
		      .bootdata		(bootdata[15:0]),
		      .avl_ready	(avl_ready),
		      .avl_rdata_valid	(avl_rdata_valid),
		      .avl_rdata	(avl_rdata[31:0]));
	
	rom68k rom68k(/*AUTOINST*/
		      // Outputs
		      .bootack		(bootack),
		      .bootdata		(bootdata[15:0]),
		      // Inputs
		      .clk		(clk),
		      .bootreq		(bootreq),
		      .bootaddr		(bootaddr[15:0]));

	romfix romfix(/*AUTOINST*/
		      // Outputs
		      .msack		(msack),
		      .msdata		(msdata[15:0]),
		      // Inputs
		      .clk		(clk),
		      .msreq		(msreq),
		      .msaddr		(msaddr[16:0]));

endmodule
