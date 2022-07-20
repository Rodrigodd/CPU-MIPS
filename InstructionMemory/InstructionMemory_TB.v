`timescale 1ns/1ps
module InstructionMemory_TB();

reg clk;
reg rst;
reg [9:0] addr;
wire [31:0] data;


integer k = 0;

InstructionMemory DUT(
	.clk(clk),
	.rst(rst),
	.addr(addr),
	.data(data) 
);

initial begin
	clk = 0;
	rst = 1;
	addr = 0;
	#10
	rst = 0;
	
	// Leitura
	addr = 0;
	
	for (k=0; k < 10; k = k + 1) begin
		#20
		addr = addr + 1;
	end
	
	#20
	$stop();
end

// f = 50 MHz => Tc = 20
always #10 clk = ~clk;

endmodule

