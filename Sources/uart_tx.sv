`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2026 02:55:54 PM
// Design Name: 
// Module Name: UART_PHY
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx(
    input [7:0] data,
    input clk,
    input data_ready,
    input en_data,
    input rst,
    output logic tx_ready, //ready to recive data, goes low when data is being sent
    output logic led,
    output logic tx_out //the actual output to the UART, goes high when idle
    );
    
    wire [14:0] divisor = 15'd1736; //clk divided by this gives a rate of 57600, our baud rate    
    reg [14:0] count = 0;
    reg [3:0] counter = 0; //counter for moving through the 8 bits of data we get

    logic run = 0;
    

    initial led = 1'b0;
    initial tx_out = 1'b1;
    initial tx_ready = 1'b1;    
    /*always @(negedge rst) begin
        if (!rst) begin
            led = 1'b0;
            tx_out = 1'b1;
            tx_ready = 1'b1;
        end
    end*/
    
/*always @(en_data) begin
        if(en_data) begin
            led = 1'b0;
            tx_out = 1'b1;
            tx_ready = 1'b1;
        end
    end
        
    always_ff @(data_ready) begin
        if(data_ready &&tx_ready) begin
            tx_out <= 1'b0; // sends start bit
            tx_ready <= 0; // turns off ready to recive data
            counter <= 0; //reset the counter to 0
            count <= 0; //move us to start of the baud counter
        end
    end*/
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            led = 1'b0;
            tx_out = 1'b1;
            tx_ready = 1'b1;
        end else begin
            if (data_ready) begin
                tx_out = 1'b1;
                counter <= 0; //reset the counter to 0
                count <= 0; //move us to start of the baud counter
                run = 1;
            end else if (en_data && tx_ready && run) begin
                led <= !led; //flip LED because new bit is being sent
                tx_ready <= 0; // turns off ready to recive data
                counter <= 0;
            end else if (!tx_ready) begin
                if (count == divisor - 1) begin 
                    count <= 0; //reset clock divider
                    
                    case(counter) //start bit needs to be in Baud
                        4'b0000: tx_out <= 0;        // send start bit
                        4'b0001: tx_out <= data[0];  // send bit 1
                        4'b0010: tx_out <= data[1];  // send bit 2
                        4'b0011: tx_out <= data[2];  // send bit 3
                        4'b0100: tx_out <= data[3];  // send bit 4
                        4'b0101: tx_out <= data[4];  // send bit 5
                        4'b0110: tx_out <= data[5];  // send bit 6
                        4'b0111: tx_out <= data[6];  // send bit 7
                        4'b1000: tx_out <= data[7];  // send bit 8
                        4'b1001: tx_out <= 1'b1;    // send end code
                        4'b1010: begin
                            tx_ready <= 1;  // set to ready to break out of loop
                            run = 0;
                        end

                        default: tx_out <= 1'b1; //default to 'no data'
                    endcase
                    
                    counter <= counter + 1; //allow move to next bit to be sent
                end else begin //count to 17361
                    count <= count + 1;
                end
            end
        end
    end
endmodule
