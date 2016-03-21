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
	
	output wire [7:0] h,
	output wire [2:0] hc,
	
	output wire [14:0] ddra,
	output wire [2:0] ddrba,
	output wire ddrckp,
	output wire ddrckn,
	output wire ddrcke,
	output wire ddrcs,
	output wire ddrras,
	output wire ddrcas,
	output wire ddrwe,
	output wire ddrreset,
	inout wire [7:0] ddrdq,
	inout wire ddrdqsp,
	inout wire ddrdqsn
);

	/*AUTOWIRE*/
	// Beginning of automatic wires (for undeclared instantiated-module outputs)
	wire		a68kack;		// From buscpld of buscpld.v
	wire [18:0]	a68kaddr;		// From buscpld of buscpld.v
	wire		a68kreq;		// From bus68k of bus68k.v
	wire		asack;			// From buscpld of buscpld.v
	wire [16:0]	asaddr;			// From buscpld of buscpld.v
	wire		asreq;			// From buscs of buscs.v
	wire		bootack;		// From rom68k of rom68k.v
	wire [15:0]	bootaddr;		// From switch of switch.v
	wire [15:0]	bootdata;		// From rom68k of rom68k.v
	wire		bootreq;		// From switch of switch.v
	wire		clk;			// From memphy of memphy.v
	wire [15:0]	ddrdqin;		// From memphy of memphy.v
	wire [15:0]	ddrdqout;		// From mem of mem.v
	wire		ddrdqspre;		// From mem of mem.v
	wire		ddrdqt;			// From mem of mem.v
	wire [7:0]	dsdata;			// From buscs of buscs.v
	wire		dsreq;			// From buscs of buscs.v
	wire		m68kack;		// From switch of switch.v
	wire [19:0]	m68kaddr;		// From bus68k of bus68k.v
	wire [15:0]	m68krdata;		// From switch of switch.v
	wire		m68kreq;		// From bus68k of bus68k.v
	wire [15:0]	m68kwdata;		// From bus68k of bus68k.v
	wire		m68kwr;			// From bus68k of bus68k.v
	wire		memack;			// From mem of mem.v
	wire [19:0]	memaddr;		// From switch of switch.v
	wire [31:0]	memrdata;		// From mem of mem.v
	wire		memreq;			// From switch of switch.v
	wire		memreset;		// From mem of mem.v
	wire [31:0]	memwdata;		// From switch of switch.v
	wire		memwr;			// From switch of switch.v
	wire		msack;			// From romfix of romfix.v
	wire [16:0]	msaddr;			// From buscs of buscs.v
	wire [15:0]	msdata;			// From romfix of romfix.v
	wire		msreq;			// From buscs of buscs.v
	// End of automatics
	assign resetout = memreset;
	
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
		    .h			(h[7:0]),
		    .hc			(hc[2:0]),
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
		      .memaddr		(memaddr[19:0]),
		      .memreq		(memreq),
		      .memwdata		(memwdata[31:0]),
		      .memwr		(memwr),
		      // Inputs
		      .clk		(clk),
		      .m68kreq		(m68kreq),
		      .m68kaddr		(m68kaddr[19:0]),
		      .m68kwdata	(m68kwdata[15:0]),
		      .m68kwr		(m68kwr),
		      .bootack		(bootack),
		      .bootdata		(bootdata[15:0]),
		      .memack		(memack),
		      .memrdata		(memrdata[31:0]));
	
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
		      
	mem mem(/*AUTOINST*/
		// Outputs
		.memreset		(memreset),
		.memack			(memack),
		.memrdata		(memrdata[31:0]),
		.ddra			(ddra[14:0]),
		.ddrba			(ddrba[2:0]),
		.ddrcke			(ddrcke),
		.ddrcs			(ddrcs),
		.ddrras			(ddrras),
		.ddrcas			(ddrcas),
		.ddrwe			(ddrwe),
		.ddrreset		(ddrreset),
		.ddrdqout		(ddrdqout[15:0]),
		.ddrdqt			(ddrdqt),
		.ddrdqspre		(ddrdqspre),
		// Inputs
		.clk			(clk),
		.memaddr		(memaddr[19:0]),
		.memwr			(memwr),
		.memwdata		(memwdata[31:0]),
		.memreq			(memreq),
		.ddrdqin		(ddrdqin[15:0]));
	
	memphy memphy(/*AUTOINST*/
		      // Outputs
		      .clk		(clk),
		      .ddrckp		(ddrckp),
		      .ddrckn		(ddrckn),
		      .ddrdqin		(ddrdqin[15:0]),
		      // Inouts
		      .ddrdq		(ddrdq[7:0]),
		      .ddrdqsp		(ddrdqsp),
		      .ddrdqsn		(ddrdqsn),
		      // Inputs
		      .refclk		(refclk),
		      .ddrdqout		(ddrdqout[15:0]),
		      .ddrdqt		(ddrdqt),
		      .ddrdqspre	(ddrdqspre));

endmodule
