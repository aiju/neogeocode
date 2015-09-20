module switch(
	input wire clk,
	
	input wire m68kreq,
	input wire [19:0] m68kaddr,
	input wire [15:0] m68kwdata,
	input wire m68kwr,
	output wire m68kack,
	output wire [15:0] m68krdata,
	
	output wire bootreq,
	output wire [15:0] bootaddr,
	input wire bootack,
	input wire [15:0] bootdata,
	
	input wire avl_ready,
	output wire avl_burstbegin,
	output wire [25:0] avl_addr,
	input wire avl_rdata_valid,
	input wire [31:0] avl_rdata,
	output wire [31:0] avl_wdata,
	output wire avl_read_req,
	output wire avl_write_req,
	output wire [2:0] avl_size
);

endmodule
