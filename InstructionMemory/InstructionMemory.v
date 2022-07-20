module InstructionMemory #(
	parameter INITIAL = "../code.txt",
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 10
) (
	input clk, rst,
	input [ADDR_WIDTH-1:0] addr,
	output reg [DATA_WIDTH-1:0] data
);


// Declare the ROM variable
reg [DATA_WIDTH-1:0] rom[2**ADDR_WIDTH-1:0];

integer i;

initial begin
	for (i = 0; i < 2**ADDR_WIDTH - 1; i = i + 1) begin
		rom[i] = 0;
	end
	$readmemh(INITIAL, rom, 0);
end

always @ (posedge clk or posedge rst) begin
	data <= rst ? 0 : rom[addr];
end

endmodule

