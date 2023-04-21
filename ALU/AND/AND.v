module and64bits(A,B,Ans);
    input  signed [63:0]A;
    input  signed [63:0]B;
    output signed  [63:0] Ans;

    genvar i;
    for(i= 0;i<64; i=i+1)begin
        and(Ans[i] , A[i], B[i]);
        // $display(Ans[i]);
        
    end

    //  $monitor($time,"A=%b \n B=%b \n Out=%b\n", A,B, Ans);
      
endmodule
