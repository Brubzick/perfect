`timescale 100fs/100fs
module Register
(
    input CLOCK,
    input [31:0] pc,
    input [31:0] DATA,
    input [31:0] WD3,
    input [31:0] DATAW,
    output signed [31:0] RD1,
    output signed [31:0] RD2,
    output [31:0] instructionR
);
reg[31:0] pos, pos1, pos2;
reg [1023:0] reg_init;
reg[4:0] R1, R2, R3;
reg[5:0] op, func;
reg WE;
reg [31:0] register [0:31];
integer i;
initial begin
    reg_init = {32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000,32'b00000000000000000000000000000000};
    for (i = 0; i < 32; i = i + 1) begin
        register[i] = reg_init[i*32+:32];
    end
end

always @(negedge CLOCK) begin
    R1 = DATA[25:21];
    R2 = DATA[20:16];
end
always @(posedge CLOCK) begin
    op = DATAW[31:26];
    func = DATAW[5:0];
    case (op)
        6'b000000: begin
            case (func)
                6'b001000: WE = 1'b0;
                default: begin
                    WE = 1'b1;
                    R3 = DATAW[15:11];
                end
            endcase
        end
        6'b000100: WE = 1'b0;//beq
        6'b000101: WE = 1'b0;//bne
        6'b101011: WE = 1'b0;//sw
        6'b000010: WE = 1'b0;//j
        6'b000011: WE = 1'b0;//jal
        default: begin
            WE = 1'b1;
            R3 = DATAW[20:16];
        end
    endcase
    register[R3] = WD3;
    if (op == 6'b000011) begin
        register[15] = pc[31:0];
    end
    //$display("%b : %b : %b : %b",R1, register[R1], R2, register[R2]);
    //if (DATA == 32'b11111111111111111111111111111111) begin
    //   for (i = 0; i < 32; i = i + 1) begin
    //        $display("%b",register[i]);
    //    end
    //   $finish;
    //end
end
assign RD1[31:0] = register[R1];
assign RD2[31:0] = register[R2];
assign instructionR[31:0] = DATA;
endmodule



