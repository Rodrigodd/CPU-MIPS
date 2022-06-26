module Register#(
	parameter WIDTH = 32
) (
	input clk, rst,
	input [WIDTH - 1:0] d,
	output reg [WIDTH - 1:0] q
);

always @(posedge clk or posedge rst) q = rst ? 0 : d;

endmodule

