module stream_parity_generator #(parameter LEN = 8) (
    input  wire clk,
    input  wire rst_n,
    input  wire data_in,
    output reg  parity_out,
    output reg  valid_out
);

    function calculate_parity;
        input [LEN-1:0] data;
        begin
            calculate_parity = ^data;
        end
    endfunction

    function [LEN-1:0] shift_register;
        input [LEN-1:0] data;
        input           new_bit;
        begin
            // Shifts old bits left by 1 and puts new_bit at index 0
            shift_register = {data[LEN-2:0], new_bit};
        end
    endfunction

    reg [LEN-1:0] shift_reg; 
    reg [$clog2(LEN)-1:0] cnt;

    wire [LEN-1:0] shift_reg_next = shift_register(shift_reg, data_in);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg  <= {LEN{1'b0}};
            cnt        <= 0;
            parity_out <= 1'b0;
            valid_out  <= 1'b0;
        end else begin
            shift_reg <= shift_reg_next;

            if (cnt == LEN - 1) begin
                valid_out  <= 1'b1;
                parity_out <= calculate_parity(shift_reg_next); // Calculate over the incoming 8-bit packet
                cnt        <= 0;
            end else begin
                cnt        <= cnt + 1'b1;
                valid_out  <= 1'b0;
            end
        end
    end

endmodule