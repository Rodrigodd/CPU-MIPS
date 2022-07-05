`timescale 1ns/1ps
module InstructionMemory_TB();
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 10;

parameter INSTRTB = "../../INSTRTB.txt";
reg clk;
reg rst;
reg [ADDR_WIDTH-1:0] addr;
wire [DATA_WIDTH-1:0] data;

InstructionMemory #(.INITIAL(INSTRTB))DUT(
	.clk(clk),
	.rst(rst),
	.addr(addr),
	.data(data) 
);

initial begin
	clk = 0;
	rst = 0;
	integer i;
	for (i=1; i<10 ; i=i+1) begin
		
	end

	#200
	$stop();
end

// f = 50 MHz => Tc = 20
always #10 clk = ~clk;

endmodule

