`include "Fetch/fetch.v"
`include "DECODE/decode.v"
`include "Execute/execute.v"
`include "Memory/memory.v"
`include "WRITE_BACK/write_back.v"
`include "PC_update/pcupdate.v"

module test_bench;
  
  //inputs:
  wire [3:0] icode, ifun, rA, rB;
  wire [63:0] valC,valP;
  wire mem_error, instr_err;
  reg [63:0] reg_file_in [0:14];
  reg [63:0] PC;
  //outputs:
  reg clk;
  wire [63:0] PC_nxt;
  reg [0:79] instr;
  //Memory:
  reg [7:0] instr_mem[0:1023];
  wire[63:0] valA,valB;
reg [2:0] cf_in;
wire [63:0] valE;
wire cnd;
wire [2:0] cf_out;


fetch fetch_step(icode, ifun, rA, rB, valC, valP,mem_error, instr_err, clk , PC, instr);

decode decode_stage(clk,rA,rB,icode,reg_file_in[0],reg_file_in[1],
reg_file_in[2],
reg_file_in[3],
reg_file_in[4],
reg_file_in[5],
reg_file_in[6],
reg_file_in[7],
reg_file_in[8],
reg_file_in[9],
reg_file_in[10],
reg_file_in[11],
reg_file_in[12],
reg_file_in[13],
reg_file_in[14],
valA,valB);


execute execute_step (
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

wire [63:0] valM;
memory mem_step(
  clk,icode,valA,valE,valP,valM
);

wire [63:0] reg_file [0:14];
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

pcupdate dut(.valC(valC), .valM(valM), .valP(valP), .clk(clk), .icode(icode), .cnd(cnd), .pcnxt(PC_nxt));

  initial begin 
    clk=0;
    PC = 64'd0;

    cf_in = 3'b000;

    reg_file_in[0] = 64'd0;
    reg_file_in[1] = 64'd1;
    reg_file_in[2] = 64'd2;
    reg_file_in[3] = 64'd3;
    reg_file_in[4] = 64'd60;  //stack pointer
    reg_file_in[5] = 64'd5;
    reg_file_in[6] = 64'd6;
    reg_file_in[7] = 64'd7;
    reg_file_in[8] = 64'd8;
    reg_file_in[9] = 64'd9;
    reg_file_in[10] = 64'd10;
    reg_file_in[11] = 64'd11;
    reg_file_in[12] = 64'd12;
    reg_file_in[13] = 64'd13;
    reg_file_in[14] = 64'd14;


    //cmovxx
    instr_mem[0]=8'b00010000;
    instr_mem[1]=8'b00100000; //2 fn
    instr_mem[2]=8'b00010011; //rA rB

  //irmovq
    instr_mem[3]=8'b00110000; //3 0
    instr_mem[4]=8'b00000010; //F rB
    instr_mem[5]=8'b00000000; //V
    instr_mem[6]=8'b00000000; //V
    instr_mem[7]=8'b00000000; //V
    instr_mem[8]=8'b00000000; //V
    instr_mem[9]=8'b00000000; //V
    instr_mem[10]=8'b00000000; //V
    instr_mem[11]=8'b00000000; //V
    instr_mem[12]=8'b00010001; //V=17

  //rmmovq
    instr_mem[13]=8'b01000000; //4 0
    instr_mem[14]=8'b01010010; //rA rB
    instr_mem[15]=8'b00000000; //D
    instr_mem[16]=8'b00000000; //D
    instr_mem[17]=8'b00000000; //D
    instr_mem[18]=8'b00000000; //D
    instr_mem[19]=8'b00000000; //D
    instr_mem[20]=8'b00000000; //D
    instr_mem[21]=8'b00000000; //D
    instr_mem[22]=8'b00000001; //D

  //mrmovq
    instr_mem[23]=8'b01010000; //5 0
    instr_mem[24]=8'b01110000; //rA rB
    instr_mem[25]=8'b00000000; //D
    instr_mem[26]=8'b00000000; //D
    instr_mem[27]=8'b00000000; //D
    instr_mem[28]=8'b00000000; //D
    instr_mem[29]=8'b00000000; //D
    instr_mem[30]=8'b00000000; //D
    instr_mem[31]=8'b00000000; //D
    instr_mem[32]=8'b00000001; //D

  //  OPq
    instr_mem[33]=8'b01100000; //6 fn
    instr_mem[34]=8'b00100011; //rA rB5

  // cmovxx
    instr_mem[35]=8'b00100000; //2 fn
    instr_mem[36]=8'b00110100; //rA rB

    instr_mem[37]=8'b00100101; // 2 ge
    instr_mem[38]=8'b01010011; // rA rB

 // // popq
  // instr_mem[38]=8'b00010000;
  // instr_mem[39]=8'b10110000;
  // instr_mem[40]=8'b00110000;
  
  // // call
  // instr_mem[40]=8'b00010000;
  // instr_mem[41]=8'b10000000;
  // instr_mem[42]=8'b00000000;
  // instr_mem[43]=8'b00000000;
  // instr_mem[44]=8'b00000000;
  // instr_mem[45]=8'b00000000;
  // instr_mem[46]=8'b00000000;
  // instr_mem[47]=8'b00000000;
  // instr_mem[48]=8'b00000000;
  // instr_mem[49]=8'b00000011;
  // instr_mem[3]=8'b00000000; // 0 0
  // //ret
  // instr_mem[38]=8'b00010000;
  // instr_mem[39]=8'b10010000;

  // instr_mem[200]=8'b00000000; // 0 0

  //halt
  instr_mem[39]=8'b00000000; // 0 0

  #10;
end 

// always@(icode==0)
// $finish;

  always@(PC) begin
    
    instr={
      instr_mem[PC],
      instr_mem[PC+1],
      instr_mem[PC+2],
      instr_mem[PC+3],
      instr_mem[PC+4],
      instr_mem[PC+5],
      instr_mem[PC+6],
      instr_mem[PC+7],
      instr_mem[PC+8],
      instr_mem[PC+9]
    };
  end


  always @(icode) begin
    if(icode===0 ) 
      $finish;
  end

  always #5 begin
    clk = ~clk;
  end

  always@*
  PC = PC_nxt;
  
  // always @(posedge clk) PC=valP;

  always @(mem_error) begin
    if(mem_error == 1 || instr_err == 1)
        $monitor("Wrong instr add\n");
  end

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

initial begin
$monitor($time,"\nclk:%d\nrA:%d rB:%d icode:%d ifun:%d valC:%d valP:%d mem_error:%d\n valA:%d valB:%d\ncf_in:%d valE:%d cnd:%d cf_out:%d\nvalM:%d\nr0:%d\nr1:%d\n r2:%d\n r3:%d\n r4:%d\n r5:%d\n r6:%d\n r7:%d\n r8:%d\n r9:%d\n r10:%d\n r11:%d\n r12:%d\n r13:%d\n r14:%d\nPC:%d\n", 
clk,
rA,rB,icode,ifun,valC,valP,mem_error,valA,valB,cf_in,valE,cnd,cf_out,valM,
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
reg_file[14],
PC);


// $monitor("\nArya -> clk=%d PC=%d icode=%b ifun=%b rA=%b rB=%b,valC=%d,valP=%d\n",clk,PC,icode,ifun,rA,rB,valC,valP);
        // $monitor("\nAnanya clk:%d icode:%d ifun:%d rA:%d rB:%d valA:%d valB:%d\n", clk, icode,ifun,rA,rB,valA,valB); 
        // $monitor("clk=%d valE = %d, cnd = %d, cf_out = %b", clk,valE, cnd, cf_out);
end
endmodule
