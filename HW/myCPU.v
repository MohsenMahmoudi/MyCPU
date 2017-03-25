module myCPU(clk,rst,inputData,outputData,bus_output);

`include "parameters.vh"

///////////////////GENERAL\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
reg [WORD_SIZE-1:0] regBuff;

input wire clk,rst;

input wire [WORD_SIZE-1:0] inputData;


///////////////////START_outputData Reg\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wire outputData_Enable,outputData_Load,outputData_Sclr,outputData_Sset;

output wire [WORD_SIZE-1:0] outputData;

Register regOutputData(clk,bus_output,outputData_Enable,outputData_Load,outputData_Sclr,outputData_Sset,outputData);
///////////////////END_outputData Reg\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\





///////////////////START_AR Reg\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wire regAR_Enable,regAR_Load,regAR_Sclr,regAR_Sset,regAR_useBusForInput;

reg [7:0] regAR;
wire [7:0] regAR_Input;


always @(posedge clk) begin
	regAR = regAR_Enable?(regAR_Sclr?7'h0:(regAR_Sset?7'h1:regAR_Load?(regAR_useBusForInput?bus_output:regAR_Input):regAR)):regAR;
end
///////////////////END_AR Reg\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



///////////////////START_REGISTERS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

wire [WORD_SIZE-1:0] regA_Output,regB_Output,regC_Output,regD_Output;

wire  regA_Enable,regB_Enable,regC_Enable,regD_Enable,
		regA_Load,regB_Load,regC_Load,regD_Load,
		regA_Sclr,regB_Sclr,regC_Sclr,regD_Sclr,
		regA_Sset,regB_Sset,regC_Sset,regD_Sset;

Register regA (clk,bus_output,regA_Enable,regA_Load,regA_Sclr,regA_Sset,regA_Output);
Register regB (clk,bus_output,regB_Enable,regB_Load,regB_Sclr,regB_Sset,regB_Output);
Register regC (clk,bus_output,regC_Enable,regC_Load,regC_Sclr,regC_Sset,regC_Output);
Register regD (clk,bus_output,regD_Enable,regD_Load,regD_Sclr,regD_Sset,regD_Output);


///////////////////END_REGISTERS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




///////////////////START_IR Reg\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wire regIR_Enable,regIR_Load,regIR_Sclr,regIR_Sset;
wire [WORD_SIZE-1:0] regIR_Output;


Register regIR(clk,bus_output,regIR_Enable,regIR_Load,regIR_Sclr,regIR_Sset,regIR_Output);
///////////////////END_IR Reg\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\





///////////////////START_ALU\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wire [WORD_SIZE-1:0] alu_in1,alu_in2,alu_out;

wire alu_enable,alu_bus0_sel,alu_bus1_sel,shift_ALU_Out ,sign_Flag , zero_Flag , overflow_Flag , carry_Flag ;
wire [2:0] alu_op;

assign  alu_in1 = (alu_bus0_sel==0)?regA_Output:regB_Output;		
assign  alu_in2 = (alu_bus1_sel==0)?regC_Output:regD_Output;

alu _alu (clk, alu_op, alu_in1, alu_in2, alu_enable, alu_out,sign_Flag , zero_Flag , overflow_Flag , carry_Flag);

always @(posedge clk) begin
	regBuff = (shift_ALU_Out == 1) ? alu_out << 1 : alu_out;
end

///////////////////END_ALU\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



///////////////////START_RAM\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
wire [WORD_SIZE-1:0] RAM_Input;
wire [WORD_SIZE-1:0] RAM_Output;
wire RAM_Wren;

Ram mainRAM (regAR,clk,RAM_Input,RAM_Wren,RAM_Output);
///////////////////END_RAM\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



///////////////////START_MAINBUS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

output wire [WORD_SIZE-1:0] bus_output;
wire [2:0] bus_sel;

Bus_mux Bus (
				regIR_Output,
				regAR,
				regBuff,
				alu_out,
				inputData,
				RAM_Output,
				'h0,
				'h0,
				bus_sel,
				bus_output);
	
///////////////////END_MAINBUS\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\	


Controller Contorller(regA_Enable,regB_Enable,regC_Enable,regD_Enable,
							regA_Load,regB_Load,regC_Load,regD_Load,
							regA_Sclr,regB_Sclr,regC_Sclr,regD_Sclr,
							regA_Sset,regB_Sset,regC_Sset,regD_Sset,
							regAR_Enable,regAR_Load,regAR_Sclr,regAR_Sset,regAR_useBusForInput,regAR_Input,
							regIR_Enable,regIR_Load,regIR_Sclr,regIR_Sset,
							outputData_Enable,outputData_Load,outputData_Sclr,outputData_Sset,
							alu_enable,alu_bus0_sel,alu_bus1_sel,shift_ALU_Out,alu_op,
							RAM_Wren,
							bus_sel,
							RAM_Input,
							regIR_Output,clk,rst,sign_Flag , zero_Flag , overflow_Flag , carry_Flag);

	
endmodule