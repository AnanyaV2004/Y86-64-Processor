`timescale 1ns / 1ps
module write_back(clk,icode,ifun,rA,rB,valA,valB,valE,valM,
reg_in0,reg_in1,reg_in2,reg_in3,reg_in4,reg_in5,reg_in6,reg_in7,reg_in8,reg_in9,reg_in10,reg_in11,reg_in12,reg_in13,reg_in14,
reg_out0,reg_out1,reg_out2,reg_out3,reg_out4,reg_out5,reg_out6,reg_out7,reg_out8,reg_out9,reg_out10,reg_out11,reg_out12,reg_out13,reg_out14
);

input clk;
input [3:0] icode,ifun,rA,rB;
input [63:0] valA,valB,valE,valM;
input [63:0] reg_in0,reg_in1,reg_in2,reg_in3,reg_in4,reg_in5,reg_in6,reg_in7,reg_in8,reg_in9,reg_in10,reg_in11,reg_in12,reg_in13,reg_in14;
output[63:0] reg_out0,reg_out1,reg_out2,reg_out3,reg_out4,reg_out5,reg_out6,reg_out7,reg_out8,reg_out9,reg_out10,reg_out11,reg_out12,reg_out13,reg_out14;
reg [63:0] reg_file [0:14];



always@(negedge clk)
begin
    reg_file[0] = reg_in0;
reg_file[1] = reg_in1;
reg_file[2] = reg_in2;
reg_file[3] = reg_in3;
reg_file[4] = reg_in4;
reg_file[5] = reg_in5;
reg_file[6] = reg_in6;
reg_file[7] = reg_in7;
reg_file[8] = reg_in8;
reg_file[9] = reg_in9;
reg_file[10]= reg_in10;
reg_file[11]= reg_in11;
reg_file[12]= reg_in12;
reg_file[13]= reg_in13;
reg_file[14]= reg_in14;

    case(icode)
    4'b0110,4'b0010,4'b0011: //opq6 cmov2 irmov3
    begin
        reg_file[rB] = valE;
    end

    4'b1011: //popq11
    begin
        reg_file[4] = valE;
        reg_file[rA] = valM;
    end

    4'b1000,4'b1001,4'b1010: //call8 ret9  pushq10
    begin
        reg_file[4] = valE;
    end

    4'b0101: //mrmov5
    begin
        reg_file[rA]=valM;
    end
    endcase

end


assign reg_out0 =  reg_file[0] ;
assign reg_out1 =  reg_file[1] ;
assign reg_out2 =  reg_file[2] ;
assign reg_out3 =  reg_file[3] ;
assign reg_out4 =  reg_file[4] ;
assign reg_out5 =  reg_file[5] ;
assign reg_out6 =  reg_file[6] ;
assign reg_out7 =  reg_file[7] ;
assign reg_out8 =  reg_file[8] ;
assign reg_out9 =  reg_file[9] ;
assign reg_out10= reg_file[10] ;
assign reg_out11= reg_file[11] ;
assign reg_out12= reg_file[12] ;
assign reg_out13= reg_file[13] ;
assign reg_out14= reg_file[14] ;

endmodule