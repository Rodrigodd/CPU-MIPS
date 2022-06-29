module cpu(
	input clk, rst,
	input data_bus_read,
	output [31:0] addr, 
	output cs, wr_rd,
	output [31:0] data_bus_write
);

/// Instruction Fetch

wire [31:0] instr;
wire [31:0] pc_address;

PC PC_(
	clk, rst,
	pc_address
);

InstructionMemory IM(
	clk, rst,
	pc_address,
	instr
);

/// Instruction Decode

wire write_back_en;
wire [4:0] write_back_reg;
wire [31:0] write_back;

wire [4:0] a_reg, b_reg;
wire [31:0] _a_ex, a_ex, _b_ex, b_ex;
wire[31:0] _imm, imm;

// { c_sel[1], d_sel[1], op_sel[2], wr_rd[1], wb_sel[1], write_back_en[1], write_back_reg[5] }
wire[11:0] _ctrl_ex, ctrl_ex;

RegisterFile RF(
	clk, rst,
	write_back_en, write_back_reg, write_back,
	a_reg, b_reg,
	_a_ex, _b_ex
);

Control CTRL(
	instr,
	a_reg, b_reg, _ctrl_ex
);

Extend EXT(
	instr,
	_imm
);

Register A_EX(
	clk, rst,
	_a_ex, a_ex
);

Register B_EX(
	clk, rst,
	_b_ex, b_ex
);

Register CTRL_EX(
	clk, rst,
	_ctrl_ex, ctrl_ex
);

Register IMM(
	clk, rst,
	_imm, imm
);


/// Execute

wire [31:0] mul, op, c_ex, d_ex, d_mem, b_mem;

wire c_sel, d_sel;
wire [1:0] op_sel;

wire [7:0] _ctrl_mem, ctrl_mem;

assign { c_sel, d_sel, op_sel, _ctrl_mem } = ctrl_ex;

Multiplicador MULT(
	clk, rst,
	a_ex, b_ex,
	mul
);

MUX C_SEL(
	b_ex, imm,
	c_sel,
	c_ex
);

ALU ALU_(
	a_ex, c_ex,
	op_sel,
	op
);

MUX D_EX_SEL(
	mul, op,
	d_sel,
	d_ex
);

Register D_MEM(
	clk, rst,
	d_ex, d_mem
);

Register B_MEM(
	clk, rst,
	b_ex, b_mem
);

Register CTRL_MEM(
	clk, rst,
	_ctrl_mem, ctrl_mem
);

/// Memory

wire [31:0] c_mem, m_mem, _d_wb, d_wb, m_wb;

wire [6:0] _ctrl_wb, ctrl_wb;

assign { wr_rd, _ctrl_wb } = ctrl_mem;
assign addr = d_mem;
assign data_bus_write = b_mem;

ADDRDecoding DEC(
	clk, rst,
	addr,
	cs
);

DataMemory MEM(
	clk, rst,
	addr, data_bus_write,  wr_rd,
	c_mem
);

MUX D_WB_SEL(
	c_mem, data_bus_read,
	cs,
	_d_wb
);

Register D_WB(
	clk, rst,
	_d_wb, d_wb
);

Register M_WB(
	clk, rst,
	m_mem, m_wb
);

Register CTRL_WB(
	clk, rst,
	_ctrl_wb, ctrl_wb
);

/// Write Back

wire wb_sel;

assign { wb_sel, write_back_en, write_back_reg } = ctrl_wb;

MUX WB_SEL(
	d_wb, m_wb,
	wb_sel,
	write_back
);

endmodule

