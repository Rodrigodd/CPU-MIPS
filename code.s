.data
A: 2001 ; 07d1
B: 4001 ; 0fa1
C: 5001 ; 1389
D: 3001 ; 0bb9
; (0x07d1* 0x0fa1) - (0x1389 - 0x0bb9)
; 0x7A2971 - 0x1F42
; 0x7A0A2F

.text

lw r0, A(r31) ; 1. Carrega A em R0
lw r1, B(r31) ; 2. Carrega B em R1
lw r2, C(r31) ; 3. Carrega C em R2
lw r3, D(r31) ; 4. Carrega D em R3
mul r4, r0, r1 ; 5. R4 recebe A*b
add r5, r3, r4 ; 6. R5 recebe C+D
sub r6, r4, r5 ; 7. R6 recebe [R4] – [R5]
sw r6, 0x0dff(r31) ; 8. MemDados [última posição] recebe [R6]

lw r0, A(r31) ; 1. Carrega A em R0
lw r1, B(r31) ; 2. Carrega B em R1
lw r2, C(r31) ; 3. Carrega C em R2
lw r3, D(r31) ; 4. Carrega D em R3
or r1, r1, r1 ; nop
sw r1, 0xf0f1(r31) ; debug
mul r4, r0, r1 ; 5. R4 recebe A*b
or r1, r1, r1 ; nop
or r1, r1, r1 ; nop
or r1, r1, r1 ; nop
or r1, r1, r1 ; nop
sw r4, 0xf0f4(r31) ; debug
add r5, r2, r3 ; 6. R5 recebe C+D
or r1, r1, r1 ; nop
or r1, r1, r1 ; nop
or r1, r1, r1 ; nop
or r1, r1, r1 ; nop
sw r5, 0xf0f5(r31) ; debug
sub r6, r4, r5 ; 7. R6 recebe [R4] – [R5]
or r1, r1, r1 ; nop
or r1, r1, r1 ; nop
or r1, r1, r1 ; nop
or r1, r1, r1 ; nop
sw r6, 0x0dff(r31) ; 8. MemDados [última posição] recebe [R6]

; Resposta: 7997999 = 0x7A0A2F


