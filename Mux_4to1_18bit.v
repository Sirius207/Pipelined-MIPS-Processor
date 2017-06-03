module Mux_4to1_18bit(mux_out, mux_in_A, mux_in_B, mux_in_C, mux_in_D,  mux_check);

    output  [17:0] mux_out;
    
    input   [17:0] mux_in_A;
    input   [17:0] mux_in_B;
    input   [17:0] mux_in_C;
    input   [17:0] mux_in_D;
    input   [1:0] mux_check;
	reg     [17:0] mux_out;
	
    always@(*) begin
        if (mux_check == 0) begin
	        mux_out = mux_in_A;
	    end
	    else if (mux_check == 1) begin
            mux_out = mux_in_B;
	    end
        else if (mux_check == 2) begin
            mux_out = mux_in_C;
        end
        else begin
            mux_out = mux_in_D;
        end  
	 end

endmodule