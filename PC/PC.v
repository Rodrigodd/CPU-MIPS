module PC(
	input clk, rst,
	output reg [31:0] pc
);

always @(posedge clk or posedge rst) pc = rst ? 0 : pc + 1;

endmodule

