module chrmult(
	input wire [23:0] p,
	input wire [15:0] sda,
	
	output reg [15:0] f,
	input wire [1:0] fa,
	
	input wire pck1b,
	input wire pck2b
);

	reg [15:0] sa;
	reg [23:0] ca;

	reg [7:0] sdx/* synthesis syn_keep= 1 OPT= "KEEP" */;
	
	always @(posedge pck1b)
		ca <= p;

	always @(posedge pck2b)
		sa <= p;
		
	always @(*) begin
		sdx = 8'bx;
		case(fa)
		2'b00: sdx = ca[7:0];
		2'b01: sdx = ca[23:16];
		2'b10: sdx = sda[7:0];
		2'b11: sdx = sa[7:0];
		endcase
	end

	always @(*) begin
		f = {8'bx, sdx};
		case(fa)
		2'b00: f[15:8] = ca[15:8];
		2'b10: f[15:8] = sda[15:8];
		2'b11: f[15:8] = sa[15:8];
		endcase
	end

endmodule
