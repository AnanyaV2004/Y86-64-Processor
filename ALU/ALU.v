`timescale 1ns / 1ps

`include "../ALU/ADDER/adder_64.v"
`include "../ALU/SUBTRACTOR/subtractor_64.v"
`include "../ALU/XOR/XOR.v"
`include "../ALU/AND/AND.v"

module ALU(control, a, b, ans , overflow);
  
  input [1:0]control;
  input signed [63:0]a;
  input signed [63:0]b;
  output signed [63:0]ans;
  output overflow;

  wire signed [63:0]ans1;
  wire signed [63:0]ans2;
  wire signed [63:0]ans3;
  wire signed [63:0]ans4;
  
  adder_64 ADDBHAI(a,b,ans1,overflow1,carry1); 
  subtractor_64 SUBBHAI(a,b,ans2,overflow2, carry2);
  and64bits ANDBHAI(a,b,ans3);
  xor64bits XORBHAI(a,b,ans4);

  reg signed [63:0]ansfinal;
  reg overflowfinal;
 
  always @(*)
  begin
    if(control === 2'b00)
    begin
      ansfinal=ans1;
      overflowfinal=overflow1;
    end
    else if(control === 2'b01)
    begin
      ansfinal=ans2;
      overflowfinal=overflow2;
    end
    else if(control === 2'b10)
    begin
      ansfinal=ans3;
      overflowfinal=1'b0;
    end
    else
    begin
      ansfinal=ans4;
      overflowfinal=1'b0;
    end
  end

  assign ans= ansfinal;
  assign overflow= overflowfinal;
endmodule