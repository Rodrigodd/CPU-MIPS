`timescale 1ns/100ps

module Multiplicador_tb();

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: found %x, expected %x", signal, value); \
            $stop; \
        end

parameter CLK = 20;

wire [31:0] Produto;

reg [15:0] Multiplicando, Multiplicador;
reg Sy, Clk, Reset;

reg [1:0] state;
reg [4:0] counter;
reg Load, K;

Multiplicador DUT (
	.Produto(Produto),
	.Multiplicando(Multiplicando),
	.Multiplicador(Multiplicador),
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
	Multiplicador = 0;
	Reset = 1;
	Sy = 0;
	
	
	# CLK // Reseta

	Reset = 0;

	// `assert(Produto, 0);

	#CLK;

	Sy = 1; // Start Sincronization
	
	# 10; // clock 1

	#(30*CLK); // clk 31
	
	Multiplicando = 12;
	Multiplicador = 75;

	# CLK; // clock 0, load Multiplicador to Produto.

	# 10
	
	`assert(Produto, { Multiplicando, Multiplicador })

	# 10; // clock 1
	
	# (30*CLK) // clock 31, last clock, results done

	# 5

	`assert(Produto, Multiplicador * Multiplicando)

	# 5;

	// load next operants
	Multiplicando = 16;
	Multiplicador = 5;
	
	# 10 // clock 0

	# 10;
	
	`assert(Produto, { Multiplicando, Multiplicador })

	# 10; // clock 1

	# (30*CLK); // clock 31

	#5

	`assert(Produto, Multiplicador * Multiplicando)

	# 5;

	// load next operants
	Multiplicando = 16'hFFFF;
	Multiplicador = 16'hFFFF;
	
	# (CLK-10) // clock 0

	# 10;
	
	`assert(Produto, { Multiplicando, Multiplicador })

	# (CLK-10); // clock 1

	# (30*CLK); // clock 31

	#5

	`assert(Produto, Multiplicador * Multiplicando)

	# 5;

	# (CLK-10);
	$stop();
	
end

always begin
	# (CLK/2) Clk = ~Clk;
end

endmodule
