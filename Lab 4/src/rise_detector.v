module rise_detector (
    input wire clk,
    input wire rst_n,
    input wire in,
    output reg rise_edge
);



    typedef enum bit [1:0] {
        LOW = 2'b00,
        RISE = 2'b01,
        HIGH = 2'b10
    } state_t;


    state_t state, next_state;



    always @(*) begin
        case (state)
            LOW: begin
                if (in) begin
                    next_state = RISE;
                end else begin
                    next_state = LOW;
                end
            end

            RISE: begin
                if (in) begin
                    next_state = HIGH;
                end else begin
                    next_state = LOW;
                end
            end

            HIGH: begin
                if (in) begin
                    next_state = HIGH;
                end else begin
                    next_state = LOW;
                end
            end

            default: begin
                next_state = LOW;
            end
        endcase
    end


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= LOW;
        end else begin
            state <= next_state;
        end
    end


    always @(*) begin
        case (state)
            LOW: begin
                rise_edge = 1'b0;
            end

            RISE: begin
                rise_edge = 1'b1;
            end

            HIGH: begin
                rise_edge = 1'b0;
            end

            default: begin
                rise_edge = 1'b0;
            end
        endcase
    end

endmodule




