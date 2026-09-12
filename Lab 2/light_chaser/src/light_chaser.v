module light_chaser #(parameter integer WIDTH = 10) (
    input clk,
    input reset_n,
    input hold_n,
    output reg [WIDTH-1:0] out
);

    wire clk_out;

    clk_div #(
        .hz_in(100),
        .hz_out(10)
    ) divider (
        .clk_in(clk),
        .reset_n(reset_n),
        .clk_out(clk_out)
    );

    initial
        out = {1'b1, {(WIDTH-1){1'b0}}};

    always @(posedge clk_out) begin
        if (!reset_n || out == 0)
            out <= {1'b1, {(WIDTH-1){1'b0}}};
        else if (hold_n)
            out <= out >> 1;
    end

endmodule
