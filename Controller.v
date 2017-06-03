 // Controller

module Controller ( 
    opcode, funct,
    RegDst, MemtoReg, RegWrite,
    MemRead, MemWrite,
    ALUSrc, ALUControl,Branch,
    jump, lhalf,shalf, Jr_Jalr, ALU_PC
);

	input  [5:0] opcode;
    input  [5:0] funct;
	// write your code in here
	output reg	RegDst;
 	output reg	ALUSrc;
	output reg	MemtoReg;
	output reg	RegWrite;
    output reg	MemRead;
    output reg	MemWrite;
	output reg  Branch;
	output reg  [3:0]  ALUControl;
    output reg  jump;
    output reg  lhalf;
    output reg  shalf;
    output reg  Jr_Jalr;
    output reg  ALU_PC;

	
	// R & I & J-type opcode
	localparam Rformat	= 6'b000000;
	localparam addi     = 6'b001000;
	localparam andi     = 6'b001100;
	localparam slti     = 6'b001010;
	localparam beq      = 6'b000100;
	localparam bne      = 6'b000101;
	localparam lw       = 6'b100011;
    localparam lh       = 6'b100001;
    localparam sw       = 6'b101011;
	localparam sh       = 6'b101001;
    localparam j        = 6'b000010;
    localparam JAL      = 6'b000011;

	//R-type funct
    localparam add      = 6'b100000;
    localparam sub      = 6'b100010;
    localparam AND      = 6'b100100;
    localparam OR       = 6'b100101;
    localparam XOR      = 6'b100110;
	localparam NOR      = 6'b100111;
    localparam slt      = 6'b101010;
    localparam sll      = 6'b000000;
	localparam srl      = 6'b000010;
	localparam jr      	= 6'b001000;
	localparam jalr     = 6'b001001;



	always @(*) begin
        jump    = 1'b0;
        lhalf   = 1'b0;
        shalf   = 1'b0;
        Jr_Jalr = 1'b0;
        ALU_PC  = 1'b0; 
        ALUControl  = 0; 

		case (opcode)
			Rformat: begin
    			RegDst      = 1'b1;
                ALUSrc      = 1'b0;
                MemtoReg    = 1'b0;
                RegWrite    = 1'b1;
                MemRead     = 1'b0;
                MemWrite    = 1'b0;
				Branch		= 1'b0;
                case (funct)
					add: begin
						ALUControl  = 4'b0010;
					end
					sub: begin
						ALUControl  = 4'b0110;
					end
					AND: begin
						ALUControl  = 4'b0000;
					end
					OR: begin
						ALUControl  = 4'b0001;
					end
					XOR: begin
						ALUControl  = 4'b1101; //custom
					end
					NOR: begin
						ALUControl  = 4'b1100; //custom
					end
					slt: begin
						ALUControl  = 4'b0111;
					end
					sll: begin
						ALUControl  = 4'b1001;  //custom 
					end
					srl: begin
						ALUControl  = 4'b1110;  //custom
					end
					jr: begin
                        jump        = 1'b1;
						Jr_Jalr     = 1'b1;
					end
					jalr: begin
                        jump        = 1'b1;
						Jr_Jalr     = 1'b1;
                        ALU_PC      = 1'b1; 
					end
                    default :begin
                        ALUControl  = 0; 
                    end
                endcase
            end
            lw: begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b1;
                MemtoReg    = 1'b1;
                RegWrite    = 1'b1;
                MemRead     = 1'b1;
                MemWrite    = 1'b0;
				Branch		= 1'b0;
                ALUControl  = 4'b0010;
            end
			lh: begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b1;
                MemtoReg    = 1'b1;
                RegWrite    = 1'b1;
                MemRead     = 1'b1;
                MemWrite    = 1'b0;
				Branch		= 1'b0;
                ALUControl  = 4'b0010;
                lhalf       = 1'b1;
            end
            sw: begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b1;
                MemtoReg    = 1'b0;
                RegWrite    = 1'b0;
                MemRead     = 1'b0;
                MemWrite    = 1'b1;
				Branch		= 1'b0;
                ALUControl  = 4'b0010;
            end
			sh: begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b1;
                MemtoReg    = 1'b0;
                RegWrite    = 1'b0;
                MemRead     = 1'b0;
                MemWrite    = 1'b1;
				Branch		= 1'b0;
                ALUControl  = 4'b0010;
                shalf       = 1'b1;
            end
			beq: begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b0;
                MemtoReg    = 1'b0;
                RegWrite    = 1'b0;
                MemRead     = 1'b0;
                MemWrite    = 1'b0;
				Branch		= 1'b1;
                ALUControl  = 4'b0110;
            end
			bne: begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b0;
                MemtoReg    = 1'b0;
                RegWrite    = 1'b0;
                MemRead     = 1'b0;
                MemWrite    = 1'b0;
				Branch		= 1'b1;
                ALUControl  = 4'b0110;
            end
            j  : begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b0;
                MemtoReg    = 1'b0;
                RegWrite    = 1'b0;
                MemRead     = 1'b0;
                MemWrite    = 1'b0;
				Branch		= 1'b0; 
                jump        = 1'b1;
                Jr_Jalr      = 1'b0;
            end
            JAL  : begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b0;
                MemtoReg    = 1'b0;
                RegWrite    = 1'b1; //?
                MemRead     = 1'b0;
                MemWrite    = 1'b0;
				Branch		= 1'b0; 
                jump        = 1'b1;
                Jr_Jalr     = 1'b0;
                ALU_PC      = 1'b1; 
            end
            default: begin
                RegDst      = 1'b0;
                ALUSrc      = 1'b1;
                MemtoReg    = 1'b0;
                RegWrite    = 1'b1;
                MemRead     = 1'b0;
                MemWrite    = 1'b0;
                case (opcode)
                    addi:   ALUControl = 4'b0010;
                    andi:   ALUControl = 4'b0000;
                    slti:   ALUControl = 4'b0111;
                endcase
            end
	  endcase

	end

endmodule




