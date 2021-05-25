`timescale 100fs/100fs
module contrl_unit (
    input CLOCK,
    input [31:0] DATA,
    output [1:0] forwardA,
    output [1:0] forwardB
);
reg[5:0] op, func;
reg[4:0] numA, numB;
reg[31:0] instruction1, instruction2, instruction3;
reg[1:0] A,B;

always @ (posedge CLOCK) begin
op = DATA[31:26];
func = DATA[5:0];
A = 2'b00;
B = 2'b00;
instruction1 = instruction2;
instruction2 = instruction3;
instruction3 = DATA;
case (op)
    6'b000000: begin //Rtype
        numA = instruction1[15:11] - instruction3[25:21];
        numB = instruction1[15:11] - instruction3[20:16];
        if (numA == 5'b00000) begin
            A = 2'b01;
        end
        if (numB == 5'b00000) begin
            B = 2'b01;
        end
        numA = instruction2[15:11] - instruction3[25:21];
        numB = instruction2[15:11] - instruction3[20:16];
        if (numA == 5'b00000) begin
            A = 2'b10;
        end
        if (numB == 5'b00000) begin
            B = 2'b10;
        end    
    end
    default: begin  //Itype
        numA = instruction1[20:16] - instruction3[25:21];
        if (numA == 5'b00000) begin
            A = 2'b01;
        end
        numA = instruction2[20:16] - instruction3[25:21];
        if (numA == 5'b00000) begin
            A = 2'b10;
        end
    end 
endcase
end
assign forwardA = A[1:0];
assign forwardB = B[1:0];
    
endmodule