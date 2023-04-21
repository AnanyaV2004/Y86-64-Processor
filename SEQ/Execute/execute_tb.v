`timescale 1ns / 1ps
`include "execute.v"

module execute_tb;

reg [3:0] icode, ifun;
reg [63:0] valC, valA, valB;
reg [2:0] cf_in;
wire [63:0] valE;
wire cnd;
wire [2:0] cf_out;

execute dut (
    .icode(icode),
    .ifun(ifun),
    .valC(valC),
    .valA(valA),
    .valB(valB),
    .cf_in(cf_in),
    .valE(valE),
    .cnd(cnd),
    .cf_out(cf_out)
);

initial begin
   
    icode = 4'b0110; // opq
    ifun = 4'b0001;
    // $display("%d\n", ifun[1:0]);
    valC = 64'h0000_0000_0000_0001;
    valA = 64'd5;
    valB = 64'd5;
    cf_in = 3'b000;
    #10;
    // check results
    $display("valE = %d, cnd = %d, cf_out = %b", valE, cnd, cf_out);
    // add more tests as needed
end

endmodule
