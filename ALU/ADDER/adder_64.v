`include "../ALU/ADDER/full_adder.v"

module adder_64(a,b,sum,overflow,carry);

input signed [63:0] a;
input signed [63:0] b;

output signed [63:0] sum;
output overflow,carry;

wire [63:0] c0;
assign c0[0]= 1'b0;

genvar i;

generate
for(i=0;i<63;i=i+1)
begin
  
    full_adder testing(.a(a[i]),
    .b(b[i]),
    .c(c0[i]),
    .sum(sum[i]),
    .carry(c0[i+1]));
    // $monitor("%b",sum[i]);

end
endgenerate

full_adder testing(.a(a[63]),
.b(b[63]),
.c(c0[63]),
.sum(sum[63]),
.carry(carry));

xor overflow_flag(overflow , carry,c0[63]);

endmodule