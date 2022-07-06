
// Multiplicador utlizado no trabalho anterior, com modificações para
// reduzir a o números de ciclos por calculo para 32.


// A entrada MultiplicandoReg, possui o mesmo valor que Multiplicando, mas foi
// registrados na mesma borda de clock em que o ACC foi carregado. Isso
// é necessário porque o Multiplicando precisa estar estável durante toda
// a operação, mas o ACC precisa carregar esse valor no mesmo instante em que
// é registrado. Se ACC carregasse do registro haveria um atraso de 1 ciclo,
// e o multiplicador levaria 33 ciclos por operação.
module Multiplicador #(
	parameter WIDTH = 16
) (
	output [2*WIDTH-1:0] Produto,
	input [WIDTH-1:0] Multiplicando, Multiplicador, MultiplicandoReg,
	input Sy,
	input Clk, Reset
);

// A descrição dos sinais Load, Sh, Ad, K, Sy e StSync estão em
// `Multiplicador\Control\Control.v`.

wire[WIDTH:0] Soma;
wire Load, Sh, Ad, K, StSync;

MulControl c1 (Load, Sh, Ad, StSync, Clk, K, Produto[0], Sy, Reset);
ACC #(WIDTH) c2 (
	Produto,
	Soma, Multiplicador, Multiplicando,
	Load, Sh, Ad, Clk, Reset
);
Counter #(.COUNT(2*WIDTH - 1)) c3 (K, Load, StSync, Clk, Reset);
Adder #(WIDTH) c4 (Soma, MultiplicandoReg, Produto[2*WIDTH-1:WIDTH]);

endmodule
