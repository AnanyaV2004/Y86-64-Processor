`include "fetch.v"
`include "decode.v"
`include "execute.v"
`include "memory.v"
`include "write_back.v"

module test_bench;
  
  //inputs:
  wire [3:0] D_icode, D_ifun, D_rA, D_rB;
  wire [63:0] D_valC,D_valP;
  reg F_stall,D_stall,D_bubble, E_bubble;

  reg [63:0] reg_file_in [0:14];
  reg [63:0] PC; //INPUT pc FOR FETCH
  //outputs:
  reg clk;
  wire [63:0] temp_pred_pc;
  reg [0:79] instr;
  //Memory:
  reg [7:0] instr_mem[0:1023];

  reg [2:0] cf_in;
  
  wire cnd;

  wire [2:0] cf_out;

  wire [2:0] D_stat; //AOK , HLT, ERR
  wire [63:0] pred_pc; //output of fetch 

  //for decode stage
  wire [2:0]E_stat;
  wire [3:0]E_icode, E_ifun;
  wire [63:0]E_valC, E_valA, E_valB;
  wire [3:0]E_dstE, E_dstM, E_srcA, E_srcB;
  wire [3:0] d_srcA ,d_srcB;

  //for execute
  wire [2:0] M_stat;
  wire [3:0] M_icode, M_dstE, M_dstM,e_dstE;
  wire  M_cnd;
  wire [63:0] M_valE, e_valE;
  wire [63:0] M_valA;
  
  //for memory
  wire [63:0] m_valM;
  wire [2:0] W_stat,m_stat;
  wire [3:0] W_icode,W_dstE,W_dstM;
  wire [63:0] W_valE, W_valM;

//for wb
wire [63:0] reg_file [0:14];

// wire [63:0]jump_instr_pred;
// wire jump_instr_cnd;

reg [63:0]jump_instr_pred;
reg jump_instr_cnd;


fetch fetch_step(D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, clk , PC, temp_pred_pc,instr ,
D_stat, pred_pc, F_stall, D_bubble, D_stall,W_valM, M_icode, W_icode, M_cnd, M_valA,jump_instr_pred,jump_instr_cnd);


decode decode_stage(clk,D_stat,D_rA,D_rB,D_icode,D_ifun,D_valC, D_valP,
reg_file_in[0],
reg_file_in[1],
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
E_valA,E_valB, E_stat, E_icode, E_ifun, E_valC,
E_dstE, E_dstM, E_srcA, E_srcB, d_srcA, d_srcB,e_dstE, e_valE,m_valM,M_dstM,M_dstE,M_valE,W_dstM, W_dstE, W_valM, W_valE,
E_bubble);


execute execute_step (clk,
    M_valE, M_cnd, cf_out, E_icode , E_ifun, E_valC, E_valA, E_valB, cf_in, 
    M_valA , M_icode, M_dstE , M_dstM,E_stat, M_stat,E_dstE, E_dstM, e_dstE, e_valE
);

memory mem_step(
  clk,M_stat, M_icode,M_cnd,M_valA,M_valE,M_dstE,M_dstM,
  m_valM,W_stat,W_icode, W_valE, W_valM,W_dstE, W_dstM, m_stat
);

write_back wb(clk,W_stat,W_icode,W_valE,W_valM,W_dstE,W_dstM,
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

  initial begin 
    clk=0;
    PC = 64'd13;
   
    // assign D_stat = 3'b100;
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
   
  // instr_mem[0]=8'b00010000;
    // // instr_mem[1]=8'b00010000;
    
    //call
    instr_mem[13]=8'b00110000; //4 0//irmov
    instr_mem[14]=8'b11110100; //F rB(4-stack pointer)
    instr_mem[15]=8'b00000000; //V
    instr_mem[16]=8'b00000000; //V
    instr_mem[17]=8'b00000000; //V
    instr_mem[18]=8'b00000000; //V
    instr_mem[19]=8'b00000000; //V
    instr_mem[20]=8'b00000000; //V
    instr_mem[21]=8'b00000000; //V
    instr_mem[22]=8'b01000000; //V=64  

    instr_mem[23] = 8'b00010000;  //nop
    instr_mem[24] = 8'b00010000;  //nop
    instr_mem[25] = 8'b00010000;  //nop

    instr_mem[26]=8'b10000000;//8, call
    instr_mem[27]=8'b00000000; //V
    instr_mem[28]=8'b00000000; //V
    instr_mem[29]=8'b00000000; //V
    instr_mem[30]=8'b00000000; //V
    instr_mem[31]=8'b00000000; //V
    instr_mem[32]=8'b00000000; //V
    instr_mem[33]=8'b00000000; //V
    instr_mem[34]=8'b00110010; //v->50

    instr_mem[35]=8'b00110000; //3 0//irmov
    instr_mem[36]=8'b11110110; //F rB(6)
    instr_mem[37]=8'b00000000; //V
    instr_mem[38]=8'b00000000; //V
    instr_mem[39]=8'b00000000; //V
    instr_mem[40]=8'b00000000; //V
    instr_mem[41]=8'b00000000; //V
    instr_mem[42]=8'b00000000; //V
    instr_mem[43]=8'b00000000; //V
    instr_mem[44]=8'b00000101; //V=5

    instr_mem[45] = 8'b00010000;  //nop
    instr_mem[46] = 8'b00010000;  //nop
    instr_mem[47] = 8'b00010000;  //nop
    instr_mem[48] = 8'b00010000;  //nop
    instr_mem[49] = 8'b00000000;  //halt

// p:
    instr_mem[50] = 8'b00010000;  //nop
    instr_mem[51] = 8'b00010000;  //nop
    instr_mem[52] = 8'b00010000;  //nop

    instr_mem[53]=8'b10010000;  //return

    instr_mem[54]=8'b00110000; //3 0//irmov
    instr_mem[55]=8'b11110000; //F rB(0)
    instr_mem[56]=8'b00000000; //V
    instr_mem[57]=8'b00000000; //V
    instr_mem[58]=8'b00000000; //V
    instr_mem[59]=8'b00000000; //V
    instr_mem[60]=8'b00000000; //V
    instr_mem[61]=8'b00000000; //V
    instr_mem[62]=8'b00000000; //V
    instr_mem[63]=8'b00000001; //V=1  

    instr_mem[64]=8'b00110000; //3 0//irmov
    instr_mem[65]=8'b11110001; //F rB(1)
    instr_mem[66]=8'b00000000; //V
    instr_mem[67]=8'b00000000; //V
    instr_mem[68]=8'b00000000; //V
    instr_mem[69]=8'b00000000; //V
    instr_mem[70]=8'b00000000; //V
    instr_mem[71]=8'b00000000; //V
    instr_mem[72]=8'b00000000; //V
    instr_mem[73]=8'b00000010; //V=2


    instr_mem[74]=8'b00110000; //3 0//irmov
    instr_mem[75]=8'b11110010; //F rB(2)
    instr_mem[76]=8'b00000000; //V
    instr_mem[77]=8'b00000000; //V
    instr_mem[78]=8'b00000000; //V
    instr_mem[79]=8'b00000000; //V
    instr_mem[80]=8'b00000000; //V
    instr_mem[81]=8'b00000000; //V
    instr_mem[82]=8'b00000000; //V
    instr_mem[83]=8'b00000011; //V=3


    instr_mem[84]=8'b00110000; //3 0//irmov
    instr_mem[85]=8'b11110011; //F rB(3)
    instr_mem[86]=8'b00000000; //V
    instr_mem[87]=8'b00000000; //V
    instr_mem[88]=8'b00000000; //V
    instr_mem[89]=8'b00000000; //V
    instr_mem[90]=8'b00000000; //V
    instr_mem[91]=8'b00000000; //V
    instr_mem[92]=8'b00000000; //V
    instr_mem[93]=8'b00000100; //V=4  

    // <--start of load/store hazard---
    // instr_mem[1]=8'b00110000; //3 0
    // instr_mem[2]=8'b11110010; //F rB(2)
    // instr_mem[3]=8'b00000000; //V
    // instr_mem[4]=8'b00000000; //V
    // instr_mem[5]=8'b00000000; //V
    // instr_mem[6]=8'b00000000; //V
    // instr_mem[7]=8'b00000000; //V
    // instr_mem[8]=8'b00000000; //V
    // instr_mem[9]=8'b00000000; //V
    // instr_mem[10]=8'b10000000; //V=128

    // instr_mem[11]=8'b00110000; //3 0
    // instr_mem[12]=8'b11110001; //F rB(1)
    // instr_mem[13]=8'b00000000; //V
    // instr_mem[14]=8'b00000000; //V
    // instr_mem[15]=8'b00000000; //V
    // instr_mem[16]=8'b00000000; //V
    // instr_mem[17]=8'b00000000; //V
    // instr_mem[18]=8'b00000000; //V
    // instr_mem[19]=8'b00000000; //V
    // instr_mem[20]=8'b00000011; //V=3

    // instr_mem[21]=8'b01000000; //4 0 //rmmov
    // instr_mem[22]=8'b00010010; //rA rB(1,2)
    // instr_mem[23]=8'b00000000; //D
    // instr_mem[24]=8'b00000000; //D
    // instr_mem[25]=8'b00000000; //D
    // instr_mem[26]=8'b00000000; //D
    // instr_mem[27]=8'b00000000; //D
    // instr_mem[28]=8'b00000000; //D
    // instr_mem[29]=8'b00000000; //D
    // instr_mem[30]=8'b00000000; //D    

    // instr_mem[31]=8'b00110000; //3 0//irmov
    // instr_mem[32]=8'b11110011; //F rB(3)
    // instr_mem[33]=8'b00000000; //V
    // instr_mem[34]=8'b00000000; //V
    // instr_mem[35]=8'b00000000; //V
    // instr_mem[36]=8'b00000000; //V
    // instr_mem[37]=8'b00000000; //V
    // instr_mem[38]=8'b00000000; //V
    // instr_mem[39]=8'b00000000; //V
    // instr_mem[40]=8'b00001010; //V=10

    // instr_mem[41]=8'b01010000; //5 0//mrmov
    // instr_mem[42]=8'b00000011; //rA rB(0,3)
    // instr_mem[43]=8'b00000000; //D
    // instr_mem[44]=8'b00000000; //D
    // instr_mem[45]=8'b00000000; //D
    // instr_mem[46]=8'b00000000; //D
    // instr_mem[47]=8'b00000000; //D
    // instr_mem[48]=8'b00000000; //D
    // instr_mem[49]=8'b00000000; //D
    // instr_mem[50]=8'b00000000; //D

    // instr_mem[51]=8'b01100000; //6 fn
    // instr_mem[52]=8'b00110000; //rA rB(3,0)

    // instr_mem[53] = 8'b00010000; //nop
    // instr_mem[54] = 8'b00010000; //nop
    // instr_mem[55] = 8'b00010000; //nop
    // instr_mem[56] = 8'b00010000; //nop
    // instr_mem[57] = 8'b00010000; //nop
    // instr_mem[58] = 8'b00010000; //nop
    // instr_mem[59] = 8'b00000000; //halt
    // ----- end of load/store hazard>

    // <---------start of jump mispredicton statment
    // // instr_mem[0]=8'b00010000;
    // instr_mem[1]=8'b01100011; //6 xor
    // instr_mem[2]=8'b00110011; //rA rB (0,0)

    // instr_mem[3] = 8'b01110100;//7,4 (jne, ne)
    // instr_mem[4]=8'b00000000; //V
    // instr_mem[5]=8'b00000000; //V
    // instr_mem[6]=8'b00000000; //V
    // instr_mem[7]=8'b00000000; //V
    // instr_mem[8]=8'b00000000; //V
    // instr_mem[9]=8'b00000000; //V
    // instr_mem[10]=8'b00000000; //V
    // instr_mem[11]=8'b00011010; //V v->26

    // instr_mem[12]=8'b00110000; //3 0//irmov
    // instr_mem[13]=8'b11110000; //F rB(0)
    // instr_mem[14]=8'b00000000; //V
    // instr_mem[15]=8'b00000000; //V
    // instr_mem[16]=8'b00000000; //V
    // instr_mem[17]=8'b00000000; //V
    // instr_mem[18]=8'b00000000; //V
    // instr_mem[19]=8'b00000000; //V
    // instr_mem[20]=8'b00000000; //V
    // instr_mem[21]=8'b00000001; //V=1  

    // instr_mem[22] = 8'b00010000; //nop
    // instr_mem[23] = 8'b00010000; //nop
    // instr_mem[24] = 8'b00010000; //nop
    // instr_mem[25] = 8'b00000000; //halt

    // instr_mem[26]=8'b00110000; //3 0//irmov
    // instr_mem[27]=8'b11110010; //F rB(2)
    // instr_mem[28]=8'b00000000; //V
    // instr_mem[29]=8'b00000000; //V
    // instr_mem[30]=8'b00000000; //V
    // instr_mem[31]=8'b00000000; //V
    // instr_mem[32]=8'b00000000; //V
    // instr_mem[33]=8'b00000000; //V
    // instr_mem[34]=8'b00000000; //V
    // instr_mem[35]=8'b00000011; //V=3

    // instr_mem[36]=8'b00110000; //3 0//irmov
    // instr_mem[37]=8'b11110001; //F rB(1)
    // instr_mem[38]=8'b00000000; //V
    // instr_mem[39]=8'b00000000; //V
    // instr_mem[40]=8'b00000000; //V
    // instr_mem[41]=8'b00000000; //V
    // instr_mem[42]=8'b00000000; //V
    // instr_mem[43]=8'b00000000; //V
    // instr_mem[44]=8'b00000000; //V
    // instr_mem[45]=8'b00000100; //V=4 

    // instr_mem[46]=8'b00110000; //3 0//irmov
    // instr_mem[47]=8'b11110010; //F rB(2)
    // instr_mem[48]=8'b00000000; //V
    // instr_mem[49]=8'b00000000; //V
    // instr_mem[50]=8'b00000000; //V
    // instr_mem[51]=8'b00000000; //V
    // instr_mem[52]=8'b00000000; //V
    // instr_mem[53]=8'b00000000; //V
    // instr_mem[54]=8'b00000000; //V
    // instr_mem[55]=8'b00000101; //V=5  
    // // instr_mem[56] = 8'b00010000; //nop
    // // instr_mem[57] = 8'b00010000;
    // // instr_mem[58] = 8'b00000000;
    // -----end of jump mi-predicted instr---------->

// // POP
//     instr_mem[53]=8'b10110000;
//     instr_mem[54]=8'b00110000;

//     instr_mem[55] = 8'b00010000;
//     instr_mem[56] = 8'b00010000;
//     instr_mem[57] = 8'b00010000;
//     instr_mem[58] = 8'b00010000;
//     instr_mem[59] = 8'b00010000;
//     instr_mem[60] = 8'b00000000; 

    // //cmovxx
    // instr_mem[1]=8'b00010000;
    // // // instr_mem[1]=8'b00010000;
    // instr_mem[2]=8'b10100000;
    // instr_mem[3]=8'b00110000;

    // instr_mem[4] = 8'b00010000;
    // instr_mem[5] = 8'b00010000;
    // instr_mem[6] = 8'b00010000;
    // instr_mem[7] = 8'b00010000;
    // instr_mem[8]=8'b00000000;

    // instr_mem[2]=8'b00100000; //2 fn
    // instr_mem[3]=8'b00010011; //rA rB (1 ,3)
 

    // instr_mem[6]=8'b00110000; //3 0
    // instr_mem[7]=8'b00000100; //F rB(2)
    // instr_mem[8]=8'b00000000;
    // instr_mem[4] = 8'b00010000;
    // instr_mem[5] = 8'b00010000;
    // instr_mem[6] = 8'b00010000;
    // instr_mem[7] = 8'b00010000;
    // instr_mem[8] = 8'b00010000;
   

  // irmovq
    // instr_mem[9]=8'b00110000; //3 0
    // instr_mem[9]=8'b00000010; //F rB(2)
    // instr_mem[10]=8'b00000000; //V
    // instr_mem[11]=8'b00000000; //V
    // instr_mem[12]=8'b00000000; //V
    // instr_mem[13]=8'b00000000; //V
    // instr_mem[14]=8'b00000000; //V
    // instr_mem[15]=8'b00000000; //V
    // instr_mem[16]=8'b00000000; //V
    // instr_mem[17]=8'b00010001; //V=17
     // instr_mem[9] = 8'b00000000;//

  //rmmovq
    // instr_mem[18]=8'b01000000; //4 0
    // instr_mem[19]=8'b01010100; //rA rB(5,4)
    // instr_mem[20]=8'b00000000; //D
    // instr_mem[21]=8'b00000000; //D
    // instr_mem[22]=8'b00000000; //D
    // instr_mem[23]=8'b00000000; //D
    // instr_mem[24]=8'b00000000; //D
    // instr_mem[25]=8'b00000000; //D
    // instr_mem[26]=8'b00000000; //D
    // instr_mem[27]=8'b00000001; //D

  // //mrmovq
    // instr_mem[28]=8'b01010000; //5 0
    // instr_mem[29]=8'b0111  ; //rA rB(7,0)
    // instr_mem[30]=8'b00000000; //D
    // instr_mem[31]=8'b00000000; //D
    // instr_mem[32]=8'b00000000; //D
    // instr_mem[33]=8'b00000000; //D
    // instr_mem[34]=8'b00000000; //D
    // instr_mem[35]=8'b00000000; //D
    // instr_mem[36]=8'b00000000; //D
    // instr_mem[37]=8'b00000001; //D

  //  OPq
    // instr_mem[33]=8'b01100000; //6 fn
    // instr_mem[34]=8'b00100011; //rA rB5

  // // cmovxx
  //   instr_mem[35]=8'b00100000; //2 fn
  //   instr_mem[36]=8'b00110100; //rA rB

  //   instr_mem[37]=8'b00100101; // 2 ge
  //   instr_mem[38]=8'b01010011; // rA rB

  // popq
  // instr_mem[39]=8'b10110000;
  // instr_mem[40]=8'b00110000;
  
  // // call
  // instr_mem[41]=8'b10000000;
  // instr_mem[42]=8'b00000000;
  // instr_mem[43]=8'b00000000;
  // instr_mem[44]=8'b00000000;
  // instr_mem[45]=8'b00000000;
  // instr_mem[46]=8'b00000000;
  // instr_mem[47]=8'b00000000;
  // instr_mem[48]=8'b00000000;
  // instr_mem[49]=8'b00000001;

  //ret
  // instr_mem[39]=8'b10010000;
  //halt
  // instr_mem[10]=8'b00000000; // 0 0

  #20;
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

// always @(negedge clk)
// begin
  
// end

always @(posedge clk)
begin
  
  if(E_icode==4'h7 && !M_cnd)
        begin  // Jump not taken
            jump_instr_cnd = 1;
            jump_instr_pred = E_valA;
        end
        else if(M_icode==4'h9) begin     // Return statement
            jump_instr_pred = m_valM;
            jump_instr_cnd = 1;
        end
        else
        begin
            jump_instr_cnd = 0;
        end
  
  if(E_icode == 4'h7 & !M_cnd)
  begin
    D_bubble = 1;
    E_bubble = 1;
    F_stall = 0;
    D_stall = 0;
  end
  else if((E_icode == 4'h5 | E_icode == 4'hB) & (M_dstM==d_srcA | M_dstM==d_srcB))
  begin
    F_stall = 1;
    D_stall = 1;
    E_bubble = 1;
     D_bubble = 0;
  end 
  else if(E_icode == 4'h9 | M_icode == 4'h9 | D_icode == 4'h9)
  begin
      F_stall = 1;
      D_bubble = 1;
      D_stall = 0;
      E_bubble = 0;
  end
  else if(E_icode == 4'h0 | m_stat!=4'b1000 | W_stat!=4'b1000)
    begin
        cf_in = 0;
         F_stall = 0;
        D_stall = 0;
        E_bubble = 0;
        D_bubble = 0;
    end
  else
  begin
    F_stall = 0;
        D_stall = 0;
        E_bubble = 0;
        D_bubble = 0;
  end
end
 
always @*
begin
  cf_in=cf_out;
end


  always @(*) begin
    if(D_stat[1] == 1 || E_stat[1] ==1  || M_stat[1] == 1 || W_stat[1]==1)
    begin 
      $display("BYE-BYE\n");
      $finish;
    end
    if(D_stat[2] == 1 || E_stat[2] ==1  || M_stat[2] == 1 || W_stat[2]==1)
    begin 
      $display("BYE-BYE2\n");
      $finish;
    end
  end

  always #5 begin
    clk = ~clk;
  end

  always@*
  PC = pred_pc;
  
  // always @(posedge clk) PC=valP;


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
$monitor($time,"\nclk:%d\nD_rA:%d D_rB:%d\nD_icode:%d E_icode:%d M_icode: %d W_icode:%d\nD_valC:%d e_valE:%d M_valE:%d W_valE:%d\n E_valA:%d E_valB:%d\ncf_in:%d M_valE:%d M_cnd:%d cf_out:%d\nW_valM:%d\ne_dstE:%d E_dstE:%d M_dstE:%d W_dstE:%d\nr0:%d\nr1:%d\n r2:%d\n r3:%d\n r4:%d\n r5:%d\n r6:%d\n r7:%d\n r8:%d\n r9:%d\n r10:%d\n r11:%d\n r12:%d\n r13:%d\n r14:%d\nPC:%d\n", 
clk,
D_rA,D_rB,D_icode,E_icode,M_icode,W_icode,D_valC,e_valE,M_valE,W_valE,E_valA, E_valB, cf_in,M_valE,M_cnd,cf_out,W_valM,
e_dstE, E_dstE, M_dstE, W_dstE,
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

// $monitor($time,"\nclk:%d\n%d,%d,D_icode:%d,E_icode:%d,M_icode:%d,W_icode:%d\nW_valE:%d,E_valC:%d\nr0:%d\nr1:%d\n r2:%d\n r3:%d\n r4:%d\n r5:%d\n r6:%d\n r7:%d\n r8:%d\n r9:%d\n r10:%d\n r11:%d\n r12:%d\n r13:%d\n r14:%d\nPC:%d\n", 
// clk,
// D_rA,D_rB,D_icode,E_icode,M_icode,W_icode,W_valE,E_valC,
// reg_file[0] ,
// reg_file[1] ,
// reg_file[2] ,
// reg_file[3] ,
// reg_file[4] ,
// reg_file[5] ,
// reg_file[6] ,
// reg_file[7] ,
// reg_file[8] ,
// reg_file[9] ,
// reg_file[10],
// reg_file[11],
// reg_file[12],
// reg_file[13],
// reg_file[14],
// PC);
// $monitor($time,"\nclk:%d m_valM : %d\nD_rA:%d D_rB:%d\nD_icode:%d E_icode:%d M_icode: %d W_icode:%d\nD_valC:%d e_valE:%d M_valE:%d W_valE:%d\n E_valA:%d E_valB:%d\ncf_in:%d M_valE:%d M_cnd:%d cf_out:%d\nW_valM:%d\ne_dstE:%d E_dstE:%d M_dstE:%d W_dstE:%d\nr0:%d\nr1:%d\n r2:%d\n r3:%d\n r4:%d\n r5:%d\n r6:%d\n r7:%d\n r8:%d\n r9:%d\n r10:%d\n r11:%d\n r12:%d\n r13:%d\n r14:%d\nPC:%d\n", 
// clk,m_valM,
// D_rA,D_rB,D_icode,E_icode,M_icode,W_icode,D_valC,e_valE,M_valE,W_valE,E_valA, E_valB, cf_in,M_valE,M_cnd,cf_out,W_valM,
// e_dstE, E_dstE, M_dstE, W_dstE,
// reg_file[0] ,
// reg_file[1] ,
// reg_file[2] ,
// reg_file[3] ,
// reg_file[4] ,
// reg_file[5] ,
// reg_file[6] ,
// reg_file[7] ,
// reg_file[8] ,
// reg_file[9] ,
// reg_file[10],
// reg_file[11],
// reg_file[12],
// reg_file[13],
// reg_file[14],
// PC);

// $monitor($time, "\nclk:%d , M_valE:%d, E_icode:%d",clk,M_valE,E_icode );
// always @(posedge clk)
$monitor($time , "\n clK:%d , D_icode:%d , E_icode:%d , M_icode=%d , W_icode=%d, PC=%d", clk , D_icode , E_icode,M_icode, W_icode,PC);
// $monitor("\nArya -> clk=%d PC=%d icode=%b ifun=%b rA=%b rB=%b,valC=%d,valP=%d\n",clk,PC,icode,ifun,rA,rB,valC,valP);
        // $monitor("\nAnanya clk:%d icode:%d ifun:%d rA:%d rB:%d valA:%d valB:%d\n", clk, icode,ifun,rA,rB,valA,valB); 
        // $monitor("clk=%d valE = %d, cnd = %d, cf_out = %b", clk,valE, cnd, cf_out);
        // $monitor("\nclk:%d D_icode:%d , E_icode:%d, M_icode:%d, W_icode:%d",clk, D_icode , E_icode, M_icode,W_icode);

end
endmodule