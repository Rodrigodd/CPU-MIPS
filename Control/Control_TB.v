`timescale 1ns/1ps
module Control_TB();

reg [31:0] instr;
wire [4:0] a_reg, b_reg;
wire [11:0] ctrl_ex;

Control DUT(
	.instr(instr),
	.a_reg(a_reg),
	.b_reg(b_reg),
	.ctrl_ex(ctrl_ex)
);

initial begin

	// O código a ser testado é:
	//
	// lw r0, 1(r31) 
	// lw r1, 2(r31) 
	// mul r4, r0, r1 
	// add r5, r3, r4 
	// sub r6, r4, r5 
	// sw r6, 0xdfff(r31)
	// or r1, r1, r1 
	// add r5, r2, r3

	instr = 32'h0;
	#20 instr = 32'h0fe00001;
	#20 instr = 32'hfe10002;
	#20 instr = 32'h080122b2;
	#20 instr = 32'h08642aa0;
	#20 instr = 32'h088532a2;
	#20 instr = 32'h13e6dfff;
	#20 instr = 32'h08210aa5;
	#20 instr = 32'h08432aa0;

	#20
	$stop();
end

endmodule

