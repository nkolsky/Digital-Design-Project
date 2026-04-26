package rx_fsm_pkg;
    typedef enum logic [2:0] {
        IDLE =              3'b000, 
        VALIDATE_START =    3'b001, 
        READ_TO_REG =       3'b010, 
        VALIDATE_STOP =     3'b011, 
        UPDATE_BYTE_CNT = 3'b100, 
        PARSE_DATA =             3'b101 
        //PARSE_DATA =        3'b110 - we removed the inter-bit delay state
        } rx_state_t;
endpackage : rx_fsm_pkg