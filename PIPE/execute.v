`include "../ALU/ALU.v"
module execute(clk,valE,cnd,cf_out,icode,ifun,valC,valA,valB,cf_in,
M_valA , M_icode, M_dstE, M_dstM , E_stat ,M_stat , E_dstE, E_dstM,e_dstE, e_valE);

  output reg [63:0] valE, M_valA, e_valE;
  output reg[3:0] M_icode , M_dstE , M_dstM, e_dstE;
  output reg cnd;
  output reg [2:0] cf_out, M_stat;

  input [2:0] E_stat;
  input clk;
  input [3:0] icode,ifun, E_dstE, E_dstM;
  input [63:0] valC,valA,valB;
  input [2:0] cf_in;

  reg [3:0] e_icode, e_dstM;
  reg [63:0] e_valA;
  reg e_stat;

  // setting flags;
  wire zf ,sf,of;
  assign zf = cf_in[0];
  assign sf = cf_in[1];
  assign of = cf_in[2];
  // cf_out will only be set for opq ->icode.
  //We have to set cnd-> for jumpxx, and cmovxx(conditional mov.)

 
  always @(posedge clk)
  begin
    e_stat = E_stat;
    e_icode = icode;
    e_dstM = E_dstM;
    e_valA = valA;
 //setting cnd
cnd=0;
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
            $display("cnd->>%d",cnd);
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
        
        if(icode==2)
        begin
            if(cnd == 1)
                e_dstE = E_dstE;
            else
                e_dstE = 4'hF;
        end
        else
            e_dstE = E_dstE;
    end

    else
        e_dstE = E_dstE;
    
  end

    always @(negedge clk) begin
        M_stat <= e_stat;
            M_icode<= e_icode;
            M_dstM <= e_dstM;
            M_valA <= e_valA;
            M_dstE <= e_dstE;
          M_dstE = cnd ?  e_dstE : 4'hf;
          valE <= e_valE;
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



always @(posedge clk)

begin
    case(icode)
    //cmovq
    4'b0011:
    begin
        e_valE = valC;
    end
    4'b0100,4'b0101:
    begin
        e_valE = valE_cb; //mov's
    end
    4'b0110: //opq.
    begin
        e_valE = valE_op;
        //setting cf_out:zf,sf,of
        // cf_out[0] <= 0;
        if(valE == 0) cf_out[0] <= 1;
        else cf_out[0] <= 0;;
        cf_out[1] <= e_valE[63];//sf//lastbit 1.
        cf_out[2] <= overflow_use;
    end
    4'b0010:e_valE = valE_cmov; //cmovq
    //7 do nothing
    4'b1000 , 4'b1010:e_valE = valE_sd; //call, pushq
    4'b1001 , 4'b1011:e_valE= valE_si; //ret , popq
    default:
        begin
            e_valE = 0;
        end
    endcase
end
endmodule