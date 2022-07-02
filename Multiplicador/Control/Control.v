module Control(
	output reg Load, Sh, Ad,
	input Clk, K, M, Reset
);

//   ┌───────────────(Sh)────────────┐
//   │                               │
//   ▼                               │
//  |S0|───<K>0────►<M>0───────────►|S1|
//          1        1               ▲
//          ▼        ▼               │
//        (Load)   (Add)             │
//          └────────┴───────────────┘

// Declare states
parameter S0 = 0, S1 = 1;

// Declare state register
reg	state;

// Determine the next state synchronously, based on the
// current state and the input
always @ (posedge Clk or posedge Reset) begin
	if (Reset) state = S0;
	else case (state)
		S0:
			state <= S1;
		S1:
			state <= S0;
	endcase
end

// Determine the output based only on the current state
// and the input (do not wait for a clock edge).
always @ (state, Clk, K, M, Reset)
begin
		Load = 0;
		Sh = 0;
		Ad = 0;
		case (state)
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
