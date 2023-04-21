module full_adder1(a,b,c,sum,carry);

input a;
input b;
input c;
output sum;
output carry;

wire o4,o3,o5;

xor a_xor_b(o4,a,b);
and a_and_b(o3,a,b);

xor sum0(sum,o4,c);
and temp(o5,o4,c);

or carry0(carry,o3,o5);

endmodule

