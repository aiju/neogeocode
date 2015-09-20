`default_nettype none

module buscs(
	input wire clk,
	input wire rst,
	
	input wire load,
	input wire half,
	input wire even,
	input wire pck1b,
	input wire pck2b,
	input wire sa3,
	
	output wire asreq,
	input wire [16:0] asaddr,
	input wire asack,
	
	output wire msreq,
	output wire [16:0] msaddr,
	input wire msack,
	input wire [15:0] msdata,
	
	output wire dsreq,
	output wire [7:0] dsdata
);

	wire pck2bs, sa3s;
	reg pck2bs0, sa3s0;
	reg [7:0] sdata;

	sync pck2bsync(clk, pck2b, pck2bs);
	sync sa3sync(clk, sa3, sa3s);
	
	always @(posedge clk) begin
		pck2bs0 <= pck2bs;
		sa3s0 <= sa3s;
		if(msack)
			sdata <= msdata[15:8];
	end
	
	assign asreq = pck2bs && !pck2bs0;
	assign msreq = asack;
	assign msaddr = asaddr;
	
	assign dsreq = msack || sa3s && !sa3s0;
	assign dsdata = !sa3s ? msdata[7:0] : sdata;

endmodule

