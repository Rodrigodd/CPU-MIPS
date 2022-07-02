module ACC #(
	parameter WIDTH = 33
) (
	output reg [WIDTH-1:0] Saidas,
	input [WIDTH-1:0] Entradas,
	input [(WIDTH-1)/2-1:0] Multiplicando,
	input Load, Sh, Ad, Clk, Reset
);

always @ (posedge Clk or posedge Reset) begin
	if (Reset) Saidas = 0;
	else if (Load) Saidas = {
		Entradas[0] ? Multiplicando : 0,
		Entradas[(WIDTH-1)/2-1:0]
	};
	else if (Sh) Saidas = { 1'b0, Saidas[WIDTH-1:1]};
	else if (Ad) Saidas[WIDTH-1:(WIDTH-1)/2] = Entradas[WIDTH-1:(WIDTH-1)/2];
end

endmodule
