module ALU(
	input [31:0] a, c,
	input [1:0] op,
	output [31:0] out
);

assign out = op == 0 ? a + c
			: op == 1 ? a - c
			: op == 2 ? a & c
			: op == 3 ? a | c
			: 0; // unrechable

endmodule

