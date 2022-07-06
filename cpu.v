module cpu #(
	parameter CODE = "code.txt",
	parameter DATA = "data.txt"
) (
	input clk, rst,
	input [31:0] data_bus_read,
	output [31:0] addr, 
	output cs, wr_rd,
	output [31:0] data_bus_write
);

wire clk_sys;
wire clk_mul;
wire pll_locked;
wire rst_sys;

assign clk_mul = clk;
assign rst_sys = rst || !pll_locked; // O sistema permanece resetado enquanto o PLL não estiver "locked".

PLL PLL_(
	rst,
	clk,
	clk_sys,
	pll_locked
);

// O sync_mul é usado para sincronizar o periodo de operação do multiplicador
// com o clk_sys. Mais informações sobre esse sinal estão em
// Multiplicador/Control/Control.v.
//
// A primeira borda de subida de clk_sys ocorre no mesmo instante que o sinal
// pll_locked é ativo, mas essa borda de subida ocorre fora de fase, de modo
// que o primeiro periodo de clock do sistema seja menor que os demais. Logo
// o sinal de sync_mul precisa ser atrasado em 1 cyclo.

wire sync_mul1, sync_mul;

Register SYNC_MUL1(
	clk_sys, rst_sys,
	pll_locked, sync_mul1
);
Register SYNC_MUL(
	clk_sys, rst_sys,
	sync_mul1, sync_mul
);

/// Instruction Fetch

wire [31:0] instr;
wire [31:0] pc_address;

PC PC_(
	clk_sys, rst_sys,
	pc_address
);

InstructionMemory #(CODE) IM(
	clk_sys, rst_sys,
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
	clk_sys, rst_sys,
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
	clk_sys, rst_sys,
	_a_ex, a_ex
);

Register B_EX(
	clk_sys, rst_sys,
	_b_ex, b_ex
);

Register #(12) CTRL_EX(
	clk_sys, rst_sys,
	_ctrl_ex, ctrl_ex
);

Register IMM(
	clk_sys, rst_sys,
	_imm, imm
);


/// Execute

wire [31:0] mul, op, c_ex, d_ex, d_mem, b_mem;

wire c_sel, d_sel;
wire [1:0] op_sel;

wire [7:0] _ctrl_mem, ctrl_mem;

assign { c_sel, d_sel, op_sel, _ctrl_mem } = ctrl_ex;

Multiplicador #(16) MULT(
	mul,
	a_ex, b_ex,
	sync_mul,
	clk_mul, rst_sys
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
	clk_sys, rst_sys,
	d_ex, d_mem
);

Register B_MEM(
	clk_sys, rst_sys,
	b_ex, b_mem
);

Register #(8) CTRL_MEM(
	clk_sys, rst_sys,
	_ctrl_mem, ctrl_mem
);

/// Memory

wire [31:0] c_mem, d_wb, _m_wb, m_wb;
wire rd_wr;

wire [6:0] _ctrl_wb, ctrl_wb;

assign { rd_wr, _ctrl_wb } = ctrl_mem;

assign wr_rd = !rd_wr;

assign addr = d_mem;
assign data_bus_write = b_mem;

ADDRDecoding DEC(
	addr,
	cs
);

DataMemory #(DATA) MEM(
	clk_sys, rst_sys,
	{ !addr[9], addr[8:0] }, data_bus_write,  wr_rd,
	c_mem
);

MUX M_WB_SEL(
	c_mem, data_bus_read,
	cs,
	_m_wb
);

Register D_WB(
	clk_sys, rst_sys,
	d_mem, d_wb
);

Register M_WB(
	clk_sys, rst_sys,
	_m_wb, m_wb
);

Register #(7) CTRL_WB(
	clk_sys, rst_sys,
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

