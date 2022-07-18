module MulControl(
	output reg Load, Sh, Ad,
	input Clk, K, M, St, Reset
);

// K: O contador está em zero (terminou a última operação).
// M: Se atualmente ACC[0] == 1.
// St: Sinal de inicio, gerado pelo sistema para sincronizacao.
//
// Load: Inicia uma operação ao carregar { Multiplicador[0] ? Multiplicando : 0, Multiplicador }
//       no ACC, e inicia o contador em 31.
// Sh: desloca 1 bit a direita o valor no ACC.
// Ad: Soma Multiplicando nos 5 msb do ACC.
//
//        ┌───────────────(Sh)◀───────────┐
//        │                               │
//        ▼                               │
//       |S0|──▶<K>0────▶<M>0───────────▶|S1|
//               1        1               ▲
//               ▼        ▼               │
//  Reset──┬──▶|Done|    (Ad)─────────────┤
//         │     │                        │
//         │     ▼                        │
//         └───0<St>1────▶(Load)──────────┘                      

// Declare states
parameter S0 = 0, S1 = 1, Done = 2;

// Declare state register
(*keep=1*) reg	[1:0] state;

// Determine the next state synchronously, based on the
// current state and the input
always @ (posedge Clk or posedge Reset) begin
	if (Reset) state = Done;
	else case (state)
		S0: state <= K ? Done : S1;
		S1: state <= S0;
		Done: state <= St ? S1 : Done;
	endcase
end

// Determine the output based only on the current state
// and the input (do not wait for a clock edge).
always @ (state, Clk, K, M, Reset, St)
begin
		Load = 0;
		Sh = 0;
		Ad = 0;
		case (state)
			S0: begin
				if (!K && M) Ad = 1;
			end
			S1: begin
				Sh = 1;
			end
			Done: Load = 1;
		endcase
end

endmodule
