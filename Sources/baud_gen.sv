//our desired baud rate is 57600 bps
//our system clock is 100 MHz
//for RX, we want to sample 16 times per bit period for better accuracy in validating start and stop

module baud_gen (
input logic clk,
input logic rst_n,
input logic rx_mode, 
output logic tick //tick at 16 times the baud rate, so 16*57600 = 921600 Hz

);

//calculated sys clk / baud rate
localparam  DIV_TX= 1736; //100 MHz / 57.6 kHz = 1736.1, round down

//calculated sys clk / (baud rate * 16)
localparam DIV_RX = 109; //100 MHz / (57.6 kHz * 16) = 108.5, round up

//we will use the same baud gen for both tx and rx, just with different divisors, so we can save area by only instantiating one
logic [10:0] counter; //11 bits to count up to 1736 (but can actually reach 2047, but we will reset at 1736 or 109 depending on mode)
logic [10:0]divisor;

assign divisor = rx_mode ? DIV_RX : DIV_TX; //select divisor based on mode, we can use the same baud gen for both tx and rx by just changing the divisor

//counter logic
always_ff @(posedge clk or negedge rst_n) begin : baudCounter
    if (!rst_n) begin
        counter <= 11'b0;
        tick <= 1'b0;
    end else if (counter == divisor - 1) begin //when we reach the divisor, we need to reset the counter and generate a tick
        counter <= 11'b0;
        tick <= 1'b1; //generate a tick
    end else begin
        counter <= counter + 1; //increment counter
        tick <= 1'b0; //keep tick low until we reach the divisor
    end
    
end : baudCounter


endmodule : baud_gen