`timescale 100fs/100fs

module alu (
    input CLOCK,
    input signed [31:0] instruction,
    input signed [31:0] RD1,
    input signed [31:0] RD2,
    input signed [31:0] aluoutEX,
    input signed [31:0] aluoutMEM,
    input [1:0] forwardA,
    input [1:0] forwardB,
    output flag,
    output[31:0] instruction_alu,
    output WE,
    output ME,
    output [31:0] WD,
    output signed [31:0] result
); //RD1: [25:21]    RD2: [20:16]

    reg[31:0] regA, regB;
    reg[5:0] op, func;
    reg signed [31:0] a, b, c, INS;
    reg signed [31:0] offset;
    reg signed [31:0] num;
    reg f;
    reg mem_enable;
    reg write_enable;
    always @ (posedge CLOCK) begin
        INS = instruction;
        regA = RD1;
        regB = RD2;
    case (forwardA)
        2'b00: begin
            case (forwardB)
                2'b00: begin
                    regA = RD1;
                    regB = RD2;
                end
                2'b10: begin
                    regA = RD1;
                    regB = aluoutEX;
                end
                2'b01: begin
                    regA = RD1;
                    regB = aluoutMEM;
                end
            endcase
        end 
        2'b10: begin
            case (forwardB)
                2'b00: begin
                    regA = aluoutEX;
                    regB = RD2;
                end
                2'b10: begin
                    regA = aluoutEX;
                    regB = aluoutEX;
                end
                2'b01: begin
                    regA = aluoutEX;
                    regB = aluoutMEM;
                end
            endcase
        end
        2'b01: begin
            case (forwardB)
                2'b00: begin
                    regA = aluoutMEM;
                    regB = RD2;
                end
                2'b10: begin
                    regA = aluoutMEM;
                    regB = aluoutEX;
                end
                2'b01: begin
                    regA = aluoutMEM;
                    regB = aluoutMEM;
                end
            endcase
        end
    endcase
    op = instruction[31:26];
    func = instruction[5:0];
    offset = instruction[15:0];
    f = 1'b0;
    mem_enable  = 1'b0;
    write_enable = 1'b0;
    c = 32'b00000000000000000000000000000000;
    case (op)
        6'b000000: 
            begin
            case (func) 
                6'b100000: begin //add      
                    c = regA + regB;
                end
                6'b100001: begin //addu
                    c = regA + regB;
                end
                6'b100010: begin //sub
                    c = regA - regB;
                end
                6'b100011: begin //subu
                    c = regA - regB;
                end
                6'b100100: begin //and
                    a = regA;
                    b = regB;
                    c = a & b;
                end
                6'b100111: begin //nor
                    a = regA;
                    b = regB;
                    c = a ~| b;
                end
                6'b100101: begin //or
                    a = regA;
                    b = regB;
                    c = a | b;
                end
                6'b100110: begin //xor
                    a = regA;
                    b = regB;
                    c = a ^ b;
                end
                6'b000000: begin //sll
                    a = regB; 
                    b = instruction[10:6];
                    c = a << b;
                end
                6'b000100: begin //sllv
                    a = regB;
                    b = regA;
                    c = a << b;
                end
                6'b000011: begin //sra
                    a = regB;
                    b = instruction[10:6];
                    c = a >>> b;
                end
                6'b000111: begin //srav 
                    a = regB;
                    b = regA;
                    c = a >>> b;
                end
                6'b000010: begin //srl
                    a = regB;
                    b = instruction[10:6];
                    c = a >> b;
                end
                6'b000110: begin //srlv 
                    a = regB;
                    b = regA;
                    c = a >> b;
                end
                6'b101010: begin //slt
                    if (regA < regB) begin
                        c = 32'b00000000000000000000000000000001;
                    end
                    else begin
                        c = 32'b00000000000000000000000000000000;
                    end
                end
                6'b101011: begin //sltu
                    a = regA;
                    b = regB;
                    if (a < b) begin
                        c = 32'b00000000000000000000000000000001;
                    end
                    else begin
                        c = 32'b00000000000000000000000000000000;
                    end
                end
                6'b001000: begin //jr
                    c = regA;
                end
            endcase
            end 
        6'b001000: begin //addi
            b = {{(16){instruction[15]}},instruction[15:0]};
            a = regA;
            c = $signed(a) + $signed(b);
        end
        6'b001001: begin //addiu
            b = {{(16){instruction[15]}},instruction[15:0]};
            a = regA;
            c = $signed(a) + $signed(b);
        end
        6'b001100: begin //andi
            a = regA;
            b = instruction[15:0];
            c = a & b;
        end
        6'b001101: begin //ori
            a = regA;
            b = instruction[15:0];
            c = a | b;
        end
        6'b001110: begin //xori
            a = regA;
            b = instruction[15:0];
            c = a ^ b;
        end
        6'b000100: begin //beq
            a = regA;
            b = regB;
            c = a - b;
            if (c == 32'b00000000000000000000000000000000) begin
                c = offset;
                f = 1'b1;
            end
        end
        6'b000101: begin //bne
            a = regA;
            b = regB;
            c = a-b;
            if (c != 32'b00000000000000000000000000000000) begin
                c = offset;
                f = 1'b1;
            end
        end
        6'b001010: begin //slti
            num = instruction[15:0];
            if (regA < num) c = 32'b00000000000000000000000000000001;       
        end
        6'b001011: begin //sltiu
            a = regA;
            num = instruction[15:0];
            if (a < num) c = 32'b00000000000000000000000000000001;
        end
        6'b100011: begin //lw
            a = regA;
            num = instruction[15:0];
            num = num >> 2;
            c = $signed(a) + $signed(num);
            mem_enable = 1'b1;
        end
        6'b101011: begin //sw
            a = regA;
            num = instruction[15:0];
            num = num >> 2;
            c = $signed(a) + $signed(num);
            mem_enable = 1'b1;
            write_enable = 1'b1;
        end
        6'b000010: begin //j
            c = 32'b00000000000000000000000000000000;
            c[27:2] = instruction[25:0];
        end
        6'b000011: begin //jal
            c = 32'b00000000000000000000000000000000;
            c[27:2] = instruction[25:0];
        end
    endcase
    //$display("%b : %b :%b : %b", c, INS, RD1, RD2);
    end
   
    assign result[31:0] = c[31:0];
    assign flag = f;
    assign instruction_alu[31:0] = INS[31:0];
    assign WE = write_enable;
    assign ME = mem_enable;
    assign WD[31:0] = regB[31:0];
endmodule