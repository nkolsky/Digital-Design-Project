`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Design Name: TX Controller
// Module Name: delay_timer
// Project Name: Lab4
//////////////////////////////////////////////////////////////////////////////////

module delay_timer_tst;
    reg clk;
    reg [1:0] speed;
    reg en;
    reg done;

    delay_timer delay_timer_t(
        .clk(clk),
        .speed_config(speed),
        .en_timer(en),
        .timer_done(done)
    );

    initial clk = 0;

	always #5 clk = ~clk; //5ns on high, 5ns low total 10ns = 100MHz - equivilent to FPGA
	
    initial begin
        speed = 2'b01; #20;
        en = 0; #10;
        en = 1; #10;
    end

endmodule