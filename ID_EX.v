// ID_EX

module ID_EX ( clk,  
               rst,
               // input 
			   ID_Flush,
			   // WB
			   ID_MemtoReg,
			   ID_RegWrite,
			   // M 
			   ID_MemWrite,
			   // write your code in here
			   ID_lh,
			   ID_sh,
			   ID_ALU_PC,
			   // EX
			   //ID_Reg_imm,
			   // write your code in here
			   ID_ALUSrc,
			   ID_Branch,
			   ID_Jump,
			   ID_Jr_Jalr,

			   // pipe
			   ID_PC,
			   ID_ALUOp,
			   ID_shamt,
			   ID_Rs_data,
			   ID_Rt_data,
			   ID_se_imm,
			   ID_WR_out,
			   ID_Rs,
			   ID_Rt,
			   // ============ output ===========================
			   // WB
			   EX_MemtoReg,
			   EX_RegWrite,
			   // M
			   EX_MemWrite,
			   // write your code in here
			   EX_lh,
			   EX_sh,
			   EX_ALU_PC,
			   // EX
			   //EX_Reg_imm,
			   // write your code in here
			   EX_ALUSrc,
			   EX_Branch,
			   EX_Jump,
			   EX_Jr_Jalr,


			   // pipe
			   EX_PC,
			   EX_ALUOp,
			   EX_shamt,
			   EX_Rs_data,
			   EX_Rt_data,
			   EX_se_imm,
			   EX_WR_out,
			   EX_Rs,
			   EX_Rt		   			   
			   );
	
	parameter pc_size = 18;			   
	parameter data_size = 32;
	
	input clk, rst;
	input ID_Flush;
	
	// WB ==================== Input ================================
	input ID_MemtoReg;
	input ID_RegWrite;
	// M
	input ID_MemWrite;
	// write your code in here

	input ID_lh;
	input ID_sh;
	input ID_ALU_PC;

	// EX
	//input ID_Reg_imm;				// ALUSrc ???
	// write your code in here
	input ID_ALUSrc;
	input ID_Branch;
	input ID_Jump;
	input ID_Jr_Jalr;

	// pipe
    input [pc_size-1:0] ID_PC;
    input [3:0] ID_ALUOp;
    input [4:0] ID_shamt;
    input [data_size-1:0] ID_Rs_data;
    input [data_size-1:0] ID_Rt_data;
    input [data_size-1:0] ID_se_imm;
    input [4:0] ID_WR_out;
    input [4:0] ID_Rs;
    input [4:0] ID_Rt;
	
	// WB ======================== output ============================
	output EX_MemtoReg;
	output EX_RegWrite;
	// M
	output EX_MemWrite;
	// write your M code in here

   	output EX_lh;
	output EX_sh;
	output EX_ALU_PC;

	// EX
	//output EX_Reg_imm;
	// write your Ex code in here
	output EX_ALUSrc;
	output EX_Branch;
	output EX_Jump;
	output EX_Jr_Jalr;

	// pipe
	output [pc_size-1:0] EX_PC;
	output [3:0] EX_ALUOp;
	output [4:0] EX_shamt;
	output [data_size-1:0] EX_Rs_data;
	output [data_size-1:0] EX_Rt_data;
	output [data_size-1:0] EX_se_imm;
	output [4:0] EX_WR_out;
	output [4:0] EX_Rs;
	output [4:0] EX_Rt;

	// WB ========================= reg ===========================
	reg EX_MemtoReg;
	reg EX_RegWrite;

	// M
	reg EX_MemWrite;
	// write your M code in here
	reg EX_lh;
	reg EX_sh;
	reg EX_ALU_PC;

	// EX
	//reg EX_Reg_imm;
	// write your EX code in here
	reg EX_ALUSrc;
	reg EX_Branch;
	reg EX_Jump;
	reg EX_Jr_Jalr;


	// pipe
	reg	[pc_size-1:0] EX_PC;
	reg [3:0] EX_ALUOp;
	reg [4:0] EX_shamt;
	reg [data_size-1:0] EX_Rs_data;
	reg [data_size-1:0] EX_Rt_data;
	reg [data_size-1:0] EX_se_imm;
	reg [4:0] EX_WR_out;
	reg [4:0] EX_Rs;
	reg [4:0] EX_Rt;

	
	// write your code in here


	always @(negedge clk) begin

		if ( ID_Flush == 1 || rst == 1) begin
			//			  WB
			EX_MemtoReg   <=    0;
			EX_RegWrite   <=    0;
			//            M
			EX_MemWrite   <=    0;
			//            write your code in here
			EX_sh		  <=    0;
			EX_lh		  <=    0;
			EX_ALU_PC	  <=    0;

			//            EX
			//EX_Reg_imm    <=    0;
			//            write your code in here
			EX_ALUSrc	  <=    0;
			EX_Branch	  <= 	0;
			EX_Jump		  <= 	0;
			EX_Jr_Jalr    <=	0;

			//            pipe
			EX_PC         <=    0;
			EX_ALUOp      <=    0;
			EX_shamt      <=    0;
			EX_Rs_data    <=    0;
			EX_Rt_data    <=    0;
			EX_se_imm     <=    0;
			EX_WR_out     <=    0;
			EX_Rs         <=    0;
			EX_Rt         <=    0;
		end 
		else begin 
			//			  WB
			EX_MemtoReg   <=    ID_MemtoReg;
			EX_RegWrite   <=    ID_RegWrite;
			//            M
			EX_MemWrite   <=    ID_MemWrite;
			//            write your code in here
			EX_sh		  <=    ID_sh;
			EX_lh		  <=    ID_lh;
			EX_ALU_PC	  <=    ID_ALU_PC;

			//            EX
			//EX_Reg_imm    <=    ID_Reg_imm;
			//            write your code in here
			EX_ALUSrc	  <=    ID_ALUSrc;
			EX_Branch	  <= 	ID_Branch;
			EX_Jump		  <= 	ID_Jump;
			EX_Jr_Jalr	  <=	ID_Jr_Jalr;

			//            pipe
			EX_PC         <=    ID_PC;
			EX_ALUOp      <=    ID_ALUOp;
			EX_shamt      <=    ID_shamt;
			EX_Rs_data    <=    ID_Rs_data;
			EX_Rt_data    <=    ID_Rt_data;
			EX_se_imm     <=    ID_se_imm;
			EX_WR_out     <=    ID_WR_out;
			EX_Rs         <=    ID_Rs;
			EX_Rt         <=    ID_Rt;
		end 
	end
	
endmodule










