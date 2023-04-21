`timescale 1ns / 1ps
`include "ALU.v"
module ALU_tb;
  
  reg signed [63:0]a;
  reg signed [63:0]b;

  wire signed [63:0]ans;
  reg [1:0]control=2'b00;

  wire overflow;

  ALU ALU_CALL(control , a, b, ans, overflow);
  integer j,k;

  reg signed [63:0]ans00;
  reg signed [63:0]ans01;
  reg signed [63:0]ans10;
  reg signed [63:0]ans11;
  always @(*)
  begin
    ans00 = a+b;
    ans01 = a-b;
    ans10 = a&b;
    ans11 = a^b;
  end
  initial begin
		$dumpfile("ALU_tb.vcd");
    $dumpvars(0,ALU_tb);
    // control=2'b01;
		a = 64'b0;
		b = 64'b0;

		#20;

    control = 2'b00;
    for(k=0;k<2;k=k+1)
    begin
      a = a+1;
      b=64'b0;
        for(j=0;j<2;j=j+1)
        begin
          b = b+1;
          #20;
        end
    end
    a = 64'b0111111111111111111111111111111111111111111111111111111111111111;
    b = 64'b0111111111111111111111111111111111111111111111111111111111111111;
    #20;

    a = 64'b1000000000000000000000000000000000000000000000000000000000000001;
    b = 64'b1000000000000000000000000000000000000000000000000000000000000001;
    #20;

    control = 2'b01;
    for(k=0;k<2;k=k+1)
    begin
      a = a+1;
      b=64'b0;
        for(j=0;j<2;j=j+1)
        begin
          b = b+1;
          #20;
        end
    end
    a=64'b0111111111111111111111111111111111111111111111111111111111111111;
    b=64'b1111111111111111111111111111111111111111111111111111111111100001;
    #20;

    a=64'b0110010111100000000000000111111111110000110101010101010100000000;
    b=64'b0111111100000000000000000000000000000000000000000000000001010101;
    #20;

    control = 2'b10;
    for(k=0;k<2;k=k+1)
    begin
      a = a+1;
      b=64'b0;
        for(j=0;j<2;j=j+1)
        begin
          b = b+1;
          #20;
        end
    end

    control = 2'b11;
    for(k=0;k<2;k=k+1)
    begin
      a = a+1;
      b=64'b0;
        for(j=0;j<2;j=j+1)
        begin
          b = b+1;
          #20;
        end
    end
	end
	
  initial
		$monitor($time,"\ncontrol=%b\na=%b\nb=%b\nans=%b\noverflow=%b\nans00=%b\nans01=%b\nans10=%b\nans11=%b\n",control,a,b,ans,overflow,ans00,ans01,ans10,ans11);
endmodule