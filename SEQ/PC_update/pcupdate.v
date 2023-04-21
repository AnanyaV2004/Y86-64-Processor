module pcupdate(clk,icode,cnd,valC,valM,valP,pcnxt);

input [3:0] icode;
input cnd,clk;
input [63:0] valC,valM,valP;
output reg [63:0] pcnxt;

always@(posedge clk)begin
    case(icode)
        4'b0000: pcnxt <= 0;
        4'b0111:
        begin
            if(cnd == 1)
             pcnxt <= valC;
            else
              pcnxt<=valP;
        end
        4'b1000: pcnxt <= valC;
        4'b1001: pcnxt <= valM;
        default:pcnxt<=valP;
    endcase
end
endmodule