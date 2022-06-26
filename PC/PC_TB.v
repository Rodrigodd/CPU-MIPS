`timescale 1ns/1ps
module PC_TB();

reg clk;
reg rst;

PC DUT(
	clk, rst
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

