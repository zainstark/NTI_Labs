module sequence_detector #(
    parameter OVERLAP = 1'b0
)(

    input clk,
    input rst_n,
    input din,
    output reg detected
);

    typedef enum bit [2:0] {
        S0 = 3'b000, // Initial state
        S1 = 3'b001, // Detected first bit of the sequence
        S2 = 3'b010, // Detected second bit of the sequence
        S3 = 3'b011, // Detected third bit of the sequence
        S4 = 3'b100, // Detected fourth bit of the sequence
        S5 = 3'b101, // Detected fifth bit of the sequence
        S6 = 3'b110  // Detected sixth bit of the sequence (final state)
    } state_t;


    // sequence is 110101

    state_t current_state, next_state;

    // next state logic
    always @(*) begin
        case (current_state)
            S0: begin
                if (din) begin
                    next_state = S1;
                end else begin
                    next_state = S0;
                end
            end
            S1: begin
                if ()
            end
            S2: begin
                if (din) begin

