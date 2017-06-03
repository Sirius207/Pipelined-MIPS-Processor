// Jump_Ctrl

module Jump_Ctrl( Zero,
                  JumpOP,
				  // write your code in here
				  Branch,
				  Jump,
				  Jr_Jalr,
				  );

    input Zero, Branch, Jump, Jr_Jalr;
	output [1:0] JumpOP;
	// write your code in here
	reg [1:0] JumpOP;

	always @(*) begin
	  if(Jr_Jalr == 1'b1) 
	  	JumpOP = 2'b10;
	  else if(Jump == 1'b1)
	  	JumpOP = 2'b11;
	  else if(Zero == 1'b1 && Branch == 1'b1)
	  	JumpOP = 2'b01;
	  else 
	  	JumpOP = 2'b00;
	end
endmodule





