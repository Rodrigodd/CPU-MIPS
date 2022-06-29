module DataMemory #(
	parameter INITIAL = "data.txt",
	parameter DATA_WIDTH = 32,
	parameter ADDR_WIDTH = 10
) (
	input clk, rst,
	input [ADDR_WIDTH-1:0] addr,
	input [DATA_WIDTH-1:0] data_in,
	input wr_rd, // 0 is write, 1 is read
	output [DATA_WIDTH-1:0] data_out
);

// Declare the RAM variable
reg [DATA_WIDTH-1:0] ram[2**ADDR_WIDTH-1:0];

// Variable to hold the registered read address
reg [ADDR_WIDTH-1:0] addr_reg;

integer i;

initial begin for (i = 0; i < 2**ADDR_WIDTH - 1; i = i + 1) begin
		ram[i] = 0;
	end
	$readmemh(INITIAL, ram, 0);
end

always @ (posedge clk) begin
	// Write
	if (wr_rd == 0)
		ram[addr] <= data_in;

	addr_reg <= addr;
end

// Continuous assignment implies read returns NEW data.
// This is the natural behavior of the TriMatrix memory
// blocks in Single Port mode.  
assign data_out = ram[addr_reg];

endmodule

