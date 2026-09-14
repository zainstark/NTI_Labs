module counter #(parameter WIDTH=5)(
    input wire clk,
    input wire rst,
    input wire load,
    input wire enab,
    input wire [WIDTH-1:0] cnt_in,
    output reg [WIDTH-1:0] cnt_out
);


    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt_out <= {(WIDTH){1'b0}};
        end
        else begin
            if (load) begin
                cnt_out <= cnt_in;
            end
            else begin
                if (enab) cnt_out <= cnt_out + 1;
                else cnt_out <= cnt_out;
            end
        end
    end
endmodule