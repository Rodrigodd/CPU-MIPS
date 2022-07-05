module Counter #(
	parameter COUNT = 31
) (
	output K,
	input Load, StSync, Clk, Reset
);

reg [4:0] counter;

assign K = counter == 0;

always @ (posedge Clk or posedge Reset) begin
	if (Reset) counter = 0;
	else if (Load) counter = COUNT;
	else if (StSync) counter = COUNT-2;
	else if (!K) counter = counter - 1;
end

endmodule
