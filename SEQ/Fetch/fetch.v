module fetch(
    output reg [3:0] icode,
    output reg [3:0] ifun,
    output reg [3:0] rA,
    output reg [3:0] rB,
    output reg [63:0] valC,
    output reg [63:0] valP,
    output reg mem_error,
    output reg instr_error,
    input clk,
    input [63:0] PC,
    input [0:79] instr
);

    always @* begin
        if (PC > 1023) begin
            mem_error = 1'b1;
        end
        else begin
            mem_error = 1'b0;
        end
        
        icode = instr[0:3];
        ifun = instr[4:7];
        
        case (icode)
            4'b0000, 4'b1001, 4'b0001: begin
                valP = PC + 1;
            end
            4'b0010, 4'b0110, 4'b1010, 4'b1011: begin
                rA = instr[8:11];
                rB = instr[12:15];
                valP = PC + 2;
            end
            4'b0011, 4'b0100, 4'b0101: begin
                rA = instr[8:11];
                rB = instr[12:15];
                valC = instr[16:79];
                valP = PC + 10;
            end
            4'b0111, 4'b1000: begin
                valC = instr[8:71];
                valP = PC + 9;
            end
            default: begin
                instr_error = 1;
            end
        endcase
    end
endmodule
