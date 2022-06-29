module Extend(
	input [31:0] instr,
	output [31:0] imm
);

assign imm = { 16'b0, instr[15:0] };

endmodule

