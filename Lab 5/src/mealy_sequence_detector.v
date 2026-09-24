module sequence_detector_mealy #(
    parameter OVERLAP = 1'b0
)(
    input clk,
    input rst_n,
    input din,
    output reg detected
);

    // State encoding
    parameter S0 = 3'b000;
    parameter S1 = 3'b001;
    parameter S2 = 3'b010;
    parameter S3 = 3'b011;
    parameter S4 = 3'b100;
    parameter S5 = 3'b101;

    reg [2:0] current_state;
    reg [2:0] next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next-state logic
    always @(*) begin

        case (current_state)

            // No bits matched
            S0: begin
                if (din)
                    next_state = S1;
                else
                    next_state = S0;
            end

            // Matched: 1
            S1: begin
                if (din)
                    next_state = S2;
                else
                    next_state = S0;
            end

            // Matched: 11
            S2: begin
                if (din)
                    next_state = S2;
                else
                    next_state = S3;
            end

            // Matched: 110
            S3: begin
                if (din)
                    next_state = S4;
                else
                    next_state = S0;
            end

            // Matched: 1101
            S4: begin
                if (din)
                    next_state = S2;
                else
                    next_state = S5;
            end

            // Matched: 11010
            S5: begin
                if (din) begin
                    // 11010 + 1 = 110101

                    if (OVERLAP)
                        next_state = S1;
                    else
                        next_state = S0;
                end
                else begin
                    next_state = S0;
                end
            end

            default:
                next_state = S0;

        endcase

    end

    // Mealy output
    // Output depends on current state AND input
    always @(*) begin

        if ((current_state == S5) && din)
            detected = 1'b1;
        else
            detected = 1'b0;

    end

endmodule