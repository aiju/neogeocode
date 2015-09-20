module sync(
	input wire clk,
	input wire din,
	output wire dout
);

	reg d0, d1;
	
	always @(posedge clk) begin
		d0 <= din;
		d1 <= d0;
	end
	
	assign dout = d1;
	initial begin
		d0 = 0;
		d1 = 0;
	end

endmodule
