module Extend(
	input [31:0] instr,
	output [31:0] imm
);

// Fazendo extensão de sinal
assign imm = { {16{instr[15]}}, instr[15:0] };

endmodule

