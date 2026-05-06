module tx_subsystem(
    input logic clk,
    input logic rst_n,
    input logic [7:0] data_latched,
    input logic [1:0] speed_latched,
    input logic [1:0]size_latched,
    input logic rx_mode,
    input logic en_read,
    
    output logic [7:0] cur_line,
    output logic total_fin,
    output logic led,
    output logic tx_out


);

//internal logic


//from the tx_fsm
logic [1:0] byte_select;
logic start_timer;
logic data_ready;

//from the delay timer
logic timer_fin;

//from the data output mux
logic [7:0] data_out;

//from the byte counter
logic [7:0] cur_line;
logic row_fin;
logic total_fin;

//from the uart tx
logic tx_ready;
logic led;
logic tx_out;




//instantiate the tx_fsm
tx_fsm tx_fsm_inst (
    //inputs
    .clk(clk),
    .rst_n(rst_n),
    .tx_ready(tx_ready),
    .en_data(en_read),
    .timer_done(timer_fin),
    .row_end(row_fin),
    .total_end(total_fin),
    .rx_mode(rx_mode),
    //outputs
    .select_data(byte_select),
    .en_timer(start_timer),
    .data_en(data_ready)

);

//instantiate the delay timer
delay_timer delay_timer_inst (
    //inputs
    .clk(clk),
    .speed_config(speed_latched),
    .en_timer(start_timer),
    //output
    .timer_done(timer_fin)
);

//instantiate the data output mux
data_output_mux data_output_mux_inst (
    //inputs
    .data_in(data_latched),
    .select(byte_select),
    //output
    .mux_out(data_out)
);

//instantiate the byte counter
byte_ctr byte_ctr_inst (
    //inputs
    .clk(clk),
    .rst_n(rst_n),
    .byte_done(tx_ready),
    .size(size_latched),
    //outputs
    .line_out(cur_line),
    .row_done(row_fin),
    .total_done(total_fin)
);

//instantiate the uart tx
uart_tx uart_tx_inst (
    //inputs
    .data(data_out),
    .clk(clk),
    .data_ready(data_ready),
    .en_data(en_read),
    .rst_n(rst_n),
    //outputs
    .tx_ready(tx_ready),
    .led(led),
    .tx_out(tx_out)
);

endmodule