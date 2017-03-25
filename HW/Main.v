module Main();

	reg clock=0;

	wire clk;
	
	assign clk = clock;
	
	always	begin
		#10	clock = ~ clk;
	end

endmodule