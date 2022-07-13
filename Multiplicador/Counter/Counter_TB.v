`timescale 1ns/100ps
module Counter_TB();
	reg Load, Clk;
	wire K;
	
	reg [3:0]counter;
	
	Counter DUT (
		.Load(Load),
		.Clk(Clk),
		.K(K)
	);
					 
					 
	initial begin	
		$init_signal_spy("/DUT/counter", "counter", 1);
	
		Clk = 0;

		#10
		Load = 1;
		#40
		Load = 0;
		#180
		Load = 1;
		#220
		Load = 0;
			  
		#500
		$stop;
			
	end		
	always begin
		#10 Clk = ~Clk;
	end


endmodule 