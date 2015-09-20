`default_nettype none

module romfix(
	input wire clk,
	
	input wire msreq,
	input wire [16:0] msaddr,
	output reg msack,
	output wire [15:0] msdata
);

	wire [11:0] romaddr;

	wire [3:0] romdata;
	
	assign romaddr = {msaddr[12:5], msaddr[2:0], !msaddr[4]};

	altsyncram #(
		.OPERATION_MODE("ROM"),
		.WIDTH_A(4),
		.WIDTHAD_A(12),
		.INIT_FILE("Z:/neogeocode/c/fix.mif"),
		.ENABLE_RUNTIME_MOD("YES"),
		.INSTANCE_NAME("SFIX")
	) altsyncram0(
		.clock0(clk),
		.rden_a(msreq),
		.address_a(romaddr),
		.q_a(romdata)
	);
	
	assign msdata = {3'b0, romdata[0], 3'b0, romdata[1], 3'b0, romdata[2], 3'b0, romdata[3]};
	
	always @(posedge clk)
		msack <= msreq;

endmodule
