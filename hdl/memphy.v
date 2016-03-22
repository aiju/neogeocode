`include "dat.vh"

module memphy(
	input wire refclk,
	output wire clk,
	
	output wire ddrckp,
	output wire ddrckn,
	
	inout wire [7:0] ddrdq,
	inout wire ddrdqsp,
	inout wire ddrdqsn,
	
	output wire [15:0] ddrdqin,
	input wire [15:0] ddrdqout,
	input wire ddrdqt,
	input wire ddrdqspre
);

	assign ddrckp = clk;
	wire inclk, outclk;
	wire clk90, clk270;
	altpll #(
		.OPERATION_MODE("NO_COMPENSATION"),
		.INCLK0_INPUT_FREQUENCY(100000),
		.CLK0_MULTIPLY_BY(`CLKMUL),
		.CLK1_MULTIPLY_BY(`CLKMUL),
		.CLK2_MULTIPLY_BY(`CLKMUL),
		.CLK3_MULTIPLY_BY(`CLKMUL),
		.CLK4_MULTIPLY_BY(`CLKMUL),
		.CLK5_MULTIPLY_BY(`CLKMUL),
		.CLK0_DIVIDE_BY(`CLKDIV),
		.CLK1_DIVIDE_BY(`CLKDIV),
		.CLK2_DIVIDE_BY(`CLKDIV),
		.CLK3_DIVIDE_BY(`CLKDIV),
		.CLK4_DIVIDE_BY(`CLKDIV),
		.CLK5_DIVIDE_BY(`CLKDIV),
		.CLK1_PHASE_SHIFT(50000*`CLKMUL/`CLKDIV),
		.CLK2_PHASE_SHIFT(25000*`CLKMUL/`CLKDIV),
		.CLK3_PHASE_SHIFT(75000*`CLKMUL/`CLKDIV)
	) pll(
		.inclk(refclk),
		.clk({inclk, outclk, clk270, clk90, ddrckn, clk})
	);

	ALTDDIO_BIDIR #(
		.WIDTH(8)
	) buffer(
		.datain_h(ddrdqout[7:0]),
		.datain_l(ddrdqout[15:8]),
		.dataout_h(ddrdqin[15:8]),
		.dataout_l(ddrdqin[7:0]),
		.padio(ddrdq),
		.outclock(outclk),
		.inclocken(1'b1),
		.inclock(inclk),
		.outclocken(1'b1),
		.oe(!ddrdqt)
	);
	
	reg dqsdrive;
	
	always @(posedge clk90)
		dqsdrive <= !ddrdqt || ddrdqspre;
	
	ALTDDIO_OUT #(.WIDTH(2)) dqsdr(
		.datain_h(2'b01),
		.datain_l(2'b10),
		.dataout({ddrdqsn, ddrdqsp}),
		.outclock(clk90),
		.outclocken(1'b1),
		.oe(dqsdrive)
	);

endmodule
