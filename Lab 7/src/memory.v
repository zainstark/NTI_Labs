module memory #(
    parameter AWIDTH = 8,
    parameter DWIDTH = 8
)(
    input wire clk,
    input wire [AWIDTH-1:0] addr,
    input wire wr,
    input wire rd,
    inout wire [DWIDTH-1:0] data
);

    reg [DWIDTH-1:0] mem [0:(1<<AWIDTH)-1];

    reg [DWIDTH-1:0] data_reg;
    assign data = (rd) ? data_reg : {DWIDTH{1'bz}};

    always @(posedge clk) begin
        if (wr) begin
            mem[addr] <= data;
        end
        if (rd) begin
            data_reg <= mem[addr];
        end
    end

endmodule