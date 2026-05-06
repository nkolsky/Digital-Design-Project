`timescale 1ns / 1ps

module rx_bit_cntr_tst;
    reg clk;
    reg rst_n;
    reg bit_cnt_en;
    reg byte_cnt_en;
    reg clr_bit_cnt;
    
    reg [2:0] bit_cnt;
    reg [3:0] byte_cnt;

rx_bit_cntr rx_bit_cntr_tb(
    .clk(clk),
    .rst_n(rst_n),
    .bit_cnt_en(bit_cnt_en),
    .byte_cnt_en(byte_cnt_en),
    .clr_bit_cnt(clr_bit_cnt),
    .bit_cnt(bit_cnt),
    .byte_cnt(byte_cnt)
);

//tasks for pulsing bit count, byte count and clear bit count
task automatic bit_pulse();    
    bit_cnt_en = 1; #10;
    bit_cnt_en = 0; #10;
endtask : bit_pulse

task automatic byte_pulse();    
    byte_cnt_en = 1; #10;
    byte_cnt_en = 0; #10;
endtask : byte_pulse

task automatic clr_bit_pulse();
    clr_bit_cnt = 1; #10;
    clr_bit_cnt = 0; #10;
endtask : clr_bit_pulse

initial clk = 0;
initial rst_n = 1;
always #5 clk = ~clk;

initial clr_bit_cnt = 0;

initial begin
    #5;
    bit_pulse;
    bit_pulse;
    clr_bit_pulse;
    bit_pulse;
    byte_pulse;
    clr_bit_pulse;
    bit_pulse;
    bit_pulse;
    bit_pulse;
    bit_pulse;
    byte_pulse;
    byte_pulse;
end


endmodule