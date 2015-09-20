module busgh(
	input wire clk,
	
	input wire dsreq,
	input wire [7:0] dsdata,
	
	output reg [7:0] g,
	output reg [2:0] gc
);

	reg [3:0] gstate, gstate_;
	reg [2:0] gctr, gctr_;
	reg [2:0] gc_;
	localparam GDELAY = 4;
	
	localparam IDLE = 0;
	localparam FIX = 1; 

	always @(posedge clk) begin
		gstate <= gstate_;
		gctr <= gctr_;
		gc <= gc_;
		
		if(gstate == IDLE && gstate_ == FIX)
			g <= dsdata;
	end
	
	always @(*) begin
		gstate_ = gstate;
		gctr_ = gctr == 0 ? 0 : gctr - 1;
		gc_ = 0;
	
		case(gstate)
		IDLE:
			if(dsreq) begin
				gstate_ = FIX;
				gctr_ = GDELAY;
			end
		FIX: begin
			if(gctr != 0)
				gc_[0] = gctr != GDELAY;
			else
				gstate_ = IDLE;
		end
		endcase
	end

endmodule

