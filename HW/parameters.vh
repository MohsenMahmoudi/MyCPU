parameter WORD_SIZE = 8;

`define ALU_ADD 3'h0
`define ALU_SUB 3'h1
`define ALU_IN1 3'h2
`define ALU_IN2 3'h3
`define ALU_AND 3'h4
`define ALU_OR 3'h5
`define ALU_XOR 3'h6
`define ALU_SHIFT 3'h7

`define Bus_regIR 3'b000
`define Bus_regAR 3'b001
`define Bus_regBuff 3'b010
`define Bus_alu_out 3'b011
`define Bus_inputData 3'b100
`define Bus_RAM_Output 3'b101


`define OP_LOAD 4'h8
`define OP_STORE 4'h9
`define OP_IN 4'hA
`define OP_OUT 4'hB
`define OP_JMP 4'hC
`define OP_BR 4'hD
`define OP_LOADLO 4'hE
`define OP_LOADHI 4'hF
