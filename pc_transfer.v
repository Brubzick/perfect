`timescale 100fs/100fs
module pc_transfer (
    input CLOCK,
    input signed [31:0] pc,
    output signed [31:0] pcout
);

reg signed [31:0] pc1, pc2, pc3,pc4;

always @(posedge CLOCK) begin
pc1 <= pc;
pc2 <= pc1 + 4;
pc3 <= pc2;
pc4 <= pc3; 
end

assign pcout[31:0] = pc4;

endmodule