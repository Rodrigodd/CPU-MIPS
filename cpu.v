/*
a) Qual a latência do sistema?

	O sistema tem uma latência de 5 clocks:
	- ler a instrução da Memória para o registro INSTR,
	- decodificar
	- fazer a operação
	- ler/escrever na memória de dados
	- escrever no RegisterFile

b) Qual o throughput do sistema?

	Quando todos os estágios do sistema estão processando instruções, o sistema
	tem um throughput de 1 instrução por ciclo.

c) Qual a máxima frequência operacional entregue pelo Time Quest Timing
Analizer para o multiplicador e para o sistema? (Indique a FPGA utilizada)

	FPGA: Cyclone IV GX EP4CGX150DF31C7,
		         | Slow 85C   | Slow 0C    | Fast 0C
	Sistema      | 109.66 MHz | 118.67 MHz | 201.01 MHz
	Multiplicador| 294.20 MHz | 320.82 MHz | 604.96 MHz

d) Qual a máxima frequência de operação do sistema? (Indique a FPGA utilizada)

	Mesmo que o sistema como um todo opere com uma frequência máxima menor que
	o Multiplicador isolado (segundo o Time Quest), podemos alimentar
	o sistema com a frequência máxima do Multiplicador, pois o restante do
	sistema só irá operar com o clk divido por 33 pela PLL. Logo a frequência
	máxima de operação do sistema será:

	FPGA: Cyclone IV GX EP4CGX150DF31C7,
		         | Slow 85C   | Slow 0C    | Fast 0C
	Sistema      | 8.9152 MHz | 9.7218 MHz | 18.332 MHz

e) Com a arquitetura implementada, a expressão (A*B) – (C+D) é executada
corretamente (se executada em sequência ininterrupta)? Por quê? O que pode ser
feito para que a expressão seja calculada corretamente?

	Não, pois como as instruções leem do RegisterFile no segundo estágio, mas
	somente escrevem de volta no quinto, uma instrução acaba lendo do registro
	antes que o resultado da instrução anterior seja escrita.
	Para resolver isso, deve-se garantir que cada instrução sempre esteja
	localizada 4 posições após às instruções a quais dependa do resultado.
	Isso por meio do rearranjo do código, ou pela inserção de instruções
	extras (bubbles).

                        ▼ escreve no RegisterFile (read-first)
     0. 1 | 2 | 3 | 4 | 5
     1.     1 | 2 | 3 | 4 | 5
     2.         1 | 2 | 3 | 4 | 5
     3.             1 | 2 | 3 | 4 | 5
     4.                 1 | 2 | 3 | 4 | 5
            		        ▲ le do RegisterFile (read-first)

f) Analisando a sua implementação de dois domínios de clock diferentes, haverá
problemas com metaestabilidade? Porquê?

	Não, pois a leitura e escrita na interface entre os dois domínios de clock
	só ocorre nos instantes em que ambas as bordas de subida dos clocks do
	sistema e do multiplicador coincidem, e isso é garantido pelo uso da PLL.

g) A aplicação de um multiplicador do tipo utilizado, no sistema MIPS sugerido,
é eficiente em termos de velocidade? Porquê?

	Não. Como o sistema não tira vantagem da operação em ciclos do Multiplicador,
	limitando o período de clock do sistema ao período total de operação do
	Multiplicador, um Multiplicador implementado em um circuito funcional teria
	menor latência (embora uma área muito maior), portanto seria mais eficiente,
	olhando apenas em termos de velocidade.

h) Cite modificações cabíveis na arquitetura do sistema que tornaria o sistema
mais rápido (frequência de operação maior). Para cada modificação sugerida,
qual a nova latência e throughput do sistema?

	O principal bottleneck do sistema é o multiplicador. O fato que o sistema
	espera o Multiplicador completar uma operação completa a cada ciclo de
	operação do sistema, mesmo que o sistema não esteja multiplicando no momento,
	faz com que a frequência do sistema caia de 108MHz para apenas 8.9 MHz (para o
	modelo Slow 0C).
	
	Logo, uma modificação seria fazer com que o sistema apenas esperasse pelo
	multiplicador caso seja necessário fazer uma operação. Isso seria possível
	a introduzir um sinal de Enable a todos os registros do sistema, que
	permitiria interromper o sistema assim que o Multiplicador começasse uma
	operação, permitindo que o sistema e o multiplicador usassem o mesmo
	clock.
	Assim, quando não houvesse uma instrução de multiplicação, a latência
	e o throughput, em números de clock, seria o mesmo, porém com uma
	frequência cerca de 12 vezes maior (108MHz / 8.9MHz). Quando fosse
	executada operações de multiplicação, a latência seria praticamente de 37
	ciclos, com um throughput de 1 instrução a cada 33 ciclos.
	Portanto, no pior caso o sistema se tornaria quase 3 vezes mais lento (33
	/ 12), mas seria 12 vezes mais rápido no melhor caso. Isso valeria a pena
	dependendo de quantas instruções de multiplicação se espera executar.

	Outra possível modificação seria mover o multiplicador para o seu próprio
	pipeline. As modificações necessárias no sistema seria apenas introduzir
	um segundo sinal de writeback vindo do multiplicador. Isso permitira
	executar mais instruções em paralelo, porém instroduziria mais
	preocupações de pipeline hazzard, como ao tentar executar duas instruções
	de multiplicação ao mesmo tempo, ou quando o multiplicador e o estágio
	WriteBack tentam escrever no mesmo registro ao mesmo tempo.
	No pior caso o throughput seria de 1 instrução a cada 33 ciclos, com uma
	latência de 35 ciclos. No melhor caso seria um throughput médio de 1.03
	instruções por ciclo, e uma latência média de 1.03 ciclos por instrução.
	
	Mas também é importante notar que nas duas modificações anteriores, ainda
	é possível fazer com que o Multiplicador opere com 2 ou 3 vezes a
	frequência do sistema, sem perda de velocidade do sistema. Isso porque
	o sistema opera com uma frequência máxima de 108 a 201 MHz, enquanto
	o multiplicador opera de 294 a 605 MHz (vide questão 'c)').
	Assim, o thoroghput do Multiplicador seria de 1 instrução a cada 16.5
	ciclos.

*/
module cpu #(
	parameter CODE = "code.txt",
	parameter DATA = "data.txt"
) (
	input CLK, RST,
	input [31:0] Data_BUS_READ,
	output [31:0] ADDR, 
	output CS, WR_RD,
	output [31:0] Data_BUS_WRITE
);

