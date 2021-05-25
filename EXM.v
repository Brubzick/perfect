`timescale 100fs/100fs

module EXM (
    input CLOCK,
    input signed [31:0] aluout,
    input[31:0] instruction,
    output signed [31:0] aluoutEX,
    output ff,
    output[31:0] instructionEX 
);
reg [31:0] out, IEX;
reg finish;
always @(aluout) begin
    finish = 1'b0;
    out = aluout;
    IEX = instruction;
    if (IEX == 32'b11111111111111111111111111111111) begin
        finish = 1'b1;
    end
    //$display("%b : %b", out, IEX);
end
assign aluoutEX[31:0] = out[31:0];
assign instructionEX[31:0] = IEX[31:0];
assign ff = finish;
endmodule