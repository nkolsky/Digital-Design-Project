`timescale 1ns/1ps


module phy_tst;
    reg [7:0] data;
    reg clk;
    reg data_ready;
    reg en_data;
    reg rst;
    reg tx_ready; //ready to recive data, goes low when data is being sent
    reg led;
    reg tx_out; //the actual output to the UART, goes high when idle
    reg [3:0] baud;


    UART_PHY UART_PHY_t(
        .data(data),
        .clk(clk),
        .data_ready(data_ready),
        .en_data(en_data),
        .rst(rst),
        .tx_ready(tx_ready),
        .led(led),
        .tx_out(tx_out)
    );

    
    initial clk = 0;
    initial rst = 0;

	always #5 clk = ~clk; //5ns on high, 5ns low total 10ns = 100MHz - equivilent to FPGA
	
    initial begin
        #10;
        rst = 1; #10;
        rst = 0; #10;
        data = 8'h3A; en_data = 1; #10;
        data_ready = 1; #10;
        data_ready = 0; #2000000;
     //   en_data = 0;
    end
endmodule