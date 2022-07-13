module Adder_TB();

wire [4:0] Soma;
reg [3:0] OperandoA,OperandoB;
integer i,j;

Adder DUT(
			.Soma(Soma),
			.OperandoA(OperandoA),
			.OperandoB(OperandoB)
);
 
initial begin
	for(i = 0; i<16;i=i+1)
	begin
		#10
		OperandoA = i;
		for(j = 0; j<16;j=j+1)
		begin
			OperandoB = j;
			#10
			$display("OperandoA=%d OperandoB=%d Soma=%d",OperandoA,OperandoB,Soma);
		end	
	end	

end
	

endmodule
