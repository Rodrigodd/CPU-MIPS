`timescale 1ns/100ps

module Multiplicador_tb();

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: found %x, expected %x", signal, value); \
            $stop; \
        end

parameter CLK = 20;

wire [31:0] Produto;

reg [15:0] Multiplicando, Multiplicador, MultiplicandoReg;
reg Sy, Clk, Reset;

reg [1:0] state;
reg [4:0] counter;
reg Load, K;

Multiplicador DUT (
	.Produto(Produto),
	.Multiplicando(Multiplicando),
	.Multiplicador(Multiplicador),
	.MultiplicandoReg(MultiplicandoReg),
	.Sy(Sy),
	.Clk(Clk),
	.Reset(Reset)
);

initial begin
	$init_signal_spy("/DUT/c1/state", "state", 1);
	$init_signal_spy("/DUT/c3/counter", "counter", 1);
	$init_signal_spy("/DUT/Load", "Load", 1);
	$init_signal_spy("/DUT/K", "K", 1);
	
	Clk = 0;
	Multiplicando = 0;
	MultiplicandoReg = 0;
	Multiplicador = 0;
	Reset = 1;
	Sy = 0;
	
	
	# CLK // Reseta

	Reset = 0;

	`assert(Produto, 0)

	#CLK;

	Sy = 1; // Start Sincronization
	
	# 10; // clock 1

	#(30*CLK); // clk 31
	
	Multiplicando = 12;
	MultiplicandoReg = 12;
	Multiplicador = 75;

	# CLK; // clock 0, load Multiplicador to Produto.

	# 10
	
	`assert(Produto, { Multiplicando, Multiplicador })

	# 10; // clock 1
	
	# (30*CLK) // clock 31, last clock, results done

	// load next operants
	Multiplicando = 16;
	Multiplicador = 5;

	# CLK // clock 0
	`assert(Produto, 12*75) // last result is done

	// save to Multiplicando to Register
	MultiplicandoReg = Multiplicando;


	# 10;
	
	`assert(Produto, { Multiplicando, Multiplicador })

	# 10; // clock 1

	# (30*CLK); // clock 31

	// load next operants
	Multiplicando = 16'hFFFF;
	Multiplicador = 16'hFFFF;

	# CLK; // clock 0

	`assert(Produto, 16*5) // last result is done

	// save to Multiplicando to Register
	MultiplicandoReg = Multiplicando;

	# 10;
	
	`assert(Produto, { Multiplicando, Multiplicador })

	# (CLK-10); // clock 1

	# (30*CLK); // clock 31

	// load next operants
	Multiplicando = 16'hfa1;
	Multiplicador = 16'h7d1;

	# CLK; // clock 0

	`assert(Produto, 32'hFFFF * 32'hFFFF) // last result is done

	// save to Multiplicando to Register
	MultiplicandoReg = Multiplicando;

	# 10;
	
	`assert(Produto, { Multiplicando, Multiplicador })
	// Multiplicador should only read from MultiplicandoReg, and changing
	// Multiplicando should not impact the computation.
	Multiplicando = 16'h0; 

	# (CLK-10); // clock 1

	# (30*CLK); // clock 31

	# CLK;

	`assert(Produto, 32'hfa1 * 32'h7d1) // last result is done

	$stop();
	
end

always begin
	# (CLK/2) Clk = ~Clk;
end

endmodule
