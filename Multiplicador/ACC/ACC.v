module ACC #(
	parameter WIDTH = 16
) (
	output reg [2*WIDTH:0] Saidas,
	input [WIDTH:0] Soma,
	input [WIDTH-1:0] Multiplicador,
	input [WIDTH-1:0] Multiplicando,
	input Load, Sh, Ad, Clk, Reset
);

always @ (posedge Clk or posedge Reset) begin
	if (Reset) Saidas = 0;
	else if (Load) Saidas = {
		Multiplicador[0] ? Multiplicando : 0,
		Multiplicador
	};
	else if (Sh) Saidas = { 1'b0, Saidas[2*WIDTH:1]};
	else if (Ad) Saidas[2*WIDTH:WIDTH] = Soma;
end

endmodule
