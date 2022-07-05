`timescale 1ns/1ps
module DataMemory_TB();

parameter INITIAL = "../../dataTB.txt";
parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 10;

reg clk;
reg rst;
reg wr_rd;
reg [ADDR_WIDTH-1:0] addr;
reg [DATA_WIDTH-1:0] data_in;
wire [DATA_WIDTH-1:0] data_out;

integer k = 0;

DataMemory #(.INITIAL(INITIAL)) DUT(
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
	
	#200
	$stop();
end

// f = 50 MHz => Tc = 20
always #10 clk = ~clk;

endmodule



