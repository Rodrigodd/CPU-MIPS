module DataMemory(
	input clk, rst,
	input [31:0] addr,
	input [31:0] data_in,
	input wr_rd, // 0 is write, 1 is read
	output [31:0] data_out
);

endmodule

