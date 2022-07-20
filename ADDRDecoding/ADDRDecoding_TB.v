`timescale 1ns/1ps
module ADDRDecoding_TB();

reg [31:0] addr;
wire cs; // 0 = memoria interna, 1 = memoria externa
integer k = 0;


ADDRDecoding DUT(
	.addr(addr),
	.cs(cs)
);

initial begin


	// Testando endereço anterior ao intervalo
	addr = 32'h0;
	#20 addr = 32'h09FF;
		
	// Testando endereços dentro do intervalo
	#20 addr = 32'h0A00;
	#20 addr = 32'h0AFF;
	#20 addr = 32'h0B00;
	#20 addr = 32'h0BFF;
	#20 addr = 32'h0C00;
	#20 addr = 32'h0CFF;
	#20 addr = 32'h0D00;
	#20 addr = 32'h0DFF;
	
	//Testando enderço posterior ao intervalo
	#20 addr = 32'h0E00;
	
	//Testando bits superiores
	#20 addr = 32'hFFFF0B00;
	#20 addr = 32'hFFFF0E00;
	#20 addr = 32'hFFFFFFFF;
		
	#20
	$stop();
end

endmodule
