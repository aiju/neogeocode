`default_nettype none

module mem(
	input wire clk,
	output reg memreset,
	
	input wire [19:0] memaddr,
	input wire memwr,
	input wire [31:0] memwdata,
	input wire memreq,
	output reg memack,
	output reg [31:0] memrdata,
	
	output reg [14:0] ddra,
	output reg [2:0] ddrba,
	output reg ddrcke,
	output wire ddrcs,
	output wire ddrras,
	output wire ddrcas,
	output wire ddrwe,
	output reg ddrreset,
	input wire [15:0] ddrdqin,
	output reg [15:0] ddrdqout,
	output reg ddrdqt,
	output reg ddrdqspre
);

	parameter MHZ = 160;
	
	`define ns2CK(n) (((n) * MHZ + 999) / 1000)
	`define max(a,b) ((a)>(b)?(a):(b))

	localparam tRESET = `ns2CK(200000);
	localparam tCKE = `ns2CK(500000);
	localparam tXPR = `max(`ns2CK(170), 5);
	localparam tRCD = `ns2CK(13.75);
	localparam tRP = `ns2CK(13.75);
	localparam tCAS = 6;
	localparam tMRD = 4;
	localparam tZQC = 512;
	localparam BL = 4;
	
	localparam MR0 = 1<<10 | 1<<5 | 1<<1;
	localparam MR1 = 1<<11 | 1<<2 | 1<<0;
	localparam MR2 = 1<<3;
	localparam MR3 = 0;
	
	reg [3:0] state;
	reg [31:0] ctr;
	localparam RESET = 0;
	localparam CKE = 1;
	localparam CKEW = 2;
	localparam MRS2 = 3;
	localparam MRS3 = 4;
	localparam MRS0 = 5;
	localparam ZQCA = 6;
	localparam IDLE = 7;
	localparam READ = 8;
	localparam RDDATA0 = 9;
	localparam RDDATA1 = 10;
	localparam WRITE = 11;
	localparam WRDATAPRE = 12;
	localparam WRDATA0 = 13;
	localparam WRDATA1 = 14;

	reg [2:0] cmd;
	assign {ddrras, ddrcas, ddrwe} = cmd;
	assign ddrcs = 1'b0;
	reg memreq0;
	localparam MRS = 3'b000;
	localparam REF = 3'b001;
	localparam PRE = 3'b010;
	localparam ACT = 3'b011;
	localparam WR = 3'b100;
	localparam RD = 3'b101;
	localparam ZQC = 3'b110;
	localparam NOP = 3'b111;
	
	initial begin
		state = RESET;
		ctr = tRESET - 1;
		ddrcke = 0;
		ddrreset = 0;
		memreset = 1;
		cmd = NOP;
	end
	
	always @(posedge clk) begin
		cmd <= NOP;
		ddra <= 15'bx;
		ddrba <= 3'bx;
		if(memreq)
			memreq0 <= 1;
		memack <= 0;
		ddrdqt <= 1;
		ddrdqspre <= 0;

		if(ctr != 0)
			ctr <= ctr - 1;
		else
			case(state)
			RESET: begin
				ddrreset <= 1;
				state <= CKE;
			end
			CKE: begin
				ddrcke <= 1;
				state <= CKEW;
				ctr <= tXPR - 1;
			end
			CKEW: begin
				state <= MRS2;
				ctr <= tMRD - 1;
				cmd <= MRS;
				ddra <= MR2;
				ddrba <= 3'b010;
			end
			MRS2: begin
				state <= MRS3;
				ctr <= tMRD - 1;
				cmd <= MRS;
				ddra <= MR3;
				ddrba <= 3'b010;
			end
			MRS3: begin
				state <= MRS0;
				ctr <= tMRD - 1;
				cmd <= MRS;
				ddra <= MR0;
				ddrba <= 3'b000;
			end
			MRS0: begin
				state <= ZQCA;
				ctr <= tMRD - 1;
				cmd <= MRS;
				ddra <= MR1;
				ddrba <= 3'b001;
			end
			ZQCA: begin
				state <= IDLE;
				ctr <= tZQC - 1;
				cmd <= ZQC;
				ddra[10] <= 1;
				memreset <= 0;
			end
			IDLE:
				if(memreq || memreq0) begin
					memreq0 <= 0;
					ddra <= memaddr[19:10];
					cmd <= ACT;
					ctr <= tRCD - 1;
					state <= memwr ? WRITE : READ;
				end
			READ: begin
				ddra[9:0] <= memaddr[9:0];
				ddra[10] <= 1;
				cmd <= RD;
				state <= RDDATA0;
				ctr <= tCAS + 1;
			end
			RDDATA0: begin
				memrdata[15:0] <= ddrdqin;
				state <= RDDATA1;
			end
			RDDATA1: begin
				memack <= 1;
				memrdata[31:16] <= ddrdqin;
				state <= IDLE;
				ctr <= tRP;
			end
			WRITE: begin
				ddra[9:0] <= memaddr[9:0];
				ddra[10] <= 1;
				ddrdqout <= memwdata[15:0];
				cmd <= WR;
				state <= WRDATAPRE;
				ctr <= tCAS - 1;
			end
			WRDATAPRE: begin
				ddrdqout <= memwdata[31:16];
				ddrdqspre <= 1;
				ddrdqt <= 0;
				state <= WRDATA0;
			end
			WRDATA0: begin
				ddrdqt <= 0;
				state <= WRDATA1;
			end
			WRDATA1: begin
				ddrdqt <= 0;
				state <= IDLE;
				memack <= 1;
				ctr <= tRP;
			end
			endcase
	end
	

endmodule
