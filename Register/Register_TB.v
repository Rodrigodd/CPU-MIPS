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

	rst = 1;
	#50
	d = 1;
	
	#50
	rst = 0;
	#50
	d = 0;

	#200
	$stop();
end

// f = 50 MHz => Tc = 20
always #10 clk = ~clk;

endmodule

