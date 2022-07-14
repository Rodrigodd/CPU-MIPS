`timescale 1ns/100ps
module Counter_TB();

wire K;
reg Load, Clk, Reset;

reg [3:0]counter;

Counter DUT (
	.K(K),
	.Load(Load),
	.Clk(Clk),
	.Reset(Reset)
);
				 
				 
initial begin	
	$init_signal_spy("/DUT/counter", "counter", 1);

	Clk = 0;
	Reset = 1;

	#20
	Reset = 0;

	#10
	Load = 1;
	#40
	Load = 0;
	#(20*40)
	Load = 1;
	#40
	Load = 0;
		  
	#(20*33)
	$stop;
		
end		
always begin
	#10 Clk = ~Clk;
end


endmodule 
