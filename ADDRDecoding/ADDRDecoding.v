module ADDRDecoding(
	input [31:0] addr,
	output cs // 0 = memoria interna, 1 = memoria externa
);

// Memoria interna de 1kB (400h B), começando em 2 * 500h = A00h
// => 0A00h..0A00h+03FF
// => 0A00h..0DFF
// =>
//    |11..8 | CS
// ... 
//  9 | 1001 | 1
//  A | 1010 | 0
//  B | 1011 | 0
//  C | 1100 | 0
//  D | 1101 | 0
//  E | 1110 | 1
// ...
// => 
//      \9,8
// 11,10 \ 00 01 11 10
//    00 |  1  1  1  1
//    01 |  1  1  1  1
//    11 |  0  0  1  1
//    10 |  1  1  0  0
// =>
//    CS = ~((b[31..12]==0).(b11.b10.~b9 | b11.~b10.b9))
// => CS = ~((b[31..12]==0).b11.(b10.~b9 | ~b10.b9))
// => CS = ~((b[31..12]==0).b11.(b10 xor b9))
assign cs = ~((addr[31:12] == 0) && addr[11] && (addr[10] ^ addr[9]));

endmodule

