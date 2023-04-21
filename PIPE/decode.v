`timescale 1ns / 1ps

module decode(clk,D_stat,D_rA,D_rB,D_icode,D_ifun, D_valC, D_valP,reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14,
E_valA,E_valB, E_stat, E_icode, E_ifun, E_valC,
E_dstE, E_dstM, E_srcA, E_srcB,d_srcA, d_srcB, e_dstE, e_valE, m_valM,M_dstM,M_dstE,M_valE, W_dstM, W_dstE, W_valM, W_valE, E_bubble);
input clk, E_bubble;
input [3:0] D_rA,D_rB,D_icode, D_ifun,M_dstM,M_dstE,W_dstM, W_dstE,e_dstE;
input [63:0]  e_valE, W_valM, W_valE,m_valM, M_valE,D_valC, D_valP, reg0,reg1,reg2,reg3,reg4,reg5,reg6,reg7,reg8,reg9,reg10,reg11,reg12,reg13,reg14;
input [2:0]D_stat;
output reg [2:0] E_stat;
output reg [3:0] E_icode, E_ifun, E_dstE, E_dstM, E_srcA, E_srcB, d_srcA,d_srcB; 
output reg [63:0] E_valA,E_valB, E_valC;

wire [63:0] reg_file_in [0:14];
reg [63:0] d_valA, d_valB, d_tempvalA, d_tempvalB,d_valC;
reg [3:0] d_dstE,d_dstM, d_icode, d_ifun;
reg d_stat;

assign reg_file_in[0] = reg0;
assign reg_file_in[1] = reg1;
assign reg_file_in[2] = reg2;
assign reg_file_in[3] = reg3;
assign reg_file_in[4] = reg4;
assign reg_file_in[5] = reg5;
assign reg_file_in[6] = reg6;
assign reg_file_in[7] = reg7;
assign reg_file_in[8] = reg8;
assign reg_file_in[9] = reg9;
assign reg_file_in[10] = reg10;
assign reg_file_in[11] = reg11;
assign reg_file_in[12] = reg12;
assign reg_file_in[13] = reg13;
assign reg_file_in[14] = reg14;

always@(posedge clk)
begin
#1
    d_icode = D_icode;
    d_ifun  = D_ifun;
    d_valC = D_valC;
    d_stat = D_stat;
    d_srcA = 4'hF;
    d_srcB = 4'hF;
    d_dstE = 4'hF;
    d_dstM = 4'hF;

    if(D_icode == 4'b0010) //cmovxx 2
    begin
        d_tempvalA=reg_file_in[D_rA];
        d_tempvalB = 0;
        d_srcA = D_rA;
        d_dstE = D_rB;
    end

    else if(D_icode == 4'b0011) //irmov 3
    begin
        d_dstE = D_rB;
    end

    else if(D_icode == 4'b0100) //rmmov 4
    begin
        d_tempvalA = reg_file_in[D_rA];
        d_tempvalB = reg_file_in[D_rB];
        d_srcA = D_rA;
        d_srcB = D_rB;
    end

    else if (D_icode == 4'b0101) //mrmov 5
    begin
        d_tempvalB = reg_file_in[D_rB];
        d_srcB = D_rB;
        d_dstM = D_rA;
    end

    else if(D_icode == 4'b0110) //opq 6
    begin
        d_tempvalA = reg_file_in[D_rA];
        d_tempvalB = reg_file_in[D_rB];
        d_srcA = D_rA;
        d_srcB = D_rB;
        d_dstE = D_rB; 
    end

    else if(D_icode == 4'b0111) //jxx 7
    begin
    end

        else if(D_icode == 4'b1000) //call 8
    begin
        d_tempvalB = reg_file_in[4];
        d_srcB = 4;
        d_dstE = 4;
    end

    else if(D_icode == 4'b1001) // ret 9
    begin
        d_tempvalA = reg_file_in[4];
        d_tempvalB = reg_file_in[4];
        d_srcA = 4;
        d_srcB = 4;
        d_dstE = 4;
    end

    else if (D_icode == 4'b1010) //push A
    begin
        d_tempvalA = reg_file_in[D_rA];
        d_tempvalB = reg_file_in[4]; //%rsp
        d_srcA = D_rA;
        d_srcB = 4;
        d_dstE = 4;
    end

    else if(D_icode == 4'b1011) //pop B
    begin
        d_tempvalA = reg_file_in[4]; //%rsp
        d_tempvalB = reg_file_in[4]; //%rsp
        d_srcA = 4;
        d_srcB = 4;
        d_dstE = 4;
        d_dstM = D_rA;
    end

     //values setting for d_valA and d_valB 
     //FORWARDING

         if(D_icode == 4'd8 ||D_icode == 4'd7) //use incremented PC
    begin
        d_valA = D_valP;
        $display("Jump to->%d",d_valA);
    end
    

    else
    begin
    end


    if(D_icode == 4'd8 ||D_icode == 4'd7)
        d_valA = D_valP;
    else if((d_srcA == e_dstE && e_dstE!=4'hF))
        d_valA = e_valE;
    else if(d_srcA == M_dstM && M_dstM!=4'hF)
        d_valA = m_valM;
    else if(d_srcA == M_dstE && M_dstE!=4'hF)
        d_valA=M_valE;
    else if(d_srcA == W_dstM && W_dstM!=4'hF)
        d_valA = W_valM;
    else if(d_srcA == W_dstE && W_dstE!=4'hF)
        d_valA = W_valE;
    else
        d_valA = d_tempvalA;

    // same for updating valB
    if((d_srcB == e_dstE) && e_dstE!=4'hF)
        d_valB = e_valE;
    else if(d_srcB == M_dstM && M_dstM!=4'hF)
        d_valB = m_valM;
    else if(d_srcB == M_dstE && M_dstE!=4'hF)
        d_valB=M_valE;
    else if(d_srcB == W_dstM && W_dstM!=4'hF)
        d_valB = W_valM;
    else if(d_srcB == W_dstE && W_dstE!=4'hF)
        d_valB = W_valE;
    else
        d_valB = d_tempvalB;

end

always @(negedge clk) begin
    if(E_bubble)
    begin
        E_stat <= 4'b1000;
        E_icode <= 4'b0001;
        E_ifun <= 4'b0000;
        E_dstE <= 4'hF;
        E_dstM <= 4'hF;
        E_srcA <= 4'hF;
        E_srcB <= 4'hF;
        E_valA <= 4'b0000;
        E_valB <= 4'b0000;
        E_valC <= 4'b0000;
    end  
    else
    begin
        E_stat <= d_stat;
        E_icode<= d_icode;
        E_ifun <= d_ifun;
        E_dstE <= d_dstE;
        E_dstM <= d_dstM;
        E_srcA <= d_srcA;
        E_srcB <= d_srcB;
        E_valA <= d_valA;
        E_valB <= d_valB;
        E_valC <= d_valC;
    end 
end
endmodule