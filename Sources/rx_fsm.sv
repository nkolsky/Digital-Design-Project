import rx_fsm_pkg::*;

module rx_fsm (
    input logic clk,
    input logic rst_n,
    input logic tick, //16x baud rate tick_q
    input logic rx_in, //serial data input
    input logic [2:0] bit_cnt, //bit count for current byte being received
    input logic [3:0] byte_cnt, //how many bytes read out of the 16 bytes in the message
    input logic rx_mode, //default to IDLE when low (in TX mode on low, RX mode on high)
    
    //removing the line below because interbit delay is for tx, not rx
    //input logic timer_done, //indicates when the inter-bit delay timer has completed counting

    //moore outputs
    //output logic clr_tick_cntr,
    //output logic run_tick_cntr,
    output logic shift_en, 
    output logic bit_cnt_en,
    output logic byte_cnt_en,
    output logic msg_reg_en,
    output logic parse_en
);    

//Define internal signals
rx_state_t cur_state, next_state;

//Create tick_q counter for validating start and stop bits
logic [3:0] tick_q; //need to count up to 16 ticks (0-15) for validating start and stop bits and knowing when to shift in bits

always_ff @(posedge clk or negedge rst_n) begin : tickCounter
    if (!rst_n) begin
        tick_q <= 4'b0;
    end else if (tick) begin
        tick_q <= tick_q + 1;
    end else begin
        tick_q <= tick_q; //hold value when tick_q is low
    end
    
end : tickCounter


// State Transitions Logic (Sequential)
always_ff @(posedge clk or negedge rst_n) begin : rxStateTransition
    if(!rst_n) begin
        cur_state <= IDLE;
    end else
        cur_state <= next_state;
end : rxStateTransition

// Shift reg for validatingstart bit
logic [2:0] start_window;

