module alu(clk, op, in1, in2, alu_enable, out , sign_Flag , zero_Flag , overflow_Flag , carry_Flag);

    `include "parameters.vh"

    input wire [2:0] op;
    input wire [WORD_SIZE-1:0] in1, in2;
    input wire clk, alu_enable;
	 	 
    output reg [WORD_SIZE-1:0] out;

	 output reg sign_Flag , zero_Flag , overflow_Flag, carry_Flag;
	 
    always @(posedge clk) begin
        if (alu_enable) begin
            case (op)
                `ALU_ADD:	
                    out <= in1 + in2;
                `ALU_SUB:
                    out <= in1 - in2;
                `ALU_IN1:
                    out <= in1;
                `ALU_IN2:
                    out <= in2;
                `ALU_AND:
                    out <= in1 & in2;
                `ALU_OR:
                    out <= in1 | in2;
                `ALU_XOR:
                    out <= in1 ^ in2;
                `ALU_SHIFT:
                    out <= in1 << in2;
            endcase
				
				zero_Flag <= out == 0 ? 1'b1 : 1'b0;
				sign_Flag <= out  < 0 ? 1'b1 : 1'b0;
				carry_Flag <= out[WORD_SIZE-1];
				
       end
    end

endmodule
