`timescale 1ns / 1ps

module baud_gen_tst;
    reg clk;
    reg rst_n;
    reg rx_mode;
    reg baud_start;
    reg tick;

baud_gen baud_gen_tb(
    .clk(clk),
    .rst_n(rst_n),
    .rx_mode(rx_mode),
    .baud_start(baud_start),
    .tick(tick)
);

initial clk = 0;
initial rst_n = 1;
always #5 clk = ~clk;

initial begin
    rx_mode = 0; baud_start = 0; #5;
    rx_mode = 1; #10; 
    baud_start = 1; #10;   
end

endmodule