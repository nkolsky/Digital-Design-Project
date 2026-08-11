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

task automatic send_byte (input logic [7:0] byte_in);
    rx_in = 0;
    #1736;
    for (int i = 0; i < 8; i++) begin
        rx_in = byte_in[i];
        #1736;
    end 
    rx_in = 1;
    #1736;
endtask : send_byte

initial begin
    #5;
    rx_mode = 1;
    send_byte(8'h7B);
    send_byte(8'h52);
    send_byte(8'h30);
    send_byte(8'h31);
    send_byte(8'h32);
end

endmodule
