module uart_top (
    input clk,
    input rst_n,
    input rx_in,
    input rx_mode,
    input data_latched,
    input size_latched,
    input speed_latched,
    input en_read,
    output logic [7:0] cur_line,
    output logic total_fin,
    output logic led,
    output logic tx_out,
    output logic [7:0] rx_row,
    output logic [7:0] rx_col,
    output logic [7:0] rx_pixel


);

//internal logic from rx
logic led_rx;

//internal logic from tx
logic led_tx;

always_comb begin : led_choice
    if(rx_mode) begin
        led = led_rx;
    end else begin
        led = led_tx;
    end
end : led_choice



//UART rx instantiation
uart_rx u_uart_rx (
    .clk(clk),
    .rst_n(rst_n),
    .rx_in(rx_in),
    .rx_mode(rx_mode), //always in TX mode since this is just the TX top
    .row_out(rx_row),
    .col_out(rx_col),
    .pix_out(rx_pixel),
    .led(led_rx)
);



//instantiate tx subsystem
tx_subsystem u_tx_subsystem (
    .clk(clk),
    .rst_n(rst_n),
    .rx_mode(rx_mode),
    .data_latched(data_latched),
    .size_latched(size_latched),
    .speed_latched(speed_latched),
    .en_read(en_read),
    .cur_line(cur_line),
    .total_fin(total_fin),
    .led(led_tx),
    .tx_out(tx_out)
);

endmodule