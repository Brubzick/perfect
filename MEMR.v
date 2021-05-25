`timescale 100fs/100fs

module MEMR (
    input CLOCK,
    input signed [31:0] aluout,
    input [31:0] instruction,
    input [31:0] memdata,
    output signed [31:0] aluoutM,
    output [31:0] instructionM
);

reg [5:0] op;
reg [31:0] outdata;
reg [31:0] Ins;
always @(instruction,aluout) begin
    op = instruction[31:26];
    Ins = instruction[31:0];
    case (op)
        100011: begin
            outdata = memdata;
        end
        101011: begin
            outdata = memdata;
        end
        default: begin 
            outdata = aluout;
        end
    endcase
    //$display("%b : %b", outdata, Ins);
end
assign aluoutM[31:0] = outdata[31:0];
assign instructionM[31:0] = Ins[31:0];
endmodule