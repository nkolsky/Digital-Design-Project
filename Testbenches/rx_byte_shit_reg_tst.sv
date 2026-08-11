`timescale 1ns / 1ps

module rx_byte_shift_reg_tst;
    reg clk;
    reg rst_n;
    reg shift_en;
    reg rx_in;
    reg [7:0] byte_out;

rx_byte_shift_reg rx_byte_shift_reg_t(
    .clk(clk),
    .rst_n(rst_n),
    .shift_en(shift_en),
    .rx_in(rx_in),
    .byte_out(byte_out)
);

initial clk = 0;
initial rst_n = 1;
always #5 clk = ~clk;

initial byte_out = 8'h00;

initial begin 
    shift_en = 1; rx_in = 1; #10;
    /*shift_en = 1; rx_in = 1; #10;
    shift_en = 1; rx_in = 0; #10;
    shift_en = 1; rx_in = 0; #10;
    shift_en = 1; rx_in = 1; #10;
    shift_en = 1; rx_in = 1; #10;
    shift_en = 1; rx_in = 0; #10;
    shift_en = 1; rx_in = 0; #10;
    shift_en = 1; rx_in = 1; #10;
    shift_en = 1; rx_in = 1; #10;*/
end
endmodule
