module Register(clk,regInputData,regEnable,regLoad,regSclr,regSset,regOutput);

`include "parameters.vh"


input wire clk,regEnable,regLoad,regSclr,regSset;

input wire [WORD_SIZE-1:0] regInputData;
output reg [WORD_SIZE-1:0] regOutput;

always @(posedge clk) begin
	if(regEnable == 1'b1) begin
		if(regSclr == 1'b1)
			regOutput=0;
		else if(regSset == 1'b1)
			regOutput=-1;
		else if(regLoad == 1'b1)
				regOutput = regInputData;
	end
end

endmodule