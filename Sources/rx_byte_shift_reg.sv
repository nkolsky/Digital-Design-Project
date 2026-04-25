module rx_byte_shift_reg (
    input logic clk,
    input logic rst_n,
    input logic shift_en, //enable signal for shifting in bits, should only be high during the READ_TO_REG state of the FSM
    input logic rx_in, //serial data input
    output logic [7:0] byte_out //the parallel output of the shift register representing the received byte
);

// Shift register logic for receiving a byte of data
always_ff @(posedge clk or negedge rst_n) begin : byteShiftReg
    if (!rst_n) begin
        byte_out <= 8'b0; //reset shift register output to 0 on reset
    end else if (shift_en) begin
        byte_out <= {rx_in, byte_out[7:1]}; //shift in the new bit from rx_in while shifting the existing bits to the right
     end
end : byteShiftReg

endmodule 