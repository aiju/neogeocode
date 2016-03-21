module bus68k(
	input wire clk,
	input wire rst,
	
	input wire as,
	input wire rw,
	input wire romoe,
	input wire portadrs,
	input wire portwel,
	input wire portweu,
	input wire portoel,
	input wire portoeu,
	input wire romoeu,
	input wire romoel,
	
	inout wire [15:0] d68k,
	output wire d68kdir,
	output wire d68koel,
	output wire d68koeh,
	
	output wire a68kreq,
	input wire [18:0] a68kaddr,
	input wire a68kack,
	
	output wire m68kreq,
	output wire [19:0] m68kaddr,
	output reg [15:0] m68kwdata,
	output wire m68kwr,
	input wire m68kack,
	input wire [15:0] m68krdata
);

	wire ass, portadrss, romoes, portwels, portweus;
	reg ass0, romoes0, portwels0, portweus0;
	reg [15:0] dreg;
	reg ardy, drdy;

	sync portadrssync(clk, portadrs, portadrss);
	sync romoesync(clk, romoe, romoes);
	sync portwelsync(clk, portwel, portwels);
	sync portweusync(clk, portweu, portweus);
	sync assync(clk, as, ass);
	
	assign a68kreq = !ass && ass0 && !portadrss || !romoes && romoes0;
	assign m68kaddr = {romoe, a68kaddr};
	assign m68kreq = !m68kwr ? a68kack : ardy && drdy;
	assign m68kwr = !rw;
	
	assign d68kdir = !(portoel && romoel && portoeu && romoeu);
	assign d68koel = portoel && romoel && d68kdir;
	assign d68koeh = portoeu && romoeu && d68kdir;
	assign d68k = d68kdir ? dreg : 16'bz;

	always @(posedge clk or posedge rst) begin
		if(rst) begin
			ass0 <= 1;
			romoes0 <= 1;
			portwels0 <= 1;
			portweus0 <= 1;
			dreg <= 16'bx;
			ardy <= 0;
			drdy <= 0;
		end else begin
			ass0 <= ass;
			romoes0 <= romoes;
			portwels0 <= portwels;
			portweus0 <= portweus;
			
			if(!portwels && portwels0) begin
				m68kwdata[7:0] <= d68k[7:0];
				drdy <= 1;
			end
			if(!portweus && portweus0) begin
				m68kwdata[15:8] <= d68k[15:8];
				drdy <= 1;
			end
			if(a68kack && m68kwr)
				ardy <= 1;
			if(m68kack)
				dreg <= m68krdata;
			if(ardy && drdy) begin
				ardy <= 0;
				drdy <= 0;
			end
		end
	end

endmodule
