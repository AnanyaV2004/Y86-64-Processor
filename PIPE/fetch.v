module fetch(
    output reg [3:0] icode, 
    output reg [3:0] ifun,
    output reg [3:0] rA,
    output reg [3:0] rB,
    output reg [63:0] valC,
    output reg [63:0] valP,
    input clk,
    input [63:0] PC,                 //PC value we predicted in the previous stage
    output reg [63:0] temp_pred_pc,
    input [0:79] instr,
    output reg [2:0] D_stat,
    output reg [63:0]pred_pc,        //PC value we predict for the next stage
    input F_stall,
    input D_bubble,
    input D_stall,
    input [63:0]W_valM,
    input [3:0]M_icode,
    input [3:0]W_icode,
    input M_cnd,
    input [63:0] M_valA,
    input [63:0]jump_instr_pred,
    input jump_instr_cnd
);

reg [3:0]f_icode,f_ifun,f_rA,f_rB;
reg [63:0] f_valC, f_valP;

    always @(posedge clk)begin

        if (PC > 1023) begin 
            D_stat[2] = 1'b1; // mem/instruction error (INS/ADR)
            D_stat[0] = 1'b0; // not AOK 
        end

        else begin
            D_stat[0] = 1'b1; // AOK
            D_stat[1] = 1'b0; //no HLT
            D_stat[2] = 1'b0; //no mem, inst error. (INS/ADR)
        end

        f_icode = instr[0:3];
        f_ifun = instr[4:7];
        
        case (f_icode)
            4'b1001, 4'b0001: begin
                f_valP = PC + 1;
                temp_pred_pc = PC+1;
            end
            4'b0000: begin
                f_valP = PC+1;
                temp_pred_pc = PC+1;
                D_stat[1] = 1'b1;
            end
            4'b0010, 4'b0110, 4'b1010, 4'b1011: begin
                f_rA = instr[8:11];
                f_rB = instr[12:15];
                f_valP = PC + 2;
                temp_pred_pc = PC+2;
            end
            4'b0011, 4'b0100, 4'b0101: begin
                f_rA = instr[8:11];
                f_rB = instr[12:15];
                f_valC = instr[16:79];
                f_valP = PC + 10;
                temp_pred_pc= PC+10;
                
            end
            4'b0111, 4'b1000: begin
                f_valC = instr[8:71];
                f_valP = PC + 9;
                temp_pred_pc = instr [8:71];
            end
            default: begin
                D_stat[0] = 1'b0; //not OKAY
                D_stat[2] = 1'b1; //instr error
            end
        endcase

        end
    
    // end 

always@(negedge clk)
begin

       if(F_stall)
        begin
            pred_pc =   PC;
            $display("F_stall");
            
        end

        if(D_stall)
        begin 
            $display("D_stall");
            //do nothing
        end
      
     

        if(D_bubble)
        begin
            if(jump_instr_cnd)
            pred_pc = jump_instr_pred;
            $display("%d, D_bubble, pred_pc:%d",clk,pred_pc);
            icode <= 4'b0001;
            ifun <= 4'b0000;
            rA <= 4'b0000;
            rB <= 4'b0000;
            valC <= 64'b0;
            valP <= 64'b0;
            D_stat <= 3'b001; //INS/ADR HLT AOK
        end

        if(!F_stall && !D_bubble && !D_stall)
        begin    
            rA<=f_rA;
            rB<=f_rB;
            icode = f_icode;
            ifun = f_ifun;
            valC = f_valC;
            valP = f_valP;
            if(jump_instr_cnd)
            pred_pc = jump_instr_pred;
            else
            pred_pc = temp_pred_pc;
        end
end

endmodule