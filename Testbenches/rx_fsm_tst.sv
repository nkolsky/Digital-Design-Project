`timescale 1ns / 1ps

//didn't understand connections and need to make this work.

module rx_fsm_tst;
//inputs
reg clk;
reg rst_n;
reg tick;
reg rx_in;
reg [2:0] bit_cnt;
reg [3:0] byte_cnt;
reg rx_mode; //tx on low, rx on high
//outputs
reg shift_en;
reg bit_cnt_en;
reg byte_cnt_en;
reg msg_reg_en;
reg parse_en;

//task for bit input from hardware
task automatic input_bit(input logic input_bit);
    rx_in = input_bit;
    bit_cnt = bit_cnt + 1;
endtask : input_bit


//set up the clock
initial clk = 0;
always #5 clk = ~clk;

//task for start baud_gen
task automatic tick_cntrl(input logic pwr);
    tick = 0;
    forever begin
        if (pwr) begin
            #109 tick = 1;
            #10  tick = 0;
        end else begin
            tick = 0;
            @(posedge pwr);    // sleep until pwr goes high
        end
    end
endtask : tick_cntrl

//initiallize a bunch of inputs
initial begin
    rst_n = 1;      //not being reset
    rx_in = 1;      //start bit is low, so rx should start high 
    bit_cnt = 0;    //no bits have entered
    byte_cnt = 0;   //no bytes are complete
    rx_mode = 0;       //starting in tx mode for now
end

rx_fsm rx_fsm_tb(
    .clk(clk),
    .rst_n(rst_n),
    .tick(tick),
    .rx_in(rx_in),
    .bit_cnt(bit_cnt),
    .byte_cnt(byte_cnt),
    .rx_mode(rx_mode),
    //outputs
    .shift_en(shift_en),
    .bit_cnt_en(bit_cnt_en),
    .byte_cnt_en(byte_cnt_en),
    .msg_reg_en(msg_reg_en),
    .parse_en(parse_en)
);

initial begin
    rx_mode = 1;
    #5;
    rx_in = 0; 
    fork 
        tick_cntrl(1); //start bit
    join_none
    #1736;
     rx_in = 1;
    bit_cnt = bit_cnt + 1;
    #1736;
     rx_in = 0;
    bit_cnt = bit_cnt + 1;
    #1736;
     rx_in = 0;
    bit_cnt = bit_cnt + 1;
    #1736;
     rx_in = 1;
    bit_cnt = bit_cnt + 1;
    #1736;
     rx_in = 0;
    bit_cnt = bit_cnt + 1;
    #1736;
     rx_in = 1;
    bit_cnt = bit_cnt + 1;
    #1736;
     rx_in = 1;
    bit_cnt = bit_cnt + 1;
    #1736;
     rx_in = 0;
    bit_cnt = bit_cnt + 1;
    #1736;
     rx_in = 1;
    bit_cnt = bit_cnt + 1;  //end bit
    #1736;
    fork
        tick_cntrl(0);
    join_none
end

endmodule