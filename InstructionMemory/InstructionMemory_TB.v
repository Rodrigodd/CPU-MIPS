`timescale 1ns/1ps
module InstructionMemory_TB();
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 10;

parameter INITIAL = "../../INITIALTB.txt";
reg clk;
reg rst;
reg [ADDR_WIDTH-1:0] addr;
wire [DATA_WIDTH-1:0] data;


integer k = 0;

InstructionMemory #(.INITIAL(INITIAL))DUT(
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
	
	// Escrita
	
	addr = 0;
	
	for (k=0; k < 10; k = k + 1) begin
		#20
		addr = addr + 1;
	end
	
	// Leitura
	addr = 0;
	
	for (k=0; k < 10; k = k + 1) begin
		#20
		addr = addr + 1;
		
	end
	
	#200
	$stop();
end

// f = 50 MHz => Tc = 20
always #10 clk = ~clk;

endmodule

