module tx_subsystem(
    input logic clk,
    input logic rst_n,
    input logic [7:0] data_latched,
    input logic [2:0] speed_latched,
    input logic size_latched,
    input logic rx_mode,
    output logic [7:0] line_out,
    output logic led,
    output logic tx_out


);

//internal logic

//from the tx_fsm
logic [1:0] select_data;
logic en_timer;
logic data_en;

//from the delay timer
logic timer_done;

//to the data output mux
logic [7:0] data_out;


//from the byte counter 

logic row_end;
logic total_end;

//instantiate the tx_fsm
uart_tx uart_tx_inst (
    //inputs
    .clk(clk),
    .rst_n(rst_n),
    .tx_ready(tx_ready),
    .en_data(en_data),
    .timer_done(timer_done),
    .row_end(row_end),
    .total_end(total_end),
    .rx_mode(rx_mode),
    //outputs
    .select_data(select_data),
    .en_timer(en_timer),
    .data_en(data_en)

);

//instantiate the delay timer
delay_timer delay_timer_inst (
    //inputs
    .clk(clk),
    .speed_config(speed_latched),
    .en_timer(en_timer),
    //output
    .timer_done(timer_done)
);

//instantiate the data output mux
data_output_mux data_output_mux_inst (
    //inputs
    .data_in(data_latched),
    .select(select_data),
    //output
    .mux_out(data_out)
);

//instantiate the byte counter
byte_ctr byte_ctr_inst (
    //inputs
    .clk(clk),
    .rst_n(rst_n),
    .byte_done(byte_done),
    .size(size_latched),
    //outputs
    .line_out(line_out),
    .row_done(row_end),
    .total_done(total_end)
);

//instantiate the uart tx
uart_tx uart_tx_inst (
    //inputs
    .data(data_out),
    .clk(clk),
    .data_ready(data_en),
    .en_data(en_data),
    .rst_n(rst_n),
    //outputs
    .tx_ready(tx_ready),
    .led(led),
    .tx_out(tx_out)
);

endmodule