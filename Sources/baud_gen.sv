//our desired baud rate is 57600 bps
//our system clock is 100 MHz
//for RX, we want to sample 16 times per bit period for better accuracy in validating start and stop

module baud_gen (
input logic clk,
input logic rst_n,
input logic rx_mode, 
output logic tick_16x //tick at 16 times the baud rate, so 16*57600 = 921600 Hz

);

//calculated sys clk / baud rate
localparam  DIV_TX= 1736; //100 MHz / 57.6 kHz = 1736.1, round down

//calculated sys clk / (baud rate * 16)
localparam DIV_RX = 109; //100 MHz / (57.6 kHz * 16) = 108.5, round up

logic wire divisor;
always_comb begin : div_select
    if(rx_mode) begin
        divisor = DIV_RX;
    end else begin
        divisor = DIV_TX;
    end
end : div_select
//registers for counting


endmodule : baud_gen