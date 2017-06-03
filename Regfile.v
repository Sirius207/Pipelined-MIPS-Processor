// Regfile

module Regfile ( clk, 
				 rst,
				 Read_addr_1,
				 Read_addr_2,
				 Read_data_1,
                 Read_data_2,
				 RegWrite,
				 Write_addr,
				 Write_data);
	
	parameter bit_size = 32;
	
	input  clk, rst;
	input  [4:0] Read_addr_1; //rs
	input  [4:0] Read_addr_2; //rt
	
	output [bit_size-1:0] Read_data_1;
	output [bit_size-1:0] Read_data_2;
	
	input  RegWrite;
	input  [4:0] Write_addr; //rd
	input  [bit_size-1:0] Write_data;
	
    // write your code in here

	reg [31:0]RegMemory[0:31];

	integer i, j;

	assign	Read_data_1 = RegMemory[Read_addr_1];
	assign	Read_data_2 = RegMemory[Read_addr_2];


	always @(posedge clk or negedge rst) begin
		if (rst)  begin
			for (i=0; i<32; i=i+1)
				RegMemory[i] <= 0;
		end

		else if ( RegWrite && Write_addr != 5'd0 ) begin
			RegMemory[Write_addr] <= Write_data;
		end
	end

	
endmodule






