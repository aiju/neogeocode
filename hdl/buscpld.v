`default_nettype none

module buscpld(
	input wire clk,
	
	output reg [1:0] js,
	input wire [15:0] j,
	
	output reg [1:0] fs,
	input wire [15:0] f,
	
	input wire a68kreq,
	output reg [18:0] a68kaddr,
	output reg a68kack,
	
	input wire asreq,
	output reg [16:0] asaddr,
	output reg asack
);

	reg [3:0] pstate, pstate_;
	reg [3:0] cstate, cstate_;
	localparam PDELAY = 0;
	localparam CDELAY = 1;
	
	reg cctr, cctr_;
	
	localparam IDLE = 0;
	localparam A68K0 = 1;
	
	localparam AS = 1;
	
	initial pstate = IDLE;
	
	always @(posedge clk) begin
		pstate <= pstate_;
		
		case(pstate_)
		IDLE: js <= 2'b00;
		A68K0: js <= 2'b01;
		endcase
		
		if(a68kreq)
			a68kaddr[15:0] <= j;
		if(pstate == A68K0)
			a68kaddr[18:16] <= j[2:0];
		a68kack <= pstate == A68K0;
	end
	
	always @(*) begin
		pstate_ = pstate;

		case(pstate)
		IDLE: begin
			if(a68kreq) begin
				pstate_ = A68K0;
			end
		end
		A68K0: pstate_ = IDLE;
		endcase
	end
	
	initial cstate = IDLE;
	
	always @(posedge clk) begin
		cstate <= cstate_;
		cctr <= cctr_;
		
		case(cstate_)
		AS: fs <= 2'b11;
		endcase
		
		if(cstate == AS && cctr == 0)
			asaddr <= {f[11:0], f[15], 1'b0, f[14:12]};
		asack <= cstate == AS && cctr == 0;
	end
	
	always @(*) begin
		cstate_ = cstate;
		cctr_ = cctr == 0 ? 0 : cctr - 1;
		
		case(cstate)
		IDLE:
			if(asreq) begin
				cstate_ = AS;
				cctr_ = CDELAY;
			end
		AS:
			if(cctr == 0)
				cstate_ = IDLE;
		endcase
	end

endmodule
