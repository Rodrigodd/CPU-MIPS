`timescale 1ns/100ps

module Multiplicador_tb();

`define assert(signal, value) \
        if (signal !== value) begin \
            $display("ASSERTION FAILED in %m: found %x, expected %x", signal, value); \
            $stop; \
        end


wire [31:0] Produto;

reg [15:0] Multiplicando, Multiplicador;
reg Clk, Reset;

reg state;
reg [4:0] counter;
reg Load, K;

Multiplicador DUT (
	.Produto(Produto),
	.Multiplicando(Multiplicando),
	.Multiplicador(Multiplicador),
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
	
	
	# 20

	Reset = 0;
	
	Multiplicando = 12;
	Multiplicador = 75;

	# 10 // clock 0, load Multiplicador to Produto.

	# 10
	
	`assert(Produto, { Multiplicando, Multiplicador })

	# 10; // clock 1
	
	# (30*20) // clock 31, last clock, results done

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

	# (30*20); // clock 31

	#5

	`assert(Produto, Multiplicador * Multiplicando)

	# 5;

	// load next operants
	Multiplicando = 16'hFFFF;
	Multiplicador = 16'hFFFF;
	
	# 10 // clock 0

	# 10;
	
	`assert(Produto, { Multiplicando, Multiplicador })

	# 10; // clock 1

	# (30*20); // clock 31

	#5

	`assert(Produto, Multiplicador * Multiplicando)

	# 5;

	# 10;
	$stop();
	
end

always begin
	#10 Clk = ~Clk;
end

endmodule
