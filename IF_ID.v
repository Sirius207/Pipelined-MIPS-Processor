// IF_ID

module IF_ID ( clk,
               rst,
			   // input
			   IF_IDWrite,
			   IF_Flush,
			   IF_PC,
			   IF_ir,
			   // output
			   ID_PC,
			   ID_ir);
	
	parameter pc_size = 18;
	parameter data_size = 32;
	
	input clk, rst;
	input IF_IDWrite, IF_Flush;
	input [pc_size-1:0]   IF_PC; // [17: 0]
	input [data_size-1:0] IF_ir; // [31: 0]
	
	output reg [pc_size-1:0]   ID_PC; // [17: 0]
	output reg [data_size-1:0] ID_ir; // [31: 0]

	// write your code in here

	always @(negedge clk) begin
		if(IF_Flush || rst ) begin
			ID_PC <= 0;
			ID_ir <= 0;
		end
		else if(IF_IDWrite == 1)begin
			ID_PC <= ID_PC;
			ID_ir <= ID_ir;
		end
		else begin
			ID_PC <= IF_PC;
			ID_ir <= IF_ir;
		end
	end

endmodule