(*keep=1*) wire clk_sys, clk_mul, pll_locked, rst_sys;
assign clk_mul = CLK;
assign rst_sys = RST || !pll_locked; // O sistema permanece resetado enquanto o PLL não estiver "locked".

PLL PLL_(
	RST,
	CLK,
	clk_sys,
	pll_locked
);

// A primeira borda de subida de clk_sys ocorre no mesmo instante que o sinal
// pll_locked é ativo, mas essa borda de subida ocorre fora de fase, de modo
// que o primeiro periodo de clock do sistema seja menor que os demais. Logo
// o sinal de sync_mul precisa ser atrasado em 1 cyclo.

wire sync_mul1, sync_mul;

Register #(1) SYNC_MUL1(
	clk_sys, rst_sys,
	pll_locked, sync_mul1
);
Register #(1) SYNC_MUL(
	clk_sys, rst_sys,
	sync_mul1, sync_mul
);

/// Instruction Fetch

(*keep=1*) wire [31:0] instr;
(*keep=1*) wire [31:0] pc_address;

PC PC_(
	clk_sys, rst_sys,
	pc_address
);

InstructionMemory #(CODE) IM(
	clk_sys, rst_sys,
	pc_address[9:0],
	instr
);

/// Instruction Decode

wire write_back_en;
wire [4:0] write_back_reg;
(*keep=1*) wire [31:0] write_back;

(*keep=1*) wire [4:0] a_reg, b_reg;
wire [31:0] _a_ex, _b_ex, _imm;
(*keep=1*) wire [31:0] a_ex, b_ex, imm;

// { c_sel[1], d_sel[1], op_sel[2], rd_wr[1], wb_sel[1], write_back_en[1], write_back_reg[5] }
wire[11:0] _ctrl_ex;
(*keep=1*) wire[11:0] ctrl_ex;

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

(*keep=1*) wire [31:0] mul, op, c_ex, d_ex, d_mem, b_mem;

wire c_sel, d_sel;
wire [1:0] op_sel;

wire [7:0] _ctrl_mem;
(*keep=1*) wire [7:0] ctrl_mem;

assign { c_sel, d_sel, op_sel, _ctrl_mem } = ctrl_ex;

(*keep=1*) Multiplicador #(16) MULT(
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

wire [31:0] d_wb, m_wb;
wire rd_wr;

wire [6:0] _ctrl_wb;
(*keep=1*) wire [7:0] ctrl_wb;
assign { rd_wr, _ctrl_wb } = ctrl_mem;

assign WR_RD = !rd_wr;

assign ADDR = d_mem;
assign Data_BUS_WRITE = b_mem;

ADDRDecoding DEC(
	ADDR,
	CS
);

DataMemory #(DATA) MEM(
	// a memória contém um registro para a saída, logo ela é sincronizada com
	// a borda de subida do clock, para que ela não fique atrasada de 1 ciclo.
	clk_sys, rst_sys,
	{ !ADDR[9], ADDR[8:0] }, Data_BUS_WRITE,  WR_RD,
	m_wb
);

Register D_WB(
	clk_sys, rst_sys,
	d_mem, d_wb
);

Register #(7) CTRL_WB(
	clk_sys, rst_sys,
	{ CS, _ctrl_wb }, ctrl_wb
);

/// Write Back

wire wb_sel, cs_wb;
wire [31:0] _m_wb;

assign { cs_wb, wb_sel, write_back_en, write_back_reg } = ctrl_wb;

MUX M_WB_SEL(
	m_wb, Data_BUS_READ,
	cs_wb,
	_m_wb
);

MUX WB_SEL(
	d_wb, _m_wb,
	wb_sel,
	write_back
);

endmodule

