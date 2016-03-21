module switch(
	input wire clk,
	
	input wire m68kreq,
	input wire [19:0] m68kaddr,
	input wire [15:0] m68kwdata,
	input wire m68kwr,
	output reg m68kack,
	output reg [15:0] m68krdata,
	
	output reg bootreq,
	output wire [15:0] bootaddr,
	input wire bootack,
	input wire [15:0] bootdata,
	
	output wire [19:0] memaddr,
	output reg memreq,
	output wire [31:0] memwdata,
	output wire memwr,
	input wire memack,
	input wire [31:0] memrdata
);

	reg [2:0] state, state_;
	localparam IDLE = 0;
	localparam BOOT = 1;
	localparam MEM = 2;

	assign memwr = m68kwr;
	assign memaddr = m68kaddr;
	assign memwdata = {~m68kwdata, m68kwdata};
	assign bootaddr = m68kaddr;
	
	initial state = IDLE;
	
	always @(posedge clk)
		state <= state_;

	always @(*) begin
		state_ = state;
		bootreq = 0;
		memreq = 0;
		m68kack = 0;
		m68krdata = 16'bx;
		
		case(state)
		IDLE:
			if(m68kreq) begin
				if(m68kaddr[19]) begin
					memreq = 1;
					state_ = MEM;
				end else begin
					state_ = BOOT;
					bootreq = 1;
				end
			end
		BOOT:
			if(bootack) begin
				m68kack = 1;
				m68krdata = bootdata;
				state_ = IDLE;
			end
		MEM:
			if(memack) begin
				m68kack = 1;
				m68krdata = memrdata;
				state_ = IDLE;
			end
		endcase
	end

endmodule
