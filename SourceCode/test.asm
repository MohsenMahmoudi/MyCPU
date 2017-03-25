define A 76
define B 92
define C 112
define D 21
Ld_Sram a A
Ld_Sram c B
add a c
LDOutput
Ld_Input b
Ld_Input c
sub b c
LDOutput
Ld_Sram a C
Ld_Sram c D
add a c
LDOutput
jmp dir 0