
module SignExten_18(input18bit, output32bit);

input [17:0] input18bit;
output [31:0] output32bit;

assign output32bit = (input18bit[17]==1'b1)
    ?{14'b11111111111111,input18bit}
    :{14'b00000000000000,input18bit};

endmodule