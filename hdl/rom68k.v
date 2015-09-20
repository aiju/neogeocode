`default_nettype none

module rom68k(
	input wire clk,
	
	input wire bootreq,
	input wire [15:0] bootaddr,
	output reg bootack,
	output wire [15:0] bootdata
);

	altsyncram #(
		.OPERATION_MODE("ROM"),
		.WIDTH_A(16),
		.WIDTHAD_A(10),
		.INIT_FILE("Z:/neogeocode/c/code.mif"),
		.ENABLE_RUNTIME_MOD("YES"),
		.INSTANCE_NAME("CODE")
	) altsyncram0(
		.clock0(clk),
		.rden_a(bootreq),
		.address_a(bootaddr),
		.q_a(bootdata)
	);
	
	always @(posedge clk)
		bootack <= bootreq;

endmodule
