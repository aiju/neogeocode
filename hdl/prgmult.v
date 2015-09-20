module prgmult(
	input wire [18:0] a,
	input wire [13:0] sdra,
	input wire [11:0] sdpa,
	
	output reg [15:0] j,
	input wire [1:0] js,
	
	input wire resetin,
	output wire resetout
);

	wire [15:0] sdx/* synthesis syn_keep= 1 OPT= "KEEP" */;
	assign sdx = js[0] ? {4'b0, sdpa} : {4'b0, sdra};

	always @(*) begin
		j = 'bx;
		case(js)
		2'b00: j = a[15:0];
		2'b01: j[2:0] = a[18:16];
		2'b10, 2'b11: j = sdx;
		endcase
	end
	
	assign resetout = resetin;

endmodule
