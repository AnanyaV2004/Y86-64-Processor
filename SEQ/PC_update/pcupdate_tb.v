`include "pcupdate.v"
module pcupdate_tb;
    wire [63:0] PC;
    // wire [63:0] pcnxt;
    reg [63:0] valC, valM, valP;
    reg clk;
    reg [3:0] icode;
    reg cnd;

    pcupdate dut(.valC(valC), .valM(valM), .valP(valP), .clk(clk), .icode(icode), .cnd(cnd), .pcnxt(PC));

    initial begin
        clk = 0;
        // PC = 0;
        #5;

        icode = 4'b0000;
        #5;
        $display("PC=%d", PC);

        icode = 4'b0111;
        cnd = 1;
        valC = 64'd2;
        valP = 64'd2;
        #5;
        $display("PC=%d", PC);

        cnd = 0;
        #5;
        $display("PC=%d", PC);

        icode = 4'b1000;
        valC = 64'd2;
        #5;
        $display("PC=%d", PC);

        icode = 4'b1001;
        valM = 64'd2;
        #5;
        $display("PC=%d", PC);

        icode = 4'b1010;
        valP = 64'd2;
        #5;
        $display("PC=%d", PC);

        $finish;
    end

    always #2 clk = ~clk;
    // always@*
    // PC=pcnxt;
endmodule
