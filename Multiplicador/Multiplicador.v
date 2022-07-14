
// Multiplicador utlizado no trabalho anterior, com modificações para
// reduzir a o números de ciclos por calculo para 33.

module Multiplicador #(
	parameter WIDTH = 16
) (
	output [2*WIDTH-1:0] Produto,
	input [WIDTH-1:0] Multiplicando, Multiplicador,
	input St,
	input Clk, Reset
);

// A descrição dos sinais Load, Sh, Ad, K e St estão em
// `Multiplicador\Control\MulControl.v`.

wire[WIDTH:0] Soma;
wire[2*WIDTH:0] Saidas;
wire Load, Sh, Ad, K;

assign Produto = Saidas[2*WIDTH-1:0];

MulControl c1 (Load, Sh, Ad, Clk, K, Produto[0], St, Reset);
ACC #(WIDTH) c2 (
	Saidas,
	Soma, Multiplicador, Multiplicando,
	Load, Sh, Ad, Clk, Reset
);
Counter #(.COUNT(2*WIDTH - 1)) c3 (K, Load, Clk, Reset);
Adder #(WIDTH) c4 (Soma, Multiplicando, Produto[2*WIDTH-1:WIDTH]);

endmodule
