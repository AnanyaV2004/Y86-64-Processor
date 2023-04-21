`timescale 1ns/10ps
`include "XOR.v"
module XOR_tb;
    reg signed [63:0] A=64'b1111111111111111111111111111111111111111111111111111111111111111;
    reg signed [63:0] B=64'b1111111111111111111111111111111111111111111111111111111111111111;

    wire [63:0]Out;

    xor64bits ALU_XOR(A , B,  Out);

integer m = 1;
integer k, j;

initial begin
    $dumpfile("XOR_tb.vcd");
    $dumpvars(0,XOR_tb);
    
    
    $monitor($time,"\nA=%b\nB=%b\nOut=%b\n", A,B,Out);

    for(k = 0; k < 10; k = k + 1)
    begin
        A = A-1;
        for(j = 0; j < 10; j = j + 1)
        begin
            B = B-1;
            #5;
        end
        B=64'b1111111111111111111111111111111111111111111111111111111111111111;
    end

end

endmodule