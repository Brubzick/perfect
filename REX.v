`timescale 100fs/100fs
module REX (
    input CLOCK,
    input [31:0] RD1,
    input [31:0] RD2,
    input [31:0] instruction,
    output [31:0] RDR1,
    output [31:0] RDR2,
    output [31:0] instructionRR
);

reg [31:0] r1, r2, r3;

always @(RD1,RD2,instruction) begin
    r1 = RD1;
    r2 = RD2;
    r3 = instruction;
    //$display("%b : %b : %b",r1, r2,r3);
end
assign RDR1 = r1;
assign RDR2 = r2;
assign instructionRR = r3;

endmodule