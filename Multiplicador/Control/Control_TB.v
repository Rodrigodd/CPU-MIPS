`timescale 1ns/100ps
module Control_TB();

reg St, Clk, K, M, Reset;
wire Idle, Done, Load, Sh, Ad;

reg [1:0]state;
parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

MulControl DUT (
	.Idle(Idle),
	.Done(Done),
	.Load(Load),
	.Sh(Sh),
	.Ad(Ad),
	.St(St),
	.Clk(Clk),
	.K(K),
	.M(M),
	.Reset(Reset)
);

initial begin
$init_signal_spy("/DUT/state", "state", 1);
	Clk = 0;
	#10 
	St = 0;
	Reset = 1;
	M = 0;
	K = 0;
	#10
	Reset = 0;
	St = 1;
	#80
	M = 1;
	#40
	K = 1;
	#100
	Reset=1;
	
	
	#40
	$stop;
end

always begin
	#10 Clk = ~Clk;
end


endmodule