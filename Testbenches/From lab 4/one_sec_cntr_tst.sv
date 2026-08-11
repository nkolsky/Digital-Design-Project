`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Design Name: TX Controller
// Module Name: one_sec_cntr
// Project Name: Lab4

//////////////////////////////////////////////////////////////////////////////////

module one_sec_cntr_tst;
    reg clk;
    reg rst;
    reg btn_center;
    reg data_done;
    reg en_data;
    reg en_config;
    reg reg_rst;

    one_sec_cntr one_sec_cntr_t(
        .clk(clk),
        .rst_n(rst),
        .btn_center(btn_center),
        .data_done(data_done),
        .en_data(en_data),
        .en_config(en_config),
        .reg_rst(reg_rst)
    );

    initial clk = 0;
    initial rst = 0; 

	always #5 clk = ~clk; //5ns on high, 5ns low total 10ns = 100MHz - equivilent to FPGA

    initial begin
        rst = 0; data_done = 0; #10;
        rst = 1; #10;
        btn_center = 1; #200;
        //btn_center = 0; #20;    
        rst = 0; #200;
        rst = 1; data_done = 0; #10;
    end


endmodule