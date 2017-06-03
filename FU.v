// Forwarding Unit

module FU ( // input 
			EX_Rs,
            EX_Rt,
			M_RegWrite,
			M_WR_out,
			WB_RegWrite,
			WB_WR_out,
			// output
			// write your code in here
			Forward_A_0,
			Forward_A_1,
			Forward_B_0,
			Forward_B_1
			);

	input [4:0] EX_Rs;
    input [4:0] EX_Rt;
    input M_RegWrite;
    input [4:0] M_WR_out;
    input WB_RegWrite;
    input [4:0] WB_WR_out;

	// write your code in here
	output Forward_A_0, Forward_A_1, Forward_B_0, Forward_B_1;
	reg Forward_A_0, Forward_A_1, Forward_B_0, Forward_B_1;
	

	always @(*) begin
		// Forward A
		if ( M_RegWrite == 1  && ( M_WR_out != 0 )  && ( M_WR_out == EX_Rs)  ) begin
			Forward_A_0 = 1; // ori 10 EX/MEM
			Forward_A_1 = 1;
		end 
		else if ( WB_RegWrite == 1 && ( WB_WR_out != 0 ) && ( WB_WR_out == EX_Rs) ) begin
			Forward_A_0 = 0; // ori 01 MEM/WB
			Forward_A_1 = 1;
		end 
		else begin
			Forward_A_0 = 0; // X
			Forward_A_1 = 0;
		end 
		// Forward B
		if ( M_RegWrite == 1  && ( M_WR_out != 0 )  && ( M_WR_out == EX_Rt)  ) begin
			Forward_B_0 = 1; // ori 10 EX/MEM
			Forward_B_1 = 1;
		end
		else if ( WB_RegWrite == 1 && ( WB_WR_out != 0 ) && ( WB_WR_out == EX_Rt) ) begin
			Forward_B_0 = 0; // ori 01 MEM/WB
			Forward_B_1 = 1;
		end
		else begin
			Forward_B_0 = 0; // X
			Forward_B_1 = 0;
		end
	end
endmodule




























