`timescale 100fs/100fs

module PC (
    input CLOCK,
    input signed [31:0] pcsrc,
    input JF,
    output signed [31:0] pc
);

reg f;
reg signed [31:0] add;
reg signed [31:0] counter;
initial begin
    counter = 0 - 1;
end
always @(posedge CLOCK) begin
    f = JF;
    add = pcsrc;
    if (f == 1'b1) begin
        counter = add;
    end
    else begin
        counter = add + counter;
    end
end
assign pc[31:0] = counter[31:0];
endmodule