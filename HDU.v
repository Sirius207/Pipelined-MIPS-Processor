// Hazard Detection Unit

module HDU ( // input
			 ID_Rs,
             ID_Rt,
			 EX_WR_out,
			 EX_MemtoReg,
			 EX_JumpOP,
			 // output
			 // write your code in here
			 PC_write,
			 IFID_write,
			 IF_Flush,
			 ID_Flush,
			 );
	
	parameter bit_size = 32;
	
	input [4:0] ID_Rs;
	input [4:0] ID_Rt;
	input [4:0] EX_WR_out;
	input EX_MemtoReg;
	input [1:0] EX_JumpOP;
	output PC_write, IFID_write,  IF_Flush, ID_Flush;
	reg PC_write, IFID_write,  IF_Flush, ID_Flush;
	
	// write your code in here

	always @(*) begin

		IF_Flush = 0;
		ID_Flush = 0;

		if( EX_MemtoReg && ( EX_WR_out == ID_Rs || EX_WR_out == ID_Rt ) ) begin
			PC_write   	= 1;		// stall
			IFID_write 	= 1;
		end 
		else if ( EX_JumpOP != 0 ) begin
			
			IF_Flush 	= 1;
			ID_Flush 	= 1;
			PC_write   	= 0;		//check ???	
			IFID_write 	= 0;
		
		end
		else begin 
			PC_write   	= 0;
			IFID_write 	= 0;
		end
	end
endmodule