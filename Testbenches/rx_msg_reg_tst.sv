`timescale 1ns / 1ps

module rx_msg_reg_tst;
    reg clk;
    reg rst_n;
    reg msg_reg_en;
    reg [3:0] byte_cnt;
    reg [7:0] byte_in;
    reg [127:0] msg_out;  
    
    //set up the clock
    initial clk = 0;
    always #5 clk = ~clk;

    //set up byte counter
    initial byte_cnt = 0;
    always #10 byte_cnt = byte_cnt + 1;

    //set up message in (just going to use a msg = msg + 1 again - this should line it up with the bit cnt)
    initial byte_in = 0;
    always #10 byte_in = byte_in + 1;

    rx_msg_reg rx_msg_reg_tb(
        .clk(clk),
        .rst_n(rst_n),
        .msg_reg_en(msg_reg_en),
        .byte_cnt(byte_cnt),
        .byte_in(byte_in),
        .msg_out(msg_out)
    );

    initial begin
        #5;
        msg_reg_en = 1; #1000;
        msg_reg_en = 0;
    end


endmodule