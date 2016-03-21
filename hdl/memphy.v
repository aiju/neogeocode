`default_nettype none

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
		.CLK0_MULTIPLY_BY(8),
		.CLK0_DIVIDE_BY(8),
		.CLK1_MULTIPLY_BY(8),
		.CLK1_DIVIDE_BY(8),
		.CLK1_PHASE_SHIFT(50000),
		.CLK2_MULTIPLY_BY(8),
		.CLK2_DIVIDE_BY(8),
		.CLK2_PHASE_SHIFT(25000),
		.CLK3_MULTIPLY_BY(8),
		.CLK3_DIVIDE_BY(8),
		.CLK3_PHASE_SHIFT(75000),
		.CLK4_MULTIPLY_BY(8),
		.CLK4_DIVIDE_BY(8),
		.CLK4_PHASE_SHIFT(0),
		.CLK5_MULTIPLY_BY(8),
		.CLK5_DIVIDE_BY(8),
		.CLK5_PHASE_SHIFT(0)
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
	
	assign ddrdqsp = dqsdrive ? clk90 : 1'bz;
	assign ddrdqsn = dqsdrive ? clk270 : 1'bz;

endmodule
