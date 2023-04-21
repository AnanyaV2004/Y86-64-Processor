`include "write_back.v"
`timescale 1ns / 1ps


module write_back_tb;
reg clk;
reg [3:0] icode,ifun,rA,rB;
reg [63:0] valA,valB,valE,valM;
wire [63:0] reg_file [0:14];
reg [63:0] reg_file_in [0:14];

write_back wb(clk,icode,ifun,rA,rB,valA,valB,valE,valM,
reg_file_in[0] , 
reg_file_in[1] ,
reg_file_in[2] ,
reg_file_in[3] ,
reg_file_in[4] ,
reg_file_in[5] ,
reg_file_in[6] ,
reg_file_in[7] ,
reg_file_in[8] ,
reg_file_in[9] ,
reg_file_in[10],
reg_file_in[11],
reg_file_in[12],
reg_file_in[13],
reg_file_in[14],
reg_file[0] ,
reg_file[1] ,
reg_file[2] ,
reg_file[3] ,
reg_file[4] ,
reg_file[5] ,
reg_file[6] ,
reg_file[7] ,
reg_file[8] ,
reg_file[9] ,
reg_file[10],
reg_file[11],
reg_file[12],
reg_file[13],
reg_file[14]);

   
initial
begin
     reg_file_in[0] = 64'd0;
     reg_file_in[1] = 64'd1;
     reg_file_in[2] = 64'd2;
     reg_file_in[3] = 64'd3;
     reg_file_in[4] = 64'd4;
     reg_file_in[5] = 64'd5;
     reg_file_in[6] = 64'd6;
     reg_file_in[7] = 64'd7;
     reg_file_in[8] = 64'd8;
     reg_file_in[9] = 64'd9;
     reg_file_in[10]= 64'd10;
     reg_file_in[11]= 64'd11;
     reg_file_in[12]= 64'd12;
     reg_file_in[13]= 64'd13;
     reg_file_in[14]= 64'd14;


clk = 1;
    // #10
    // opq6
    rA = 4'd3;
    rB = 4'd9;
    icode = 4'd6;
    valA = 64'd10;
    valB = 64'd20;
    valE = 64'd50;
    valM = 64'd40;
    

    #10

    // cmov2
    rA = 4'd4;
    rB = 4'd10;
    icode = 4'd2;
    valA = 64'd11;
    valB = 64'd21;
    valE = 64'd51;
    valM = 64'd41;
    
    #10
    // irmov3
    rA = 4'd3;
    rB = 4'd2;
    icode = 4'd3;
    valA = 64'd10;
    valB = 64'd20;
    valE = 64'd57;
    valM = 64'd40;

#10
    // popq11
    rA = 4'd3;
    rB = 4'd9;
    icode = 4'd11;
    valA = 64'd10;
    valB = 64'd20;
    valE = 64'd50;
    valM = 64'd40;

#10
    // call8
    rA = 4'd3;
    rB = 4'd9;
    icode = 4'd8;
    valA = 64'd10;
    valB = 64'd20;
    valE = 64'd50;
    valM = 64'd40;

#10
    // ret9
    rA = 4'd3;
    rB = 4'd9;
    icode = 4'd9;
    valA = 64'd10;
    valB = 64'd20;
    valE = 64'd59;
    valM = 64'd40;

#10
    // pushq10
    rA = 4'd3;
    rB = 4'd9;
    icode = 4'd10;
    valA = 64'd10;
    valB = 64'd20;
    valE = 64'd76;
    valM = 64'd40;

#10
    // mrmov5
    rA = 4'd3;
    rB = 4'd9;
    icode = 4'd5;
    valA = 64'd10;
    valB = 64'd20;
    valE = 64'd50;
    valM = 64'd49;

    #10;
#2;
$finish;

end

always #5
clk = ~clk;

always @*
begin
reg_file_in[0] = reg_file[0]  ;
reg_file_in[1] = reg_file[1]  ;
reg_file_in[2] = reg_file[2] ;
reg_file_in[3] = reg_file[3] ;
reg_file_in[4] = reg_file[4] ;
reg_file_in[5] = reg_file[5] ;
reg_file_in[6] = reg_file[6] ;
reg_file_in[7] = reg_file[7] ;
reg_file_in[8] = reg_file[8] ;
reg_file_in[9] = reg_file[9] ;
reg_file_in[10]= reg_file[10];
reg_file_in[11]= reg_file[11];
reg_file_in[12]= reg_file[12];
reg_file_in[13]= reg_file[13];
reg_file_in[14]= reg_file[14];
end

initial
$monitor($time, "\nclk:%d\nrA:%d rB:%d icode:%d\n valA:%d valB:%d valE:%d valM:%d\nr0:%d r1:%d\n r2:%d\n r3:%d\n r4:%d\n r5:%d\n r6:%d\n r7:%d\n r8:%d\n r9:%d\n r10:%d\n r11:%d\n r12:%d\n r13:%d\n r14:%d\n", 
clk,
rA,rB,icode,valA,valB,valE,valM,
reg_file[0] ,
reg_file[1] ,
reg_file[2] ,
reg_file[3] ,
reg_file[4] ,
reg_file[5] ,
reg_file[6] ,
reg_file[7] ,
reg_file[8] ,
reg_file[9] ,
reg_file[10],
reg_file[11],
reg_file[12],
reg_file[13],
reg_file[14]);

endmodule