`timescale 1ns/1ps
module ALU_TB();

reg [31:0] a, c;
reg [1:0] op;
wire  [31:0] out;

ALU DUT(
	.a(a), 
	.c(c), 
	.op(op), 
	.out(out)
);

initial begin
	a <= 32'h0000000A;
	c <= 32'h00000001;
	op <= 0;
	
	#20 op <= 1;
	#20 op <= 2;
	#20 op <= 3;
	
	#20 
	a <= 32'h0000000F;
	c <= 32'h00000003;
	op <= 0;
	
	#20 op <= 1;
	#20 op <= 2;
	#20 op <= 3;
	
	// Testando Overflow
	#20 
	a <= 32'hFFFFFFFF;
	c <= 32'h00000001;
	op <= 0;
	
	// Testando Underflow
	#20 
	a <= 32'h00000000;
	c <= 32'h00000001;
	op <= 1;
	
	#200
	$stop();
end

endmodule

