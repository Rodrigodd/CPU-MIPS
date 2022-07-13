`timescale 1ns/1ps
module Register_TB();

parameter WIDTH = 32;

reg clk;
reg rst;
reg [WIDTH - 1:0] d;
wire [WIDTH - 1:0] q;

Register DUT(
	.clk(clk), .rst(rst), .d(d), .q(q)
);

initial begin
	clk = 0;
	d = 1;
	rst = 0;
	
	#100
	rst = ~rst;

	#200
	$stop();
end

// f = 50 MHz => Tc = 20
always #10 clk = ~clk;


endmodule

