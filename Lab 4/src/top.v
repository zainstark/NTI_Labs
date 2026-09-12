module top

(
    input clk,
    input rst_n,
    input in,
    output [6:0] R,R_c,F,F_c,t,t_c

);


    wire clk_out, 
         rising_tick, 
         falling_tick, 
         edge_tick;

    wire [3:0] falling_count,rising_count,edge_count;



    clk_div #(
        .hz_in(100000),
        .hz_out(100)
    ) divider (
        .clk_in(clk),
        .reset_n(rst_n),
        .clk_out(clk_out)
    );


    edge_detector detector (
        .clk(clk_out),
        .rst_n(rst_n),
        .in(in),
        .rising_tick(rising_tick),
        .falling_tick(falling_tick),
        .edge_tick(edge_tick)

    );


    edge_counter counter (
        .clk(clk_out),
        .rst_n(rst_n),
        .rising_tick(rising_tick),
        .falling_tick(falling_tick),
        .edge_tick(edge_tick),
        .falling_count(falling_count),
        .rising_count(rising_count),
        .edge_count(edge_count)
    );


    seg seg_inst (
        .rst_n(rst_n),
        .rising(rising_count),
        .falling(falling_count),
        .tick(edge_count),
        .R(R),
        .R_c(R_c),
        .F(F),
        .F_c(F_c),
        .t(t),
        .t_c(t_c)
    );
endmodule