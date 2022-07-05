module MulControl(
	output reg Load, Sh, Ad, StSync,
	input Clk, K, M, Sy, Reset
);

// K: O contador está em zero (terminou a última operação).
// M: Se atualmente ACC[0] == 1.
// Sy: Sinal de sincronismo dado pelo sistema. Gerado pelo sistema na primeira
//     borda de subida do clk_sys após o PLL estar "locked", porém o Controle
//     só percebe o sinal um Tmul depois.
//
// Load: Inicia uma operação ao carregar { Multiplicador[0] ? Multiplicando : 0, Multiplicador }
//       no ACC, e inicia o contador em 31.
// Sh: desloca 1 bit a direita o valor no ACC.
// Ad: Soma Multiplicando nos 5 msb do ACC.
// StSync: Inicia o contador em 29. Como S é sinalizado pelo sistema com 1
//         clock de atraso da borda de subida de clk_sys, quando a maquina de
//         estado notar que K=1 terá se passado 30 cyclos, de modo que
//         o multiplicador se torne sincronizado no ciclo seguinte.
//
//                   ┌────────┐
//                   ▼        0
//       Reset──▶|OutSync|──▶<Sy>1───┐
//                                   │
//       ┌───────┐                   │
//       0       ▼                   │
//      <K>◀───|WaitSync|◀──(StSync)─┘
//       1
//       │   ┌───────────────(Sh)◀───────────┐
//       │   │                               │
//       │   ▼                               │
//       └─▶|S0|──▶<K>0────▶<M>0───────────▶|S1|
//                  1        1               ▲
//                  ▼        ▼               │
//                (Load)    (Ad)             │
//                  └────────┴───────────────┘

// Declare states
parameter OutSync = 0, WaitSync = 1, S0 = 2, S1 = 3;

// Declare state register
reg	[1:0] state;

// Determine the next state synchronously, based on the
// current state and the input
always @ (posedge Clk or posedge Reset) begin
	if (Reset) state = OutSync;
	else case (state)
		OutSync: if (Sy) state <= WaitSync;
		WaitSync: if(K) state <= S0;
		S0:
			state <= S1;
		S1:
			state <= S0;
	endcase
end

// Determine the output based only on the current state
// and the input (do not wait for a clock edge).
always @ (state, Clk, K, M, Reset, Sy, StSync)
begin
		Load = 0;
		Sh = 0;
		Ad = 0;
		StSync = 0;
		case (state)
			OutSync: if (Sy) StSync = 1;
			WaitSync: ;
			S0: begin
				if (K) Load = 1;
				else if (M) Ad = 1;
			end
			S1: begin
				Sh = 1;
			end
		endcase
end

endmodule
