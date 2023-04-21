module xor64bits(A,B,Ans);
    input [63:0]A;
    input [63:0]B;
    output [63:0]Ans;

    genvar i;
    for(i= 0;i<64; i=i+1)begin
        xor(Ans[i] , A[i], B[i]);
        // $display(Ans[i]);
        
    end

    //$monitor($time,"A=%b \n B=%b \n Out=%b\n", A,B, Ans);
      
endmodule
