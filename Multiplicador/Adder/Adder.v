module Adder #(
	parameter WIDTH = 16
) (
	output [WIDTH:0] Soma,
	input [WIDTH-1:0] OperandoA, OperandoB
);

assign Soma = OperandoA + OperandoB;

endmodule
