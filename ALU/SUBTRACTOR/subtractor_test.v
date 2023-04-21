`timescale 1ns/10ps
`include "subtractor_64.v"

module subtractor_test;

reg signed [63:0] a;
reg signed [63:0] b;
reg [64:0] ans;

wire signed [63:0] difference;
wire overflow, borrow;

subtractor_64 tt(
.a(a),
.b(b),
.difference(difference),
.overflow(overflow),
.borrow(borrow));

always @ (a or b) begin
    ans = a-b;
end

integer k,j,m=1;

initial begin

    $dumpfile("subtractor_test.vcd");
    $dumpvars(0,subtractor_test);
    $monitor($time,"\nA=%b\nB=%b\nDifference=%b\nAns:%b\nOverflow=%b\n", a,b,difference,ans,overflow);
    
    a = 64'b1111111111111111111111111111111111111111111111111111111111111111;
    b = 64'b1111111111111111111111111111111111111111111111111111111111111111;

    #5;

    for(k = 0; k < 5; k = k + 1)
    begin
        b = 64'b1111111111111111111111111111111111111111111111111111111111111111;
        a=a-1;
        #5;
        for(j = 0; j < 5; j = j + 1)
        begin
            b = b-1;
            #5;
        end
    end

    a=64'b0111111111111111111111111111111111111111111111111111111111111111;
    b=64'b1111111111111111111111111111111111111111111111111111111111100001;
    #5;

    a=64'b0110010111100000000000000111111111110000110101010101010100000000;
    b=64'b0111111100000000000000000000000000000000000000000000000001010101;
    #5;
end
  
endmodule

