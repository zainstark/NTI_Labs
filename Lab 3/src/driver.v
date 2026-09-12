module driver #(parameter WIDTH=5)
(
  input data_en,
  input [WIDTH-1:0] data_in,
  output reg [WIDTH-1:0] data_out
);

    always @(*) begin
        if (data_en) begin
            data_out = data_in;
        end else begin
            data_out = {WIDTH{1'bZ}}; 
        end
    end

endmodule