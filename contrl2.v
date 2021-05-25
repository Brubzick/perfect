`timescale 100fs/100fs

module contrl2 (
    input CLOCK,
    input [31:0] instruction,
    input [31:0] aluout,
    input flag,
    output JF,
    output [31:0] pcsrc
);

reg [5:0] op, func;
reg f; //JF
reg f2;//flag
reg[31:0] addr;
always @(posedge CLOCK) begin
    op = instruction[31:26];
    func = instruction[5:0];
    f = 1'b0;
    f2 = flag;
    case (op)
        6'b000000: begin
            case (func)
                6'b001000: begin
                    f = 1'b1;
                    addr = aluout;
                end
            default: begin
                addr = 32'b00000000000000000000000000000001;
            end
            endcase
        end
        6'b000010: begin
            f = 1'b1;
            addr = aluout;
        end
        6'b000011: begin
            f = 1'b1;
            addr = aluout;
        end
        6'b000100: begin
            if (f2 == 1'b1) begin
                addr = aluout;
            end
            else begin
                addr = 32'b00000000000000000000000000000001;
            end
        end
        6'b000101: begin
            if (f2 == 1'b1) begin
                addr = aluout;
            end
            else begin
                addr = 32'b00000000000000000000000000000001;
            end
        end
        default: begin
            addr = 32'b00000000000000000000000000000001;
        end
    endcase
end
assign JF = f;
assign pcsrc[31:0] = addr[31:0];   
endmodule