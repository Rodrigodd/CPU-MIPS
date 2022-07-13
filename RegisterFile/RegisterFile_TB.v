`timescale 1ns/1ps
module RegisterFile_TB();

reg clk;
reg rst;
reg write_back_en;
reg [4:0] write_back_reg; 
reg [31:0] write_back;
reg [4:0] a_reg, b_reg;
wire [31:0] a, b;


RegisterFile DUT(
	.clk(clk), .rst(rst),
	.write_back_en(write_back_en),
	.write_back_reg(write_back_reg),
	.write_back(write_back),
	.a_reg(a_reg),
	.b_reg(b_reg),
	.a(a),
	.b(b)
);

initial begin
	clk = 0;
	rst = 1;
	#20
	rst = 0;

	#200
	$stop();
end

// f = 50 MHz => Tc = 20
always #10 clk = ~clk;

endmodule

