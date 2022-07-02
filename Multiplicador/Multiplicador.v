
// Multiplicador utlizado no trabalho anterior, com modificações para
// reduzir a o números de ciclos por calculo para 32.


module Multiplicador #(
	parameter WIDTH = 16
) (
	output [2*WIDTH-1:0] Produto,
	input [WIDTH-1:0] Multiplicando, Multiplicador,
	input Clk, Reset
);

wire[WIDTH:0] Soma;
wire Load, Sh, Ad, K;

Control c1 (Load, Sh, Ad, Clk, K, Produto[0], Reset);
ACC #(2*WIDTH+1) c2 (
	Produto,
	{ Soma, Multiplicador }, Multiplicando,
	Load, Sh, Ad, Clk, Reset
);
Counter #(.COUNT(2*WIDTH - 1)) c3 (K, Load, Clk, Reset);
Adder #(WIDTH) c4 (Soma, Multiplicando, Produto[2*WIDTH-1:WIDTH]);

endmodule
