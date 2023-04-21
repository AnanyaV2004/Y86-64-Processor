`include "../ALU/SUBTRACTOR/full_adder1.v"

module subtractor_64(a,b,difference,overflow,borrow);

input signed [63:0] a;
input signed [63:0] b;

output signed [63:0] difference;
output overflow,borrow;

wire [63:0] c0;
assign c0[0]= 1'b1;

genvar i;
wire signed [63:0] b_temp;

genvar j;
generate
for(j=0; j<64;j = j+1)
begin
    not instq(b_temp[j],b[j]);
end
endgenerate

generate
for(i=0;i<63;i=i+1)
begin
  
    full_adder1 testing(.a(a[i]),
    .b(b_temp[i]),
    .c(c0[i]),
    .sum(difference[i]),
    .carry(c0[i+1]));

end
endgenerate

full_adder1 testing(.a(a[63]),
.b(b_temp[63]),
.c(c0[63]),
.sum(difference[63]),
.carry(borrow));

xor overflow_flag(overflow,borrow,c0[63]);

endmodule