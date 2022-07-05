`timescale 1ns/1ps
module TB();

parameter T_CLK = 20; // 50 MHz
parameter T_CLK_SYS = 20*32; // 50/32 MHz

reg clk;

reg rst;
reg data_bus_read;
wire [31:0] addr;
wire cs, wr_rd;
wire [31:0] data_bus_write;

cpu #(
	.CODE("../../code.txt"),
	.DATA("../../data.txt")
) DUT (
	clk, rst,
	data_bus_read,
	addr,
	cs, wr_rd,
	data_bus_write
);

reg clk_sys, clk_mul, pll_locked, sync_mul;
reg [31:0] instr, pc, a, b, c, imm, d_mem;
reg [11:0] ctrl_ex;
reg [7:0] ctrl_mem;
reg [6:0] ctrl_wb;

reg Load;
reg StSync;
reg [1:0] mul_state;
reg [4:0] counter;

wire c_sel; // ALU operator is B or IMM?
wire d_sel; // MUL or ALU?
wire [1:0] op_sel; // +, -, & or |?
wire _wr_rd; // 0 = write, 1 = read
wire wb_sel; // write back D or M?
wire write_back_en; // 1 = write to register
wire [4:0] write_back_reg; // target register

assign { c_sel, d_sel, op_sel, _wr_rd, wb_sel, write_back_en, write_back_reg } = ctrl_ex;

initial begin
	$init_signal_spy("/DUT/clk_sys", "clk_sys", 1);
	$init_signal_spy("/DUT/clk_mul", "clk_mul", 1);
	$init_signal_spy("/DUT/pll_locked", "pll_locked", 1);
	$init_signal_spy("/DUT/sync_mul", "sync_mul", 1);
	$init_signal_spy("/DUT/instr", "instr", 1);
	$init_signal_spy("/DUT/pc_address", "pc", 1);
	$init_signal_spy("/DUT/a_ex", "a", 1);
	$init_signal_spy("/DUT/b_ex", "b", 1);
	$init_signal_spy("/DUT/c_ex", "c", 1);
	$init_signal_spy("/DUT/imm", "imm", 1);
	$init_signal_spy("/DUT/d_mem", "d_mem", 1);
	$init_signal_spy("/DUT/ctrl_ex", "ctrl_ex", 1);
	$init_signal_spy("/DUT/ctrl_mem", "ctrl_mem", 1);
	$init_signal_spy("/DUT/ctrl_wb", "ctrl_wb", 1);

	$init_signal_spy("/DUT/MULT/Load", "Load", 1);
	$init_signal_spy("/DUT/MULT/StSync", "StSync", 1);
	$init_signal_spy("/DUT/MULT/c1/state", "mul_state", 1);
	$init_signal_spy("/DUT/MULT/c3/counter", "counter", 1);

	clk = 0;
	rst = 1;
	data_bus_read = 0;
	#T_CLK
	rst = 0;

	# (T_CLK_SYS * 10)
	$stop();
end

always # (T_CLK/2) clk = ~clk;

endmodule

