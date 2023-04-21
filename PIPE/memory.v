`timescale 1ns / 1ps

module memory(
  clk,M_stat, M_icode,M_cnd,M_valA,M_valE,M_dstE,M_dstM,
  m_valM,W_stat,W_icode, W_valE, W_valM,W_dstE, W_dstM, m_stat
);

  input clk, M_cnd;
  input [2:0] M_stat;
  input [3:0] M_icode;
  input [63:0] M_valA, M_valE;
  input [3:0] M_dstE, M_dstM; 
  input [63:0] valP;//next instr in row
  
  output reg [2:0] W_stat;
  output reg [3:0] W_icode,W_dstE,W_dstM;
  output reg [63:0] W_valE, W_valM, m_valM;
  output reg [63:0] datamem;
  output reg [2:0] m_stat;
  reg [7:0] data_mem[0:1023];
  reg dmem_error = 0;
  reg [3:0] m_icode, m_dstE, m_dstM;
  reg[63:0] m_valE;
  
  always@(posedge clk)
  begin

    m_valE = M_valE;
    m_icode = M_icode;
    m_dstE = M_dstE;
    m_dstM = M_dstM;
    // data_mem[M_valA] = 8'd200; //for pop ooperation. 
    data_mem[M_valA] = 8'd35; //for return 
    data_mem[M_valE] = 8'd100;

    if(dmem_error == 1)
    m_stat[2] = 1;

    case (M_icode)
        4'd4,4'd5,4'd8,4'd10:
        begin
          if(M_valE > 1023)
          dmem_error = 1;
        end

        4'd9, 4'd11:
        begin
          if(M_valA>1023)
          dmem_error =1;
        end
    endcase

    case (M_icode)
    4'b0100,4'b1010:data_mem[M_valE]=M_valA;//rmmovq4, pushqA
    4'b0101:m_valM=data_mem[M_valE];//mrmovq5
    4'b1011:m_valM=data_mem[M_valA];//popqB 
    4'b1000:data_mem[M_valE]=M_valA;//call8
    4'b1001:m_valM=data_mem[M_valA];//ret9
    endcase
  end

  always@(negedge clk)
  begin
    W_stat <= m_stat;
    W_icode<= m_icode;
    W_valM <= m_valM;
    W_valE <= m_valE;
    W_dstE <=  m_dstE;
    W_dstM <=  m_dstM;
    $display("mem_allocated->%b",data_mem[M_valE]);
  end
  
  // always@(data_mem[M_valE])
  //   $display("mem_allocated->%b",data_mem[M_valE]);
endmodule