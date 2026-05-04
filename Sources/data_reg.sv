`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Design Name: TX Controller
// Module Name: data_reg
// Project Name: Lab4
//////////////////////////////////////////////////////////////////////////////////


module data_register(
    input clk, //system clock
    input [14:0] switches,
    input reg_rst, //from 1 sec timer, resets the data register when the button is pushed, regardless of how long it is held for
    input en_data, //from 1 sec timer, allows data to flow through the latch when the button has been held for at least 1 second
    input en_config, //from 1 sec timer, pulses to open the configuration latch when the button has been held for at least 1 second, but only for one clock cycle
    output logic [7:0] latched_data,
    output reg [1:0] size_config, 
    output logic [1:0]speed_config
    );

reg [1:0]size_reg;

    
always @(posedge clk) begin
    if (reg_rst) begin //reset is asserted
        // reset stored values to 0
        latched_data <= 8'h00;
        size_reg <= 2'b00;
        speed_config <= 2'b00;
        
    end else begin
        if (en_config) begin //config is asserted
        //capture current state of inputs
            size_reg <= switches[14:13];
            speed_config <= switches[9:8];
        end 
        if (en_data) begin //data is asserted
            latched_data <= switches[7:0];
        end
    end
end

assign size_config = {2'b00, size_reg};

endmodule
