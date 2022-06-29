`timescale 1ns/1ps
module TB();

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

reg [31:0] a, b, c, imm, d_mem;
reg [11:0] ctrl_ex;
reg [7:0] ctrl_mem;
reg [6:0] ctrl_wb;

wire c_sel; // ALU operator is B or IMM?
wire d_sel; // MUL or ALU?
wire [1:0] op_sel; // +, -, & or |?
wire _wr_rd; // 0 = write, 1 = read
wire wb_sel; // write back D or M?
wire write_back_en; // 1 = write to register
wire [4:0] write_back_reg; // target register

assign { c_sel, d_sel, op_sel, _wr_rd, wb_sel, write_back_en, write_back_reg } = ctrl_ex;

initial begin
	$init_signal_spy("/DUT/a_ex", "a", 1);
	$init_signal_spy("/DUT/b_ex", "b", 1);
	$init_signal_spy("/DUT/c_ex", "c", 1);
	$init_signal_spy("/DUT/imm", "imm", 1);
	$init_signal_spy("/DUT/d_mem", "d_mem", 1);
	$init_signal_spy("/DUT/ctrl_ex", "ctrl_ex", 1);
	$init_signal_spy("/DUT/ctrl_mem", "ctrl_mem", 1);
	$init_signal_spy("/DUT/ctrl_wb", "ctrl_wb", 1);

	clk = 0;
	rst = 1;
	data_bus_read = 0;
	#20
	rst = 0;

	#200
	$stop();
end

// f = 50 MHz => Tc = 20 ns
always #10 clk = ~clk;

endmodule

