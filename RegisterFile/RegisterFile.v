module RegisterFile(
	input clk, rst,
	input write_back_en,
	input [4:0] write_back_reg, 
	input [31:0] write_back,
	input [4:0] a_reg, b_reg,
	output [31:0] a, b
);

reg [31:0] registers [31:0];

assign a = registers[a_reg];
assign b = registers[b_reg];

integer i;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		// clear all registers
		for (i = 0; i < 32; i = i + 1) begin
			registers[i] = 0;
		end
	end else begin
		if (write_back_en)
			registers[write_back_reg] <= write_back;
	end
end

endmodule

