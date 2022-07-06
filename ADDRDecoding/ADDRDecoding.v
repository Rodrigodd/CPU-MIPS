module ADDRDecoding(
	input [31:0] addr,
	output cs // 0 = memoria interna, 1 = memoria externa
);

// Memoria interna de 1kB (400h B), começando em 2 * 500h = A00h
// => 0A00h:0A00h+03FF
// => 0A00h:0DFF
// =>
//    | 11:8 | CS | intern_addr 9:8
// ...                   
//  9 | 1001 | 1  |  xxx
//  A | 1010 | 0  |   00
//  B | 1011 | 0  |   01
//  C | 1100 | 0  |   10
//  D | 1101 | 0  |   11
//  E | 1110 | 1  |  xxx
// ...
// => 
//      \9,8
// 11,10 \ 00 01 11 10
//    00 |  1  1  1  1
//    01 |  1  1  1  1
//    11 |  0  0  1  1
//    10 |  1  1  0  0
// =>
//    CS = ~((b[31:12]==0).(b11.b10.~b9 | b11.~b10.b9))
// => CS = ~((b[31:12]==0).b11.(b10.~b9 | ~b10.b9))
// => CS = ~((b[31:12]==0).b11.(b10 xor b9))
//
// intern_addr = { ~b9, b[8:0] } <- coloquei direto na porta do DataMemory

assign cs = ~((addr[31:12] == 0) && addr[11] && (addr[10] ^ addr[9]));

endmodule

