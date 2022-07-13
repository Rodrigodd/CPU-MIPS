`timescale 1ns/1ps
module Extend_TB();

reg [31:0] instr;
wire [31:0] imm;

Extend DUT(
	.instr(instr),
	.imm(imm)
);

initial begin
	// Os 16 primeiros bits serão ignorados
	instr <= 32'h11111111;
	#20 instr <= 32'h00008001;
	#20 instr <= 32'h22222222;
	#20 instr <= 32'h00009123;
	
	#200
	$stop();
end

endmodule

