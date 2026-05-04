import rx_fsm_pkg::*;

module uart_rx (
    input logic clk,
    input logic rst_n,
    input logic rx_in,
    input logic rx_mode, // TX mode when low, RX mode when high

    output logic [7:0] row_out,
    output logic [7:0] col_out,
    output logic [7:0] pix_out
);

//internal signals



endmodule