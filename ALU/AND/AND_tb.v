`timescale 1ns/10ps
`include "AND.v"
module AND_tb;
    reg signed [63:0] A=64'b1111111111111111111111111111111111111111111111111111111111111111;
    reg signed [63:0] B=64'b1111111111111111111111111111111111111111111111111111111111111111;

    wire signed [63:0]Out;

    and64bits ALU_AND(A , B,  Out);

integer m = 1;
integer k, j;


initial begin
    $dumpfile("AND_tb.vcd");
    $dumpvars(0,AND_tb);
    
    
    $monitor($time,"\nA=%b\nB=%b\nOut=%b\n", A,B,Out);

    for(k = 0; k < 10; k = k + 1)
    begin
        A = A-1;
        B=64'b1111111111111111111111111111111111111111111111111111111111111111;
        for(j = 0; j < 10; j = j + 1)
        begin
            B = B-1;
            #5;
        end
        
    end

end



endmodule