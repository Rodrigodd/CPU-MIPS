`timescale 1ns/1ps
module PC_TB();

reg clk;
reg rst;
wire [31:0] pc;

PC DUT(
	.clk(clk), .rst(rst), .pc(pc)
);

initial begin
	clk = 0;
	rst = 1;
	
	#40
	rst = 0;
	

	#200
	$stop();
end

// f = 50 MHz => Tc = 20
always #10 clk = ~clk;

endmodule

