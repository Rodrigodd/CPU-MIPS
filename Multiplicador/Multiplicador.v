
// Multiplicador utlizado no trabalho anterior, com modificações para
// reduzir a o números de ciclos por calculo para 32.


module Multiplicador #(
	parameter WIDTH = 16
) (
	output [2*WIDTH-1:0] Produto,
	input [WIDTH-1:0] Multiplicando, Multiplicador,
	input Sy,
	input Clk, Reset
);

// A descrição dos sinais Load, Sh, Ad, K, Sy e StSync estão em
// `Multiplicador\Control\Control.v`.

wire[WIDTH:0] Soma;
wire Load, Sh, Ad, K, StSync;

MulControl c1 (Load, Sh, Ad, StSync, Clk, K, Produto[0], Sy, Reset);
ACC #(2*WIDTH+1) c2 (
	Produto,
	{ Soma, Multiplicador }, Multiplicando,
	Load, Sh, Ad, Clk, Reset
);
Counter #(.COUNT(2*WIDTH - 1)) c3 (K, Load, StSync, Clk, Reset);
Adder #(WIDTH) c4 (Soma, Multiplicando, Produto[2*WIDTH-1:WIDTH]);

endmodule
