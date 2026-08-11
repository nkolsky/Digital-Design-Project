`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// Design Name: TX Controller
// Module Name: one_sec_cntr
// Project Name: Lab4

//////////////////////////////////////////////////////////////////////////////////

module one_sec_cntr(
    input clk,
    input rst_n,
    input btn_center,
    input data_done,
    output logic en_data,
    output logic en_config,
    output logic reg_rst
);

 //100 million clock cycles is 1 second, log_2(100,000,000) = ~26.5
    wire [26:0] ONE_SECOND = 10000000;
    
    // count up to one second
    reg [26:0] count;
    
    //senses if a button was pushed and blocks other button pushes
    reg triggered;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        reg_rst <= 1;
    end else begin 
        reg_rst <= 0;           
    end     
end 

always @(posedge clk) begin
    // if reset is detected, we reset everything, including defaulting to decimal
    if(reg_rst) begin
        count <= 0;
        triggered <= 0;
        en_config <= 0;
        en_data <= 0;
    end else if (btn_center) begin //center button is actively being pressed
        if (count < ONE_SECOND) begin //count of btn press is less than 1 sec
            count <= count + 1; //increment count
            en_config <= 0; //keep reg locked
        end else if (!triggered) begin //reach 1 sec and yet to pulse
            en_config <= 1; //pulse to open latch
            en_data <= 1; //now we have reached 1 second, let byte data flow through latch
            triggered <= 1; //confirm pulse sent so no retriggering if held longer
        end else begin //at least 1 second of push btn and already triggered en_config
            en_config <= 0; //lock the config latch again
        end
    end else begin //button is not being pressed
        //reset values
        count <= 0;
        triggered <= 0;
        en_config <= 0;
        if (data_done) begin
            en_data <= 0; //stop letting data flow through latch when the TX controller signals that the data has been sent and the register can be cleared for the next byte
        end
    end
end 
 
endmodule
