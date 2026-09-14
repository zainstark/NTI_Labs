module counter #(parameter WIDTH = 5) (

    input  wire             clk,
    input  wire             rst,
    input  wire             load,
    input  wire             enab,
    input  wire [WIDTH-1:0] cnt_in,
    output reg  [WIDTH-1:0] cnt_out

);

    // Function to calculate the next counter value
    function [WIDTH-1:0] counter_next;
        input [WIDTH-1:0] current_count;
        input             load;
        input             enab;
        input [WIDTH-1:0] load_value;

        begin
            if (load)
                counter_next = load_value;
            else if (enab)
                counter_next = current_count + 1'b1;
            else
                counter_next = current_count;
        end
    endfunction


    // Sequential logic
    always @(posedge clk or posedge rst) begin

        if (rst)
            cnt_out <= {WIDTH{1'b0}};

        else
            cnt_out <= counter_next(cnt_out, load, enab, cnt_in);

    end

endmodule
