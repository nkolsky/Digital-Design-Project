`timescale 1ns / 1ps

module uart_rx_tst;
    reg clk;
    reg rst_n;
    reg rx_in;
    reg rx_mode;
    reg [7:0] row_out;
    reg [7:0] col_out;
    reg [7:0] pix_out;
    reg led;

initial clk = 0;
initial rst_n = 1;
always #5 clk = ~clk;

uart_rx uart_rx_tb(
    .clk(clk),
    .rst_n(rst_n),
    .rx_in(rx_in),
    .rx_mode(rx_mode),
    .row_out(row_out),
    .col_out(col_out),
    .pix_out(pix_out),
    .led(led)
);

initial begin
    #5;
    rx_mode = 1; rx_in = 0;
end

endmodule
