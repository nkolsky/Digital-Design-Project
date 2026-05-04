module uart_tx (
    input [7:0] tx_data, //8 bit data to be sent out
    input clk, //system clock
    //input data_ready, //
    input en_data, //enable signal to start sending data, should be high when data_ready is high
    input rst_n, //cpu reset, active low
    input rx_mode, // TX mode when low, RX mode when high
    input
    output logic [7:0] row_out,
    output logic tx_ready, //ready to recive data, goes low when data is being sent
    output logic led,
    output logic tx_out
);
endmodule