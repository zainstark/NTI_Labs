`timescale 1ns/1ps

module parity_tb;

    reg clk;
    reg rst_n;
    reg data_in;

    wire parity_out;
    wire valid_out;

    localparam LEN = 8;

    stream_parity_generator #(.LEN(LEN)) dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in(data_in),
        .parity_out(parity_out),
        .valid_out(valid_out)
    );


    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task send_byte(input [LEN-1:0] byte_val);
        integer i;
        begin
            for (i = 0; i < LEN; i = i + 1) begin
                data_in = byte_val[i];
                #10;
            end
        end
    endtask

    integer i;
    reg [LEN-1:0] byte_data;

    initial begin
        $dumpfile("parity_tb.vcd");
        $dumpvars(0, parity_tb);

        rst_n   = 0;
        data_in = 0;

        #20;
        @(negedge clk);
        rst_n   = 1; // Release reset cleanly on falling edge


        for (i = 0; i < 2**LEN; i = i + 1) begin
            byte_data = i[LEN-1:0];

            send_byte(byte_data);


            @(posedge clk);
            #1;

            @(negedge clk);
        end

        $finish;
    end

endmodule