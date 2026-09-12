module clk_div #(parameter integer hz_in = 5000000, parameter integer hz_out = 8)(
	input reset_n, clk_in,
	output reg clk_out
);

	parameter integer COUNT_MAX = hz_in / (2 * hz_out);
	integer counter;

	initial clk_out= 1'b1;
	always @(posedge clk_in) begin
		if (!reset_n) begin
			counter <= 0;
			clk_out <= 1'b1;
		end
		else if (counter == COUNT_MAX - 1) begin
			counter <= 0;
			clk_out <= ~clk_out;
		end
		else begin
			counter <= counter + 1'b1;
		end
	end

endmodule
