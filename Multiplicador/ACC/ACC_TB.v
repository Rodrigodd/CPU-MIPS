`timescale 1ns/100ps
module ACC_TB();

wire [32:0] Saidas;
reg [16:0] Soma;
reg [15:0] Multiplicador, Multiplicando;
reg Load, Sh, Ad, Clk, Reset;
integer i;

ACC DUT (
	.Saidas(Saidas),
	.Soma(Soma),
	.Multiplicador(Multiplicador),
	.Multiplicando(Multiplicando),
	.Load(Load),
	.Sh(Sh),
	.Ad(Ad),
	.Clk(Clk),
	.Reset(Reset)
);

initial begin
	Clk = 1;
	Sh = 0;
	Ad = 0;
	Load = 1;
	Reset = 1;
	Soma  = 0;
	Multiplicador = 0;
	Multiplicando = 0;

	#30
	Reset = 0;
	// Vai carregar h00000_0000 em Saidas
	Multiplicador = 16'h0;
	Multiplicando = 16'ha0a0;
	
	#20 
	// Vai carregar h00000_00fe em Saidas
	Multiplicador = 16'hfe;
	Multiplicando = 16'hb0b0;
	
	#20 
	// Vai carregar h0c0c0_0f0f em Saidas
	Multiplicador = 16'h0f0f;
	Multiplicando = 16'hc0c0;
	
	for(i = 0; i<4;i=i+1)
	begin
		#20 
		Sh = 1;
		Load = 0;
	end
	
	/// Saida agora é h00c0c_00f0
	#20
	Sh = 0;
	Ad = 1;
	Multiplicador = 16'h70;
	// Vai ficar h10d0d_00f0 em Saidas
	Soma  = 17'h10d0d;
	
	#20 
	// Vai ficar h1f000_00f0 em Saidas
	Soma  = 17'h1f000;

	#20 
	// Vai ficar h00400_00f0 em Saidas
	Soma  = 17'h00400;

	#40
	$stop;
end

always begin
	#10 Clk = ~Clk;
end

endmodule
