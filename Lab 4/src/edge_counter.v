module edge_counter
(
    input clk,
    input rst_n,
    input falling_tick,
    input rising_tick,
    input edge_tick,

    output reg [3:0] falling_count,
    output reg [3:0] rising_count,
    output reg [3:0] edge_count
);


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            falling_count <= 4'b0;
            rising_count <= 4'b0;
            edge_count <= 4'b0;
        end else begin
            if (falling_tick) begin
                falling_count <= falling_count + 1;
            end

            if (rising_tick) begin
                rising_count <= rising_count + 1;
            end

            if (edge_tick) begin
                edge_count <= edge_count + 1;
            end
        end
    end

endmodule


