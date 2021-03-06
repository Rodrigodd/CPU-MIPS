module Counter #(
	parameter COUNT = 31
) (
	output K,
	input Load, Clk, Reset
);

(*keep=1*) reg [4:0] counter;

assign K = counter == 0;

always @ (posedge Clk or posedge Reset) begin
	if (Reset) counter = 0;
	else if (Load) counter = COUNT;
	else if (!K) counter = counter - 1;
end

endmodule
