`timescale 1ns / 1ps
`include "decode.v"
module decode_tb;
reg clk;
reg[3:0] rA,rB,icode;
reg [63:0] reg_file [0:14];

wire[63:0] valA,valB;
integer k;

decode decode(clk,rA,rB,icode,reg_file[0],reg_file[1],
reg_file[2],
reg_file[3],
reg_file[4],
reg_file[5],
reg_file[6],
reg_file[7],
reg_file[8],
reg_file[9],
reg_file[10],
reg_file[11],
reg_file[12],
reg_file[13],
reg_file[14],
valA,valB);

initial begin

    clk=1'b1;
    rA = 4'd3;
    rB = 4'd9;
    
    reg_file[0] = 64'd0;
    reg_file[1] = 64'd1;
    reg_file[2] = 64'd2;
    reg_file[3] = 64'd3;
    reg_file[4] = 64'd4;
    reg_file[5] = 64'd5;
    reg_file[6] = 64'd6;
    reg_file[7] = 64'd7;
    reg_file[8] = 64'd8;
    reg_file[9] = 64'd9;
    reg_file[10] = 64'd10;
    reg_file[11] = 64'd11;
    reg_file[12] = 64'd12;
    reg_file[13] = 64'd13;
    reg_file[14] = 64'd14;

    icode=4'b0;
    #40;
    icode = icode+1;

    for (k=2;k<12;k=k+1)
    begin
        #40;
        icode=icode+1;    
    end

end

always #10 clk = ~clk;
 always @(icode) begin
    if(icode==11) 
      $finish;
  end

always @(clk)begin
    $display($time,"\nclk:%d icode:%d rA:%d rB:%d \nvalA:%d valB:%d", clk, icode,rA,rB,valA,valB);    
end
// initial
//     $monitor($time,"\nclk:%d icode:%d rA:%d rB:%d \nvalA:%d valB:%d", clk, icode,rA,rB,valA,valB);

endmodule