always_ff @(posedge clk) begin : validateStartShiftReg
    if (cur_state == VALIDATE_START) begin
        if (tick_q == 4'd7 || tick_q == 4'd8 || tick_q == 4'd9) begin
            start_window <= {start_window[1:0], rx_in};
        end
    end else begin
        start_window <= 3'b111; //default to all 1s when not validating start bit
    end
    
end : validateStartShiftReg

// Shift reg for validating stop bit
logic [2:0] stop_window;

always_ff @(posedge clk) begin : validateStopShiftReg
    if (cur_state == VALIDATE_STOP) begin
        if (tick_q == 4'd7 || tick_q == 4'd8 || tick_q == 4'd9) begin
            stop_window <= {stop_window[1:0], rx_in};
        end
    end else begin
        stop_window <= 3'b000; //default to all 0s when not validating stop bit
    end
    
end : validateStopShiftReg

// Next State Logic (Combinational)
always_comb begin : rx_nextStateLogic
    next_state = cur_state; //default to hold state

    unique case(cur_state)
        IDLE: begin
            if (rx_mode && !rx_in) //if in RX mode and start bit detected
                next_state = VALIDATE_START;
        end
        VALIDATE_START: begin
            if (tick_q == 4'd10) //we passed the middle of the start bit, time to validate our shift reg
            if(|start_window) // if any bit in the start_window is 1, then it's not a valid start bit
                next_state = IDLE;
            else //if all bits in the start_window are 0, then it's a valid start bit
                next_state = READ_TO_REG;
        end
        READ_TO_REG: begin
            if(bit_cnt == 3'd7 && tick_q == 4'd15) //if we've read in all 8 bits of the byte and the tick_q counter is at the center of the bit period
                next_state = VALIDATE_STOP;
            
        end
        VALIDATE_STOP: begin
            if(tick_q == 4'd10) //we passed the middle of the stop bit, time to validate our shift reg
                if(&stop_window) // if all bits in the stop_window are 1, then it's a valid stop bit
                    next_state = UPDATE_BYTE_CNT;
                else //if any bit in the stop_window is 0, then it's not a valid stop bit
                    next_state = IDLE;
        end
        UPDATE_BYTE_CNT: begin
            if(byte_cnt == 4'd15) //if we've received all 16 bytes in the message
                next_state = PARSE_DATA;
            else
                next_state = IDLE; //if we haven't received all 16 bytes, we go back to idle and wait for the next start bit.
                //removing the interbit delay
                //next_state = INTER_BIT_DELAY; //otherwise we need to wait the inter-bit delay before looking for the next start bit
        end
        /*INTER_BIT_DELAY: begin
            if(timer_done)
                if(!rx_in) //if the line is low after the inter-bit delay, that means the next start bit has already begun, so we can start validating it right away
                    next_state = VALIDATE_START;
                else //otherwise we go back to idle and wait for the next start bit
                    next_state = IDLE;
            else 
                next_state = INTER_BIT_DELAY; //otherwise we stay in the inter-bit delay state until the timer is done    
        end*/
        PARSE_DATA: begin
            //check if its enough to pulse en_parse for one cycle here, or if we need to stay in this state until parsing is done
            next_state = IDLE; //after parsing the data, we go back to idle and wait for the next message
        end
        default: begin
            next_state = IDLE;
        end
    endcase
    
end : rx_nextStateLogic

//Moore Output Logic (Sequential)
always_ff @(posedge clk or negedge rst_n) begin : rx_outputLogic
    if(!rst_n) begin //reset button asserted
        clr_tick_cntr <= 1'b0;
        run_tick_cntr <= 1'b0;
        shift_en <= 1'b0;
        bit_cnt_en <= 1'b0;
        byte_cnt_en <= 1'b0;
        msg_reg_en <= 1'b0;
        parse_en <= 1'b0;
    end else begin
        // Default values (stay low unless explicitly set in a state)
        clr_tick_cntr <= 1'b0;
        run_tick_cntr <= 1'b0;
        shift_en      <= 1'b0;
        bit_cnt_en    <= 1'b0;
        byte_cnt_en   <= 1'b0;
        msg_reg_en    <= 1'b0;
        parse_en      <= 1'b0;
    
        case(cur_state)
            IDLE: begin
                clr_tick_cntr <= 1'b1; // Keep tick_q at 0 until start detected
            end
            VALIDATE_START: begin
                run_tick_cntr <= 1'b1; // Start counting ticks to validate start bit at the right time
                //see start_window logic above for how we use the shift reg to validate the start bit at the right time
            end
            READ_TO_REG: begin
                run_tick_cntr <= 1'b1; // Keep counting ticks to know when we're in the middle of the bit period

                // Sample in the middle of the bit period (tick_q == 8) to shift in the bit to the temporary byte shift register
                if (tick_q == 4'd8) begin
                    shift_en <= 1'b1;
                end
                // Update bit count at the end of the bit period (tick_q == 15)
                if(tick_q == 4'd15) begin
                    bit_cnt_en <= 1'b1;
                end
            end
            VALIDATE_STOP: begin
                run_tick_cntr <= 1'b1; // Start counting ticks to validate stop bit at the right time
                //see stop_window logic above for how we use the shift reg to validate the stop bit
            end
            UPDATE_BYTE_CNT: begin
                byte_cnt_en <= 1'b1;
                msg_reg_en <= 1'b1; //latch the byte we just received into the correct position in the message register
                clr_tick_cntr <= 1'b1; //reset tick_q counter to prepare for validating the next start bit after the inter-bit delay
            end
            INTER_BIT_DELAY: begin
                clr_tick_cntr <= 1'b1; //keep tick_q counter at 0 while waiting for the inter-bit delay timer to finish
            end      
            PARSE_DATA: begin
                parse_en <= 1'b1; //enable the parsing of the message after we've received all 16 bytes
            end
        endcase
    end        
end : rx_outputLogic


endmodule : rx_fsm