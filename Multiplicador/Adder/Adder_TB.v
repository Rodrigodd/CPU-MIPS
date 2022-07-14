`timescale 1ns/1ps
module Adder_TB();

wire [16:0] Soma;
reg [15:0] OperandoA,OperandoB;
integer i,j;

Adder DUT(
			.Soma(Soma),
			.OperandoA(OperandoA),
			.OperandoB(OperandoB)
);
 
initial begin
	for(i = 0; i<16;i=i+1)
	begin
		#20
		OperandoA = i;
		for(j = 0; j<16;j=j+1)
		begin
			OperandoB = j;
			#20
			$display("OperandoA=%d OperandoB=%d Soma=%d",OperandoA,OperandoB,Soma);
		end	
	end	
	OperandoA = 16'hffff;
	OperandoB = 16'hffff;
	#20
	$display("OperandoA=%x OperandoB=%x Soma=%x",OperandoA,OperandoB,Soma);

end
	

endmodule
