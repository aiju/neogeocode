module busgh(
	input wire clk,
	
	input wire dsreq,
	input wire [7:0] dsdata,
	
	output reg [7:0] g,
	output reg [2:0] gc,
	
	output reg [7:0] h,
	output reg [2:0] hc
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
	
	reg [1:0] hstate, hstate_;
	reg [2:0] hctr, hctr_, hc_;
	localparam HINIT = 0;
	localparam HIDLE = 1;
	
	localparam CFG = 8'b00001001;
	
	always @(posedge clk) begin
		hstate <= hstate_;
		hctr <= hctr_;
		hc <= hc_;
	end
	initial begin
		hstate = HINIT;
		hctr = GDELAY;
		h = CFG;
	end
	
	always @(*) begin
		hstate_ = hstate;
		hctr_ = hctr == 0 ? 0 : hctr - 1;
		hc_ = 0;
		
		case(hstate)
		HINIT:
			if(hctr != 0)
				hc_[2] = hctr != GDELAY;
			else
				hstate_ = HIDLE;
		endcase
	end

endmodule

