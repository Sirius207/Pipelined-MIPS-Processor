
module SignExten(input16bit, output32bit);

input [15:0] input16bit;
output [31:0] output32bit;

assign output32bit = (input16bit[15]==1'b1)
    ?{16'b1111_1111_1111_1111,input16bit}
    :{16'b0000_0000_0000_0000,input16bit};

endmodule