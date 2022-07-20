`timescale 1ns/1ps
module DataMemory_TB();

reg clk;
reg rst;
reg wr_rd;
reg [9:0] addr;
reg [31:0] data_in;
wire [31:0] data_out;

integer k = 0;

DataMemory DUT(
	.clk(clk), .rst(rst), .wr_rd(wr_rd), .addr(addr),
	.data_in(data_in), .data_out(data_out)
);

initial begin
	clk = 0;
	rst = 1;
	wr_rd = 1;
	data_in = 0;
	addr = 0;
	#10
	rst = 0;
	
	// Leitura
	wr_rd = 1;
	addr = 0;
	
	for (k=0; k < 10; k = k + 1) begin
		#20
		addr = addr + 1;
	end
	
	// Escrita
	wr_rd = 0;
	
	addr = 0;
	data_in = 32'b0;
	
	for (k=0; k < 10; k = k + 1) begin
		#20
		addr = addr + 1;
		data_in = data_in + 1;
	end
	
	// Leitura
	wr_rd = 1;
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



