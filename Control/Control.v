module Control(
	input [31:0] instr,
	output reg [4:0] a_reg, b_reg,
	// { c_sel[1], d_sel[1], op_sel[2], rd_wr[1], wb_sel[1], write_back_en[1], write_back_reg[5] }
	output [11:0] ctrl_ex
);

reg c_sel; // ALU operator is B or IMM?
reg d_sel; // MUL or ALU?
reg [1:0] op_sel; // +, -, & or |?
reg rd_wr; // 0 = read, 1 = write
reg wb_sel; // write back D or M?
reg write_back_en; // 1 = write to register
reg [4:0] write_back_reg; // target register

assign ctrl_ex = { c_sel, d_sel, op_sel, rd_wr, wb_sel, write_back_en, write_back_reg };

// f0: 31 30 29 28 27 26
// rs: 25 24 23 22 21
// rt: 20 19 18 17 16
// rd: 15 14 13 12 11
// f1: 10 9 8 7 6
// f2: 5 4 3 2 1 0

wire [5:0] func0;
wire [4:0] rs;
wire [4:0] rt;
wire [4:0] rd;
wire [4:0] func1;
wire [5:0] func2;

assign func0 = instr[31:26];
assign rs = instr[25:21];
assign rt = instr[20:16];
assign rd = instr[15:11];
assign func1 = instr[10:6];
assign func2 = instr[5:0];

always @(func0, rs, rt, rd, func1, func2) begin

	// default: noop
	a_reg = 0;
	b_reg = 0;
	c_sel = 1;
	d_sel = 1;
	op_sel = 3;
	rd_wr = 0;
	wb_sel = 0;
	write_back_en = 0;
	write_back_reg = 0;

	case (func0) 
		2: begin
			if (func1 == 10) begin
				// R format
				a_reg = rs;
				b_reg = rt;
				c_sel = 0;
				rd_wr = 0;
				wb_sel = 0;
				write_back_en = 1;
				write_back_reg = rd;
				case (func2)
					32: begin
						// ADD
						d_sel = 1;
						op_sel = 0;
					end
					34: begin
						// SUB
						d_sel = 1;
						op_sel = 1;
					end
					36: begin
						//AND
						d_sel = 1;
						op_sel = 2;
					end
					37: begin
						// OR
						d_sel = 1;
						op_sel = 3;
					end
					50: begin
						// MUL
						d_sel = 0;
						op_sel = 0;
					end
					default: ;
				endcase
			end
		end
		3: begin
			// LW
			a_reg = rs;
			b_reg = 0;
			c_sel = 1;
			op_sel = 0;
			d_sel = 1;
			rd_wr = 0;
			wb_sel = 1;
			write_back_en = 1;
			write_back_reg = rt;
		end
		4: begin
			// SW
			a_reg = rs;
			b_reg = rt;
			c_sel = 1;
			op_sel = 0;
			d_sel = 1;
			rd_wr = 1;
			wb_sel = 1;
			write_back_en = 0;
			write_back_reg = 0;
		end
		default: ;
	endcase
end


endmodule

