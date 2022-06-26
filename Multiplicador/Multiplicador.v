module Multiplicador(
	input clk, rst,
	input [31:0] a, b,
	output [31:0] mul
);

assign mul = a * b;

endmodule

