`include "../ALU/ALU.v"
module execute(valE,cnd,cf_out,icode,ifun,valC,valA,valB,cf_in);

  output reg [63:0] valE;
  output reg cnd;
  output reg [2:0] cf_out;

  input [3:0] icode,ifun;
  input [63:0] valC,valA,valB;
  input [2:0] cf_in;

  // setting flags;
  wire zf ,sf,of;
  assign zf = cf_in[0];
  assign sf = cf_in[1];
  assign of = cf_in[2];

  // cf_out will only be set for opq ->icode.
  //We have to set cnd-> for jumpxx, and cmovxx(conditional mov.)

  //setting cnd
  //   cnd = 0;
  always @*
  begin
      if(icode == 2 || icode == 7)
      //uc,le,l,e,e,ne,ge,g
      begin
          case(ifun)
          4'b0000:
          begin
              cnd = 1;
          end

          4'b0001://le
          begin
              cnd = (sf^of)|zf;
          end

          4'b0010:
          begin
              cnd = of^sf;
          end

          4'b0011:
          begin
              cnd = zf;
          end

          4'b0100:
          begin
              cnd = ~zf;
          end

          4'b0101:
          begin
              cnd = ~(zf^of);
          end
          4'b0110:
          begin
              cnd = ~(zf^of)&(~zf);
          end
          endcase
      end
      else
      cnd=0;
  end

  wire [63:0]valE_op;
  wire [63:0]valE_cmov;
  wire [63:0]valE_si;
  wire [63:0]valE_sd;
  wire [63:0]valE_cb;
  wire overflow, overflow_use;

    //   if(icode == 6) alu ALU_OPQ(ifun , valA,valB, valE_op, overflow_use);
    //   if(icode == 2) alu ALU_cmov(2'b00 , valA,valB, valE_cmov, overflow);
    ALU ALU_OPQ(ifun[1:0] , valA,valB, valE_op, overflow_use); // changed if[2:3]
    ALU ALU_cmov(2'b00 , valA,valB, valE_cmov, overflow);
    ALU stack_inc(2'b00 , 64'd8,valB, valE_si, overflow);
    ALU stack_dec(2'b01 , valB,64'd8, valE_sd, overflow);
    ALU ALU_cb(2'b00 , valC,valB, valE_cb, overflow);


always @*

begin
    case(icode)
    4'b0010:valE = valE_cmov; //cmovq
    4'b0011,4'b0100,4'b0101:valE = valE_cb; //mov's
    4'b0110: //opq.
    begin
        valE = valE_op;
        //setting cf_out:zf,sf,of
        cf_out[0] <= 0;
        if(valE == 0) cf_out[0] <= 1;
        cf_out[1] <= valE[63];//sf//lastbit 1.
        cf_out[2] <= overflow_use;
    end
    //7 do nothing
    4'b1000 , 4'b1010:valE = valE_sd; //call, pushq
    4'b1001 , 4'b1011:valE= valE_si; //ret , popq
    default:valE = 0;
    endcase
end
endmodule