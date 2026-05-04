module uart_top (
    input logic clk,
    input logic rst_n,
    input logic rx_in,
    input logic rx_mode, // TX mode when low, RX mode when high
    input logic [7:0] data_out,
    input logic [7:0] data_in, //latched data for tx mode
    input logic data_ready, //en_read
    output logic [7:0] row_out,
    output logic [7:0] col_out,
    output logic [7:0] pix_out,

    output logic tx_out,
    output logic led
);

//instatiate the RX Module
uart_rx uart_rx_inst (
    .clk(clk),
    .rst_n(rst_n),
    .rx_in(rx_in),
    .rx_mode(rx_mode),
    .row_out(row_out),
    .col_out(col_out),
    .pix_out(pix_out)
);

//instatiate the TX Module
uart_tx uart_tx_inst (
    .data(data_out), //concatenate row, col, and pix into a single 24 bit data bus for the TX module
    .clk(clk),
    .data_ready(1'b1), //we can just tie data_ready high since we are always ready to send data as soon as we get it from the RX module
    .en_data(1'b1), //we can also tie en_data high since we want to send data as soon as we get it from the RX module
    .rst(rst_n), //active low reset for the TX module, so we need to invert rst_n
    .tx_ready(), //we can ignore this signal since we are always ready to send data
    .led(led),
    .tx_out(tx_out)
);

endmodule