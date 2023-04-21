`timescale 1ns / 1ps

module decode(clk,rA,rB,icode,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,valA,valB);
input clk;
input [3:0] rA,rB,icode;
input [63:0] reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14;
wire [63:0] reg_file_in [0:14];
output reg [63:0] valA,valB;

assign reg_file_in[0] = reg0;
assign reg_file_in[1] = reg1;
assign reg_file_in[2] = reg2;
assign reg_file_in[3] = reg3;
assign reg_file_in[4] = reg4;
assign reg_file_in[5] = reg5;
assign reg_file_in[6] = reg6;
assign reg_file_in[7] = reg7;
assign reg_file_in[8] = reg8;
assign reg_file_in[9] = reg9;
assign reg_file_in[10] = reg10;
assign reg_file_in[11] = reg11;
assign reg_file_in[12] = reg12;
assign reg_file_in[13] = reg13;
assign reg_file_in[14] = reg14;

always@*
begin
    if(icode == 4'b0110) //opq 6
    begin
        valA = reg_file_in[rA];
        valB = reg_file_in[rB];
    end

    else if(icode == 4'b0010) //cmovxx 2
    begin
        valA=reg_file_in[rA];
        valB = 0;
    end

    else if(icode == 4'b0011) //irmov 3
    begin
    end

    else if(icode == 4'b0100) //rmmov 4
    begin
        valA = reg_file_in[rA];
        valB = reg_file_in[rB];
    end

    else if (icode == 4'b0101) //mrmov 5
    begin
        valB = reg_file_in[rB];
    end

    else if (icode == 4'b1010) //push A
    begin
        valA = reg_file_in[rA];
        valB = reg_file_in[4]; //%rsp
    end

    else if(icode == 4'b1011) //pop B
    begin
        valA = reg_file_in[4]; //%rsp
        valB = reg_file_in[4]; //%rsp
    end

    else if(icode == 4'b0111) //jxx 7
    begin
    end

    else if(icode == 4'b1000) //call 8
    begin
        valB = reg_file_in[4];
    end

    else if(icode == 4'b1001) // ret 9
    begin
        valA = reg_file_in[4];
        valB = reg_file_in[4];
    end
end

endmodule