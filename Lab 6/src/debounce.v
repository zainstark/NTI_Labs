module debounce #(
    parameter integer TICK_CYCLES = 5
) (
    input wire clk,
    input wire rst_n,
    input wire sw,
    output reg db
);

    typedef enum logic [2:0] {
        zero = 3'b000,
        wait1_1 = 3'b001,
        wait1_2 = 3'b010,
        wait1_3 = 3'b011,
        one = 3'b100,
        wait0_1 = 3'b101,
        wait0_2 = 3'b110,
        wait0_3 = 3'b111    
    } state_t;


    state_t state, next_state;
    
    
    // localparam integer TICK_CYCLES = (CLK_FREQ / 1_000_000_000) * TICK_NS;
    // For 50 MHz and 100 ns this evaluates to 5.

    reg [2:0] tick_count;
    reg m_tick;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            tick_count <= 3'd0;
            m_tick     <= 1'b0;
        end
        else begin
            if (tick_count == TICK_CYCLES - 1) begin
                tick_count <= 3'd0;
                m_tick     <= 1'b1;
            end
            else begin
                tick_count <= tick_count + 1'b1;
                m_tick     <= 1'b0;
            end
        end
    end
    

    // Next state logic

    always @(*) begin
        next_state = state;
        case (state)
            zero: begin
                if (sw) next_state = wait1_1;
            end
            wait1_1: begin
                if (!sw) next_state = zero;
                else if (m_tick) next_state = wait1_2;
            end
            wait1_2: begin
                if (!sw) next_state = zero;
                else if (m_tick) next_state = wait1_3;
            end
            wait1_3: begin
                if (!sw) next_state = zero;
                else if (m_tick) next_state = one;
            end
            one: begin
                if (!sw) next_state = wait0_1;
            end
            wait0_1: begin
                if (sw) next_state = one;
                else if (m_tick) next_state = wait0_2;
            end
            wait0_2: begin
                if (sw) next_state = one;
                else if (m_tick) next_state = wait0_3;
            end
            wait0_3: begin
                if (sw) next_state = one;
                else if (m_tick) next_state = zero;
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) state <= zero;
        else state <= next_state;
    end


    always @(*) begin
        db = 1'b0;
        case (state)
            one: db = 1'b1;
            wait0_1: db = 1'b1;
            wait0_2: db = 1'b1;
            wait0_3: db = 1'b1;
            default: db = 1'b0;
        endcase
    end
            
endmodule