// top
`include "ALU.v"
`include "Controller.v"
`include "DM.v"
`include "EX_M.v"
`include "FU.v"
`include "HDU.v"
`include "ID_EX.v"
`include "IF_ID.v"
`include "IM.v"
`include "Jump_Ctrl.v"
`include "M_WB.v"
`include "Mux_2to1_5bit.v"
`include "Mux_2to1_32bit.v"
`include "Mux_4to1_18bit.v"
`include "PC.v"
`include "Regfile.v"
`include "SignExten.v"
`include "SignExten_18.v"



module top ( clk,
             rst,
			 // Instruction Memory
			 IM_Address,
             Instruction,
			 // Data Memory
			 DM_Address,
			 DM_enable,
			 DM_Write_Data,
			 DM_Read_Data);

	parameter data_size = 32;
	parameter mem_size = 16;	

	input  clk, rst;
	
	// Instruction Memory
	output [mem_size-1:0] IM_Address;	
	input  [data_size-1:0] Instruction;

	// Data Memory
	output [mem_size-1:0] DM_Address;
	output DM_enable;
	output [data_size-1:0] DM_Write_Data;	
    input  [data_size-1:0] DM_Read_Data;
	
	// write your code here

	// IF ==========================================
	
	// PC
	wire [17:0] PCin;
	wire [17:0] PCout;

	wire [17:0] PC_Add_4;

	// IF ID 
	wire [17:0] ID_PC;
	wire [data_size-1:0] ID_ir;


	// ID ==========================================


	// Controller

	wire ID_RegDst;
	wire ID_MemtoReg;
	wire ID_RegWrite;
	wire ID_MemRead;
	wire ID_MemWrite;
	// custom
	wire ID_ALUSrc;
	wire [3:0] ID_ALUOp;
	wire ID_Branch;
	wire ID_Jump;
	wire ID_lh;
	wire ID_sh;
	wire ID_Jr_Jalr;
	wire ID_ALU_PC;


	// RegFile

	wire [31:0] Read_data_1;
	wire [31:0] Read_data_2;

	// SignExtan
	wire [4:0] Rt_or_Rd;


	// Hazard
	wire PC_Write;
	wire IF_IDWrite;
	wire IF_Flush;
	wire ID_Flush;

	// ID EX 
	wire [4:0] ID_WR_out;
	wire [31:0] ID_se_imm;

	// WB
	wire EX_MemtoReg;
	wire EX_RegWrite;
	// M
	wire EX_MemWrite;
	// write your code in here
	wire EX_lh;
	wire EX_sh;
	wire EX_ALU_PC;
	// EX
	// wire EX_Reg_imm;
	// write your code in here
	wire EX_ALUSrc;
	wire EX_Branch;
	wire EX_Jump;
	wire EX_Jr_Jalr;
	// pipe
	wire [17:0] EX_PC;
	wire [3:0] EX_ALUOp;
	wire [4:0] EX_shamt;
	wire [31:0] EX_Rs_data;
	wire [31:0] EX_Rt_data;
	wire [31:0] EX_se_imm;
	wire [4:0] EX_WR_out;
	wire [4:0] EX_Rs;
	wire [4:0] EX_Rt;		   	

	// EX ==========================================


	// Jump Ctrl
	wire [1:0] EX_JumpOP;
	wire [31:0] imm_shift;
	wire [17:0] jump_PC;

	// For
	wire Forward_A_0;
	wire Forward_A_1;
	wire Forward_B_0;
	wire Forward_B_1;

	wire [31:0] A0_out;
	wire [31:0] B0_out;
	wire [31:0] B1_out;

	// ALU

	//input
	wire [31:0] src1;
	wire [31:0] src2;
	//output
	wire Zero;


	// EX MEM

	wire [17:0] EX_PCplus8;
	wire [31:0] EX_ALU_result;
	wire [31:0] ALU_PC_out;

	// WB
	wire M_MemtoReg;
	wire M_RegWrite;
	// M
	wire M_MemWrite;
	// write your code in here
	wire M_lh;
	wire M_sh;
	wire M_ALU_PC;

	// pipe
	wire [31:0] M_ALU_result;
	wire [31:0] M_Rt_data;
	wire [17:0] M_PCplus8;
	wire [4:0] M_WR_out;			


	// MEM =========================================

	//DM
	wire [31:0] Rt_SignExten;
	wire [31:0] RD_SignExten;

	//mux
	wire [31:0] M_PCplus8_32;


	// MEM WB

	wire [31:0] M_DM_Read_Data;
	wire [31:0] M_WD_out;

	wire [31:0] WB_WD; 			// after mux

	wire WB_MemtoReg;
	wire WB_RegWrite;
	// pipe
	wire [31:0] WB_DM_Read_Data;
	wire [31:0] WB_WD_out;
    wire [4:0] WB_WR_out;

	// WB ==========================================


	// /===================================================================================\
	// Main 
	// =====================================================================================

	// ==============================
	// IF - PC
	// ==============================


	PC PC1(.clk(clk), .rst(rst), .PCWrite(PC_Write), .PCin(PCin), .PCout(PCout));  

	assign PC_Add_4 = PCout + 4;

	// ==============================
	// IF - IM
	// ==============================

	// output
	assign IM_Address = PCout[17:2];

	// ========================================================
	// IF ID 
	// ========================================================
	

	IF_ID IF_ID1 ( 
		.clk(clk), 
		.rst(rst),
		// input
		.IF_IDWrite(IF_IDWrite),// define in Hazard
		.IF_Flush(IF_Flush),  	// define in Hazard
		.IF_PC(PC_Add_4),
		.IF_ir(Instruction),
		// output
		.ID_PC(ID_PC),			// define in IFID
		.ID_ir(ID_ir)  			// define in IFID
	);

	// ===============================
	// ID - Controller
	// ===============================

	Controller Controller1 ( 
			// input
    		.opcode(ID_ir[31:26]), 
			.funct(ID_ir[5:0]),
    		// output
			.RegDst(ID_RegDst), 
    		.MemtoReg(ID_MemtoReg), 
			.RegWrite(ID_RegWrite),
    		.MemRead(ID_MemRead), 
			.MemWrite(ID_MemWrite),
			// custom output 
			.ALUSrc(ID_ALUSrc),
			.ALUControl(ID_ALUOp),
			.Branch(ID_Branch),
    		.jump(ID_Jump), 
			.lhalf(ID_lh), 
			.shalf(ID_sh), 
			.Jr_Jalr(ID_Jr_Jalr),
			.ALU_PC(ID_ALU_PC)			// check???
	);

	// ===============================
	// ID - RegFile
	// ===============================

	Regfile Regfile1 ( 
		.clk(clk), 
		.rst(rst),
		.Read_addr_1(ID_ir[25:21]),		// rs
		.Read_addr_2(ID_ir[20:16]),		// rt
		// output
		.Read_data_1(Read_data_1),		// define in RegFile
        .Read_data_2(Read_data_2),		// define in RegFile
		// intput
		.RegWrite(WB_RegWrite),			// define in MEM WB
		.Write_addr(WB_WR_out),			// define in MEM WB
		.Write_data(WB_WD)				// define in WB
	);

	// ===============================
	// ID - Sign-Exten & Mux
	// ===============================

	SignExten SignExten1(
		.input16bit(ID_ir[15:0]), 
		.output32bit(ID_se_imm)			//define in ID EX
	);

	Mux_2to1_5bit Mux_2to1_5bit_1(
		.mux_out(Rt_or_Rd), 
		.mux_in_A(ID_ir[20:16]), 		// 0 rt
		.mux_in_B(ID_ir[15:11]), 		// 1 rd
		.mux_check(ID_RegDst)			// define in controller
	);

	Mux_2to1_5bit Mux_2to1_5bit_2(
		.mux_out(ID_WR_out), 
		.mux_in_A(Rt_or_Rd), 
		.mux_in_B(5'b11111), 			// check???
		.mux_check(ID_Jump)				// define in ID EX 
	);

	// ===============================
	// ID - Hazard Detection
	// ===============================

	HDU HDU1 ( 
			 // input
			 .ID_Rs(ID_ir[25:21]),
             .ID_Rt(ID_ir[20:16]),
			 .EX_WR_out(EX_WR_out),				// define in ID EX
			 .EX_MemtoReg(EX_MemtoReg),			// define in ID EX
			 .EX_JumpOP(EX_JumpOP),				// define in Jump Ctrl
			 // output
			 .PC_write(PC_Write),
			 .IFID_write(IF_IDWrite),
			 .IF_Flush(IF_Flush),
			 .ID_Flush(ID_Flush)			
	);


	// ========================================================
	// ID EX
	// ========================================================

	ID_EX ID_EX1 ( 
			   .clk(clk),  
        	   .rst(rst),
               // input 
			   .ID_Flush(ID_Flush),					
			   // WB
			   .ID_MemtoReg(ID_MemtoReg),				// define in controller
			   .ID_RegWrite(ID_RegWrite),				// define in controller
			   // MEM 
			   .ID_MemWrite(ID_MemWrite),				// define in controller
			   // write your code in here
			   .ID_lh(ID_lh),
			   .ID_sh(ID_sh),
			   .ID_ALU_PC(ID_ALU_PC),					// ALU PC in Controller ???
			   // EX
			   //.ID_Reg_imm(ID_Reg_imm),	// check???				// ID_Reg_imm ???						
			   // write your code in here
			   .ID_ALUSrc(ID_ALUSrc),
			   .ID_Branch(ID_Branch),
			   .ID_Jump(ID_Jump),
			   .ID_Jr_Jalr(ID_Jr_Jalr),

			   // pipe
			   .ID_PC(ID_PC),							// define in IFID
			   .ID_ALUOp(ID_ALUOp),
			   .ID_shamt(ID_ir[10:6]),
			   .ID_Rs_data(Read_data_1),
			   .ID_Rt_data(Read_data_2),
			   .ID_se_imm(ID_se_imm),
			   .ID_WR_out(ID_WR_out),
			   .ID_Rs(ID_ir[25:21]),
			   .ID_Rt(ID_ir[20:16]),
			   // ============ output ===========================
			   // WB
			   .EX_MemtoReg(EX_MemtoReg),
			   .EX_RegWrite(EX_RegWrite),
			   // M
			   .EX_MemWrite(EX_MemWrite),
			   // write your code in here
			   .EX_lh(EX_lh),
			   .EX_sh(EX_sh),
			   .EX_ALU_PC(EX_ALU_PC),
			   // EX
			   //.EX_Reg_imm(EX_Reg_imm),
			   // write your code in here
			   .EX_ALUSrc(EX_ALUSrc),
			   .EX_Branch(EX_Branch),
			   .EX_Jump(EX_Jump),
			   .EX_Jr_Jalr(EX_Jr_Jalr),

			   // pipe
			   .EX_PC(EX_PC),
			   .EX_ALUOp(EX_ALUOp),
			   .EX_shamt(EX_shamt),
			   .EX_Rs_data(EX_Rs_data),
			   .EX_Rt_data(EX_Rt_data),
			   .EX_se_imm(EX_se_imm),
			   .EX_WR_out(EX_WR_out),
			   .EX_Rs(EX_Rs),
			   .EX_Rt(EX_Rt)		   			   
	);

	
	// ===============================
	// EX - Forwarding Unit
	// ===============================

	FU FU1 ( 
		// input 
		.EX_Rs(EX_Rs),						// define in ID EX
        .EX_Rt(EX_Rt),						// define in ID EX
		.M_RegWrite(M_RegWrite),			// define in EX MEM
		.M_WR_out(M_WR_out),				// define in EX MEM
		.WB_RegWrite(WB_RegWrite),			// define in MEM WB
		.WB_WR_out(WB_WR_out),				// define in MEM WB
		// output
		// write your code in here
		.Forward_A_0(Forward_A_0),			// define in FU
		.Forward_A_1(Forward_A_1),			// define in FU
		.Forward_B_0(Forward_B_0),			// define in FU
		.Forward_B_1(Forward_B_1)			// define in FU
	);


	// ===============================
	// EX - ALU
	// ===============================

	Mux_2to1_32bit Mux_2to1_32bit_A0(
		.mux_out(A0_out), 
		.mux_in_A(WB_WD), 			// 0: define in MEM WB
		.mux_in_B(M_WD_out), 		// 32bit???  1: define in MEM
		.mux_check(Forward_A_0)
	);

	Mux_2to1_32bit Mux_2to1_32bit_A1(
		.mux_out(src1), 				// define in ALU
		.mux_in_A(EX_Rs_data), 			// 0
		.mux_in_B(A0_out), 				// 1
		.mux_check(Forward_A_1)
	);

	Mux_2to1_32bit Mux_2to1_32bit_B0(
		.mux_out(B0_out), 
		.mux_in_A(WB_WD), 				// 0: define in MEM WB
		.mux_in_B(M_WD_out), 			// 1: define in MEM
		.mux_check(Forward_B_0)
	);

	Mux_2to1_32bit Mux_2to1_32bit_B1(
		.mux_out(B1_out), 						
		.mux_in_A(EX_Rt_data), 			// 0
		.mux_in_B(B0_out), 				// 1
		.mux_check(Forward_B_1)
	);

	Mux_2to1_32bit Mux_2to1_32bit_Src(
		.mux_out(src2), 					// define in ALU
		.mux_in_A(B1_out), 				// 0:
		.mux_in_B(EX_se_imm), 					// 1: define in ID EX
		.mux_check(EX_ALUSrc)				// define in ID EX
	);

	ALU ALU1 ( 
		.ALUOp(EX_ALUOp),					// define in ID EX
		.src1(src1),						// define in ALU
		.src2(src2),						// define in ALU
		.shamt(EX_shamt),					// define in ID EX
		.ALU_result(EX_ALU_result),			// define in EX MEM
		.Zero(Zero)							// define in ALU
	);


	// ===============================
	// EX - Jump Ctrl
	// ===============================


	Jump_Ctrl Jump1( 
		.Zero(Zero),					// define in ALU
        .JumpOP(EX_JumpOP),				// define in Hazard
		// write your code in here
		.Branch(EX_Branch),				// define in ID EX
		.Jump(EX_Jump),					// define in ID EX
		.Jr_Jalr(EX_Jr_Jalr)					// define in ID EX
	);

	// ===============================
	// EX - Mux 4 to 1 
	// ===============================

	assign imm_shift = (EX_se_imm<<2);			// 32bit ???
	assign jump_PC = EX_PC + imm_shift[17:0];	// EX_PC define in ID EX

	Mux_4to1_18bit Mux_4to1_18bit_1(
		.mux_out(PCin),					// define in PC 
		.mux_in_A(PC_Add_4), 			// define in PC
		.mux_in_B(jump_PC),		// define in EX-MUX
		.mux_in_C(src1[17:0]),			// define in ALU
		.mux_in_D(imm_shift[17:0]),   	// define in EX-MUX
		.mux_check(EX_JumpOP)			// define in Hazard
	);

	// ========================================================
	// EX MEM
	// ========================================================

	assign EX_PCplus8 = EX_PC + 4;

	EX_M EX_MEM_1 ( 
			  .clk(clk),
			  .rst(rst),
			  // input 
			  // WB
			  .EX_MemtoReg(EX_MemtoReg),
			  .EX_RegWrite(EX_RegWrite),
			  // M
			  .EX_MemWrite(EX_MemWrite),
			  // write your code in here

			  .EX_lh(EX_lh),
			  .EX_sh(EX_sh),
			  .EX_ALU_PC(EX_ALU_PC),				// define in ID EX controller

			  // pipe
			  .EX_ALU_result(EX_ALU_result),		// define in EX MEM
			  .EX_Rt_data(B1_out),					// define in Mux
			  .EX_PCplus8(EX_PCplus8),				
			  .EX_WR_out(EX_WR_out),				// define in ID EX
			  // output
			  // WB
			  .M_MemtoReg(M_MemtoReg),
			  .M_RegWrite(M_RegWrite),
			  // M
			  .M_MemWrite(M_MemWrite),
			  // write your code in here

			  .M_lh(M_lh),
			  .M_sh(M_sh),
			  .M_ALU_PC(M_ALU_PC),

			  // pipe
			  .M_ALU_result(M_ALU_result),
			  .M_Rt_data(M_Rt_data),
			  .M_PCplus8(M_PCplus8),
			  .M_WR_out(M_WR_out)			  		  			  
	);

	// ===============================
	// EX - DM
	// ===============================
	
	//output
	assign DM_Address = M_ALU_result[17:2];
	assign DM_enable = M_MemWrite;

	// sign exten M_Rt_data
	SignExten SignExten_sh(
		.input16bit(M_Rt_data[15:0]), 
		.output32bit(Rt_SignExten)
	);

	// check sh & assign DM_Write_Data
	Mux_2to1_32bit Mux_2to1_32bit_sh(
		.mux_out(DM_Write_Data), 
		.mux_in_A(M_Rt_data), 
		.mux_in_B(Rt_SignExten), 
		.mux_check(M_sh)
	);

	//signexten DM_Read_Data
	SignExten SignExten_lh(
		.input16bit(DM_Read_Data[15:0]), 
		.output32bit(RD_SignExten)
	);

	// check lh & assign M_DM_Read_Data
	Mux_2to1_32bit Mux_2to1_32bit_lh(
		.mux_out(M_DM_Read_Data), 
		.mux_in_A(DM_Read_Data), 
		.mux_in_B(RD_SignExten), 
		.mux_check(M_lh)
	);

	// Exten Pc plus 8 to 32bit for ALU_PC Mux
	SignExten_18 SignExten_18_1(
		.input18bit(M_PCplus8), 
		.output32bit(M_PCplus8_32)
	);

	// Mux M_WD_out
	Mux_2to1_32bit Mux_2to1_32bit_WD(
		.mux_out(M_WD_out), 
		.mux_in_A(M_ALU_result), 				// 0				
		.mux_in_B(M_PCplus8_32), 				// 1
		.mux_check(M_ALU_PC)
	);


	// ========================================================
	// MEM WB
	// ========================================================



	M_WB M_WB1 ( 
			  .clk(clk),
              .rst(rst),
			  // input 
			  // WB
			  .M_MemtoReg(M_MemtoReg),			// define in EX MEM
			  .M_RegWrite(M_RegWrite),			// define in EX MEM
			  // pipe
			  .M_DM_Read_Data(M_DM_Read_Data),	// define in M WB
			  .M_WD_out(M_WD_out),				// define in M WB
			  .M_WR_out(M_WR_out),				// define in Ex MEM
			  // output
			  // WB
			  .WB_MemtoReg(WB_MemtoReg),
			  .WB_RegWrite(WB_RegWrite),
			  // pipe
			  .WB_DM_Read_Data(WB_DM_Read_Data),
			  .WB_WD_out(WB_WD_out),
              .WB_WR_out(WB_WR_out)
	);


	// ===============================
	// M
	// ===============================

	
	Mux_2to1_32bit Mux_2to1_32bit_WB(
		.mux_out(WB_WD), 						
		.mux_in_A(WB_WD_out), 				// 0
		.mux_in_B(WB_DM_Read_Data), 		// 1
		.mux_check(WB_MemtoReg)
	);



endmodule





















