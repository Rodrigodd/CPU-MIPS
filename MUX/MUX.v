module MUX(
	input [31:0] a, b,
	input sel,
	output [31:0] q
);

assign q = sel ? b : a;

endmodule

