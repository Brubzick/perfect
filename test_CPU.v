`timescale 100fs/100fs

module test_CPU();

reg CLOCK, RESET, ENABLE;
wire[31:0] A, FETCH_ADDRESS, DATA,data,wd3,dataw,rd1,rd2,ir,pc,pcsrc;
wire[64:0] EDIT_SERIAL;
integer i;
reg[31:0] r;
reg[31:0] ins;

parameter clk_period = 10000000000;

initial begin
    CLOCK = 0;
end

always #(clk_period/2) begin
    CLOCK = ~CLOCK;
    RESET = 0;
    ENABLE = 1;
end

CPU testCPU(CLOCK, RESET, ENABLE, A[31:0]);

    
endmodule