`timescale 1ns/1ps
module MUX_TB();

reg [31:0] a, b;
reg sel;
wire [31:0] q; 

MUX DUT(
	.a(a),
	.b(b),
	.sel(sel),
	.q(q)
);

initial begin
	sel <= 0;
	a <= 32'd1;
	b <= 32'd2;
		 
		 
	#20 sel <= 1;
		 
	#20 a <= 32'd3; b <= 32'd4; sel <= 0;
		 
	#20 sel <= 1;
	
	#20 a <= 32'd5; b <= 32'd6; sel <= 0;
		 
	#20 sel <= 1;
	
	#20 a <= 32'd7; b <= 32'd8; sel <= 0;
		 
	#20 sel <= 1;
	
	#20 a <= 32'd9; b <= 32'd10; sel <= 0;
		 
	#20 sel <= 1;

	#200
$stop();
end

endmodule

