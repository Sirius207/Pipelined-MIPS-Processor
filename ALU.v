// ALU

module ALU ( ALUOp,
			 src1,
			 src2,
			 shamt,
			 ALU_result,
			 Zero);
	
	parameter bit_size = 32;
	
	input [3:0] ALUOp;
	input [bit_size-1:0] src1;
	input [bit_size-1:0] src2;
	input [4:0] shamt;
	
	output [bit_size-1:0] ALU_result;
	output Zero;
	reg [bit_size-1:0] ALU_result;
	reg Zero;
			
	// write your code in here
	
	always @(*) begin
	
	case (ALUOp)
		4'b0010: ALU_result	 	= 		src1 + src2;  //add
		4'b0110: ALU_result 	= 		src1 - src2;  //sub
		4'b0000: ALU_result 	= 		src1 & src2;  //and
		4'b0001: ALU_result 	= 		src1 | src2;  //or
		4'b1101: ALU_result 	= 		src1 ^ src2;  //xor
		4'b1100: ALU_result 	= 		~(src1 | src2);  //nor
		4'b0111: ALU_result 	=   	src1 < src2 ? 1 : 0; //slt
		4'b1001: ALU_result 	=   	src2 << shamt; //sll
		4'b1110: ALU_result 	=   	src2 >> shamt; //srl
		default: ALU_result 	=   	0; 
	endcase

	Zero =  ALU_result == 32'b0 ? 1'b1 : 1'b0;

end

endmodule





