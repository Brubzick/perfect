`timescale 100fs/100fs
module CPU (
    input CLOCK,
    input RESET,
    input ENABLE,
    output [31:0] A
);
wire[31:0] pc, addr, pct;
wire[31:0] instruction, instructionR, instructionRR, instruction_alu, instructionEX, instructionM;
wire[1:0] forwardA, forwardB;
wire[31:0] RD1, RD2, RDR1, RDR2, write_data;
wire signed [31:0] aluout, aluoutM, aluoutEX, aluoutMEM;
wire jf, bf, we, me,ff;

PC u_1(                             //first stage
    .CLOCK (CLOCK),
    .pcsrc (addr[31:0]),
    .JF (jf),
    .pc (pc[31:0])
);
InstructionRAM u_2(                 //second stage
    .CLOCK (CLOCK),
    .RESET (RESET),
    .ENABLE (ENABLE),
    .FETCH_ADDRESS (pc[31:0]),
    .DATA (instruction[31:0])
);
Register u_3(                      //third stage
    .CLOCK (CLOCK),
    .pc (pct[31:0]),
    .DATA (instruction[31:0]),
    .WD3 (aluoutMEM[31:0]),
    .DATAW (instructionM[31:0]),
    .RD1 (RD1[31:0]),
    .RD2 (RD2[31:0]),
    .instructionR (instructionR[31:0])
);
contrl_unit u_4(                  
    .CLOCK (CLOCK),
    .DATA (instruction[31:0]),
    .forwardA (forwardA[1:0]),
    .forwardB (forwardB[1:0])
);
REX u_11(
    .CLOCK (CLOCK),
   .RD1 (RD1[31:0]),
    .RD2 (RD2[31:0]),
    .instruction (instructionR[31:0]),
    .RDR1 (RDR1[31:0]),
    .RDR2 (RDR2[31:0]),
    .instructionRR (instructionRR[31:0])
);
alu u_5(
    .CLOCK (CLOCK),
    .instruction (instructionRR[31:0]),
    .RD1 (RDR1[31:0]),
    .RD2 (RDR2[31:0]),
    .aluoutEX (aluoutEX[31:0]),
    .aluoutMEM (aluoutMEM[31:0]),
    .forwardA (forwardA[1:0]),
    .forwardB (forwardB[1:0]),
    .flag (bf),
    .instruction_alu (instruction_alu[31:0]),
    .WE (we),
    .ME (me),
    .result (aluout[31:0]),
    .WD (write_data[31:0])
);
contrl2 u_6(                                //forth stage
    .CLOCK (CLOCK),
    .instruction (instruction_alu[31:0]),
    .aluout (aluout[31:0]),
    .flag (bf),
    .JF (jf),
    .pcsrc (addr[31:0])
);
EXM u_7(
    .CLOCK (CLOCK),
    .aluout (aluout[31:0]),
    .instruction (instruction_alu[31:0]),
    .aluoutEX (aluoutEX[31:0]),
    .instructionEX (instructionEX[31:0]),
    .ff (ff)
);
MainMemory u_8(                              //fifth stage
    .CLOCK (CLOCK),
    .RESET (RESET),
    .ENABLE (me),
    .FETCH_ADDRESS (aluoutEX[31:0]),
    .EDIT_SERIAL ({we, aluoutEX[31:0], write_data[31:0]}),
    .finish_flag (ff),
    .DATA (aluoutM[31:0])
);
MEMR u_9(
    .CLOCK (CLOCK),
    .aluout (aluoutEX[31:0]),
    .instruction (instructionEX[31:0]),
    .memdata (aluoutM[31:0]),
    .aluoutM (aluoutMEM[31:0]),
    .instructionM (instructionM[31:0])
);
pc_transfer u_10(
    .CLOCK (CLOCK),
    .pc (pc[31:0]),
    .pcout (pct[31:0])
);

assign A = aluoutMEM[31:0];

endmodule