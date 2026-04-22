import rx_fsm_pkg::*;

module rx_fsm (
    input logic clk,
    input logic rst_n,
    input logic [3:0] tick, //16x baud rate tick
    input logic rx_in, //serial data input
    input logic [2:0] bit_cnt, //bit count for current byte being received
    input logic [3:0] byte_cnt, //how many bytes read out of the 16 bytes in the message
    input logic sw[15], //default to IDLE when low (in TX mode on low, RX mode on high)

    //moore outputs
    output logic clr_tick_cntr,
    output logic run_tick_cntr,
    output logic shift_en, 
    output logic bit_cnt_en,
    output logic byte_cnt_en,
    output logic msg_reg_en,
    output logic parse_en
);    

//Define internal signals
rx_state_t cur_state, next_state;

// State Transitions Logic (Sequential)
always_ff @(posedge clk or negedge rst_n) begin : rxStateTransition
    if(!rx_n) begin
        cur_state <= IDLE;
    end else
        cur_state <= next_state;
end : rxStateTransition

// Shift reg for validatingstart bit
logic [2:0] start_window;

always_ff @(posedge clk) begin : validateStartShiftReg
    if (cur_state == VALIDATE_START) begin
        start_window <= {start_window[1:0], rx_in};
    end else begin
        start_window <= 3'b111; //default to all 1s when not validating start bit
    end
    
end : validateStartShiftReg

// Next State Logic (Combinational)
always_comb begin : rx_nextStateLogic
    next_state = cur_state; //default to hold state

    case(cur_state)
        IDLE: begin
            if (sw[15] && !rx_in) //if in RX mode and start bit detected
                next_state = VALIDATE_START;
        end
        VALIDATE_START: begin
            if (tick == 4'd10) //we passed the middle of the start bit, time to validate our shift reg
            if(|start_window) // if any bit in the start_window is 1, then it's not a valid start bit
                next_state = IDLE;
            else //if all bits in the start_window are 0, then it's a valid start bit
                next_state = READ_TO_REG;
        end
        READ_TO_REG: begin

            
        end
        VALIDATE_STOP: begin
            
        end
        UPDATE_BYTE_CNT: begin
            
        end
        INTER_BIT_DELAY: begin
            
        end
        PARSE_DATA: begin
            
        end
    
end : rx_nextStateLogic


endmodule : rx_fsm