module cpu(
	input clk, rst
);

/// Instruction Fetch

InstructionMemory im(
	clk, rst
);

PC pc(
	clk, rst
);

/// Instruction Decode

RegisterFile rf(
	clk, rst
);

Control ctrl(
	clk, rst
);

Extend ext(
	clk, rst
);

/// Execute

Multiplicador mult(
	clk, rst
);

ALU alu(
	clk, rst
);

/// Memory

ADDRDecoding dec(
	clk, rst
);

DataMemory mem(
	clk, rst
);

/// Write Back


endmodule

