`include "fetch.v"

module fetch_tb;
  
  //inputs:
  wire [3:0] icode, ifun, rA, rB;
  wire [63:0] valC,valP;
  wire mem_error, instr_err;
  
  //outputs:
  reg clk;
  reg [63:0] PC;
  reg [0:79] instr;
  //Mempory:
  reg [7:0] instr_mem[0:1023];

fetch fetch_step(icode, ifun, rA, rB, valC, valP,mem_error, instr_err, clk , PC, instr);

    
  initial begin 
    clk=1;
    PC=64'd32;
   //OPq
    instr_mem[32]=8'b01100001; //6 fn
    instr_mem[33]=8'b00100011; //rA rB


  //cmovxx
    instr_mem[34]=8'b00100000; //2 fn
    instr_mem[35]=8'b00110100; //rA rB

    instr_mem[36]=8'b00100101; // 2 ge
    instr_mem[37]=8'b01010011; // rA rB

  //halt
    instr_mem[38]=8'b00000000; // 0 0

//     instr_mem[32]=8'b01100000; //5 fn
//     instr_mem[33]=8'b00100011; //rA rB
  
//     instr_mem[34]=8'b00010000; // 1 0
//     instr_mem[35]=8'b00010000; // 1 0
//     instr_mem[36]=8'b00010000; // 1 0

//   //cmovxx
//     instr_mem[37]=8'b00100000; //2 fn
//     instr_mem[38]=8'b00000100; //rA rB

//     instr_mem[39]=8'b00010000; // 1 0
//     instr_mem[40]=8'b00010000; // 1 0
//     instr_mem[41]=8'b00010000; // 1 0
//     instr_mem[42]=8'b00010000; // 1 0
//     instr_mem[43]=8'b00010000; // 1 0
//     instr_mem[44]=8'b00010000; // 1 0

//   //halt
//     instr_mem[45]=8'b00000000; // 0 0

end 


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
    if(icode==0 ) 
      $finish;
  end

  always #15 begin
    if(clk ==1 )
        clk = 0;
    else
        clk = 1;
  end
  
  always @(posedge clk) PC<=valP;
  always @(mem_error) begin
    if(mem_error == 1 || instr_err == 1)
        $monitor("Wrong instr add\n");
  end
  initial 
		$monitor("clk=%d PC=%d icode=%b ifun=%b rA=%b rB=%b,valC=%d,valP=%d\n",clk,PC,icode,ifun,rA,rB,valC,valP);
endmodule