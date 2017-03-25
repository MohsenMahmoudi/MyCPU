module Controller(regA_Enable,regB_Enable,regC_Enable,regD_Enable,
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
							regIROutput,clk,rst,sign_Flag , zero_Flag , overflow_Flag , carry_Flag);	
						
					
						
						
						
`include "parameters.vh"
						
input [WORD_SIZE-1:0] regIROutput;
input clk,rst,sign_Flag , zero_Flag , overflow_Flag , carry_Flag;

reg [4:0] state = 5'h0;

reg [WORD_SIZE-1:0] tempIR;
						
output reg   regA_Enable,regB_Enable,regC_Enable,regD_Enable,
				 regA_Load,regB_Load,regC_Load,regD_Load,
				 regA_Sclr,regB_Sclr,regC_Sclr,regD_Sclr,
				 regA_Sset,regB_Sset,regC_Sset,regD_Sset,
				 regAR_Enable,regAR_Load,regAR_Sclr,regAR_Sset,regAR_useBusForInput,
				 regIR_Enable,regIR_Load,regIR_Sclr,regIR_Sset,
				 outputData_Enable,outputData_Load,outputData_Sclr,outputData_Sset,
				 alu_enable,alu_bus0_sel,alu_bus1_sel,shift_ALU_Out,
				 RAM_Wren;

output reg [7:0] regAR_Input;
				 
output reg [2:0] bus_sel,alu_op;
output reg [WORD_SIZE-1:0] RAM_Input;



reg [7:0] regPC;




always @(posedge clk)begin
			if(rst == 1'b1)
				state = 5'd0;
			
			if (state ==  5'd0) begin //initial
			
					regA_Enable=1'b1;
					regB_Enable=1'b1;
					regC_Enable=1'b1;
					regD_Enable=1'b1;
					
					outputData_Enable=1'b1;
					
					
					regAR_Enable=1'b1;
					regIR_Enable=1'b1;
					
					regAR_Sclr=1'b1;
					regIR_Sclr=1'b1;
					
					regD_Sclr=1'b1;
					regC_Sclr=1'b1;
					regB_Sclr=1'b1;
					regA_Sclr=1'b1;
					
					outputData_Sclr=1'b1;

					regPC = 8'b0;

					state=state+5'd1;					
			end
	
			else if (state ==  5'd1) begin
			
					regAR_Sclr=1'b0;
					regIR_Sclr=1'b0;
					
					regD_Sclr=1'b0;
					regC_Sclr=1'b0;
					regB_Sclr=1'b0;
					regA_Sclr=1'b0;
					
					regA_Load=1'b0;
					regB_Load=1'b0;
					regC_Load=1'b0;
					regD_Load=1'b0;
					regAR_Load=1'b0;
					regIR_Load=1'b0;
					outputData_Load=1'b0;
					
					outputData_Sclr=1'b0;
					
					alu_enable=1'b0;
					
					state=state+5'd1;
			end
					
			else if (state == 5'd2) begin 
			
					regAR_useBusForInput=1'b0;
					regAR_Load=1'b1;
					regAR_Input=regPC;
					state=state+5'd1;
			end
			
			else if (state == 5'd3) begin 
			
					bus_sel = `Bus_RAM_Output;
					regAR_Load=1'b0;
					regIR_Load=1'b1;
					state=state+5'd1;
			end
			
			else if (state == 5'd4) begin 
					

					state=state+5'd1;
			end
			
			else if (state == 5'd5) begin 
					
					regIR_Load=1'b0;
					state=state+5'd1;
			end
			
			else if (state == 5'd6) begin
					case (regIROutput[7:6])
							2'b00: // Load
									begin
										if(regIROutput[5]==0)begin
											if(regIROutput[4]==0)begin
												case(regIROutput[3:2])
													2'b00:begin
															regA_Load=1'b1;
															regB_Load=1'b0;
															regC_Load=1'b0;
															regD_Load=1'b0;
														end
													2'b01:begin
															regA_Load=1'b0;
															regB_Load=1'b1;
															regC_Load=1'b0;
															regD_Load=1'b0;
														end
													2'b10:begin
															regA_Load=1'b0;
															regB_Load=1'b0;
															regC_Load=1'b1;
															regD_Load=1'b0;
														end
													2'b11:begin
															regA_Load=1'b0;
															regB_Load=1'b0;
															regC_Load=1'b0;
															regD_Load=1'b1;
														end
												endcase
												bus_sel=`Bus_inputData;

												state=5'd14; //	Go to final state
											end	
											else begin
												tempIR=regIROutput;
												regPC=regPC+7'd1;
												
												state=5'd7; //		Go to Load General Register with Sram state
											end
										end
										else begin
											bus_sel = `Bus_alu_out;
											outputData_Load=1'b1;
											state=5'h1C; //	Go to final state
										end
									end
							2'b01: // ALU
									begin
										alu_op=regIROutput[5:3];
										alu_enable=1'b1;
										alu_bus0_sel=regIROutput[2];
										alu_bus1_sel=regIROutput[1];
										shift_ALU_Out=regIROutput[0];
										state=5'h1C; //	Go to final state
									end
							2'b10: // JMP
									begin
										tempIR=regIROutput;
										regPC=regPC+7'h1;
										state=5'd7;
									end
							2'b11: // Function call
									state=5'h1C;
					endcase
					
			end

			else if (state == 5'd7) begin //Load General Register with Sram
			
					regAR_useBusForInput=1'b0;
					regAR_Load=1'b1;
					regAR_Input=regPC;
					
					state=state+5'd1;
			end
			
			else if (state == 5'd8) begin 
					
					bus_sel = `Bus_RAM_Output;
					regAR_Load=1'b0;
					regIR_Load=1'b1;
					state=state+5'd1;
			end
			
			
			else if (state == 5'd9) begin 
			
					state=state+5'd1;
					
			end
			
			else if (state == 5'd10) begin 
			
					regAR_useBusForInput=1'b1;
					bus_sel = `Bus_regIR;
					regAR_Load=1'b1;
					regIR_Load=1'b0;
					state=state+5'd1;
			end
			
			else if (state == 5'd11) begin 
			
					regAR_Load=1'b0;
					regIR_Load=1'b1;
					state=state+5'd1;
			end
			
			else if (state == 5'd12) begin 
					if(tempIR[7:6]==2'b00)
						state=5'd13;
					else if(tempIR[7:6]==2'b10)
						state=5'd15;
			end
			
			else if (state == 5'd13) begin
			
					regIR_Load=1'b0;
					bus_sel = `Bus_RAM_Output;
					case(tempIR[3:2])
						2'b00:begin
								regA_Load=1'b1;
								regB_Load=1'b0;
								regC_Load=1'b0;
								regD_Load=1'b0;
							end
						2'b01:begin
								regA_Load=1'b0;
								regB_Load=1'b1;
								regC_Load=1'b0;
								regD_Load=1'b0;
							end
						2'b10:begin
								regA_Load=1'b0;
								regB_Load=1'b0;
								regC_Load=1'b1;
								regD_Load=1'b0;
							end
						2'b11:begin
								regA_Load=1'b0;
								regB_Load=1'b0;
								regC_Load=1'b0;
								regD_Load=1'b1;
							end
					endcase
					state = state + 5'd1;
			end
			
			else if (state == 5'd14) begin
			
					regA_Load=1'b0;
					regB_Load=1'b0;
					regC_Load=1'b0;
					regD_Load=1'b0;
					state=5'h1C; //	Go to final state
			end
			
			
			else if (state == 5'd15) begin
			
			regIR_Load=1'b0;
				if(tempIR[5]==1'b1 & zero_Flag==1'b1)begin//JZ
						if(tempIR[4]==1'b1)begin	//Direct jump.   regPC=Address
							regPC=(regIROutput-1);
						end
						else begin						//indirect jump. regPC+Address
							regPC=regPC+(regIROutput-1);
						end
				end
				else begin					//JMP
						if(tempIR[4]==1'b1)begin	//Direct jump.   regPC=Address
							regPC=regIROutput-1;
						end
						else begin						//indirect jump. regPC+Address
							regPC=regPC+(regIROutput-1);
						end
				end
				state=5'h1C; //	Go to final state
			end
			
			else if (state == 5'h1C)begin
					
					regPC=regPC+7'h1;
					state=5'd1;
			end
end

endmodule