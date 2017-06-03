module Mux_2to1_32bit(mux_out, mux_in_A, mux_in_B, mux_check);

    output  [31:0] mux_out;
    
    input   [31:0] mux_in_A;
    input   [31:0] mux_in_B;
    input   mux_check;
	reg     [31:0] mux_out;
	
    always@(*) begin
        if (mux_check == 0) begin
	        mux_out = mux_in_A;
	    end
	    else begin
            mux_out = mux_in_B;
	    end
	 end

endmodule