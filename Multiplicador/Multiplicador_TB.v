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

reg [2:0] state;
reg [5:0] counter;
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

	`assert(Produto, 0)

	#CLK;

	Sy = 1; // Start Syncronization
	
	# 10; // clock 1

	#(31*CLK); // clk 32
	
	Multiplicando = 12;
	Multiplicador = 75;

	# (2*CLK); // clock 1, load Multiplicador to Produto.

	# CLK // clock 2
	
	`assert(Produto, { Multiplicando, Multiplicador })
	
	# (30*CLK) // clock 32, last clock, results done

	// load next operants
	Multiplicando = 16;
	Multiplicador = 5;

	# CLK // clock 0
	`assert(Produto, 12*75) // last result is done

	# CLK; // clock 1, load Multiplicador to Produto.

	# CLK // clock 2
	
	`assert(Produto, { Multiplicando, Multiplicador })
	
	# (30*CLK) // clock 32, last clock, results done

	// load next operants
	Multiplicando = 16'hFFFF;
	Multiplicador = 16'hFFFF;

	# CLK; // clock 0

	`assert(Produto, 16*5) // last result is done

	# CLK; // clock 1, load Multiplicador to Produto.

	# CLK // clock 2
	
	`assert(Produto, { Multiplicando, Multiplicador })
	
	# (30*CLK) // clock 32, last clock, results done

	// load next operants
	Multiplicando = 16'hfa1;
	Multiplicador = 16'h7d1;

	# CLK; // clock 0

	`assert(Produto, 32'hFFFF * 32'hFFFF) // last result is done

	# CLK; // clock 1, load Multiplicador to Produto.

	# CLK // clock 2
	
	`assert(Produto, { Multiplicando, Multiplicador })
	
	# (30*CLK) // clock 32, last clock, results done

	# CLK;

	`assert(Produto, 32'hfa1 * 32'h7d1) // last result is done

	$stop();
	
end

always begin
	# (CLK/2) Clk = ~Clk;
end

endmodule
