module memory_test;

  localparam integer AWIDTH = 5;
  localparam integer DWIDTH = 8;

  reg               clk;
  reg               wr;
  reg               rd;
  reg  [AWIDTH-1:0] addr;
  wire [DWIDTH-1:0] data;
  reg  [DWIDTH-1:0] rdata;

  assign data = rdata;

  memory #(
    .AWIDTH (AWIDTH),
    .DWIDTH (DWIDTH)
  ) memory_inst (
    .clk  (clk),
    .wr   (wr),
    .rd   (rd),
    .addr (addr),
    .data (data)
  );


  task expected;
    input [DWIDTH-1:0] exp_data;

    begin
      if (data !== exp_data) begin
        $display("TEST FAILED");
        $display("At time %0d addr=%b data=%b", $time, addr, data);
        $display("data should be %b", exp_data);
        $finish;
      end
      else begin
        $display("At time %0d addr=%b data=%b",
                 $time, addr, data);
      end
    end
  endtask


  task write_memory;
    input [AWIDTH-1:0] write_addr;
    input [DWIDTH-1:0] write_data;

    begin
      $display("Writing addr=%b data=%b",
               write_addr, write_data);

      wr    = 1;
      rd    = 0;
      addr  = write_addr;
      rdata = write_data;

      @(negedge clk);
    end
  endtask


  task read_memory;
    input [AWIDTH-1:0] read_addr;
    input [DWIDTH-1:0] expected_data;

    begin
      $display("Reading addr=%b data=%b",
               read_addr, expected_data);

      wr    = 0;
      rd    = 1;
      addr  = read_addr;
      rdata = 'bz;

      @(negedge clk);

      expected(expected_data);
    end
  endtask


  initial begin
    clk = 0;

    repeat (67) begin
      #5 clk = 1;
      #5 clk = 0;
    end
  end



  initial begin : TEST

    reg [AWIDTH-1:0] addr_count;
    reg [DWIDTH-1:0] data_count;

    // Wait for the first falling edge
    @(negedge clk);


    write_memory(0, -1);
    write_memory(-1, 0);

    read_memory(0, -1);
    read_memory(-1, 0);



    $display("Writing ascending data to descending addresses");

    addr_count = -1;
    data_count = 0;

    while (addr_count) begin

      write_memory(addr_count, data_count);

      addr_count = addr_count - 1;
      data_count = data_count + 1;

    end


    $display("Reading ascending data from descending addresses");

    addr_count = -1;
    data_count = 0;

    while (addr_count) begin

      read_memory(addr_count, data_count);

      addr_count = addr_count - 1;
      data_count = data_count + 1;

    end


    $display("TEST PASSED");
    $finish;

  end

endmodule
