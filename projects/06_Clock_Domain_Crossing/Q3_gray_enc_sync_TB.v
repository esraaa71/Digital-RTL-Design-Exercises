`timescale 1ns/1ps

module gray_enc_sync_TB;

    parameter WIDTH = 8;

    reg  [WIDTH-1:0] tx_data;
    wire [WIDTH-1:0] rx_data;
    reg  tx_clk, rx_clk, rst;
    reg  [WIDTH-1:0] expected_data;

    gray_enc_sync #(
        .WIDTH(WIDTH),
        .RSTTYPE("SYNC")
    ) DUT (
        .tx_data(tx_data),
        .rx_data(rx_data),
        .tx_clk(tx_clk),
        .rx_clk(rx_clk),
        .rst(rst)
    );

    // Clock generation
    initial tx_clk = 0;
    always #5 tx_clk = ~tx_clk;     // 100 MHz

    initial rx_clk = 0;
    always #20 rx_clk = ~rx_clk;    // 25 MHz

    integer i;

    initial begin
        // Initial values
        tx_data = 0;
        expected_data = 0;
        rst = 1;

        // Hold reset for a few cycles in both domains
        repeat(4) @(posedge tx_clk);
        repeat(2) @(posedge rx_clk);
        rst = 0;

        // Check reset behavior after a couple of rx clocks
        repeat(2) @(posedge rx_clk);
        @(negedge rx_clk);
        if (rx_data !== 0)
            $display("ERROR in reset: rx_data = %0h, expected = 00", rx_data);
        else
            $display("PASS: reset");

        // Apply all possible values
        for (i = 0; i < 256; i = i + 1) begin
            @(posedge tx_clk);
            tx_data = i[WIDTH-1:0];
            expected_data = i[WIDTH-1:0];

            // Wait enough time for:
            // binary->gray, synchronizer stages, gray->binary
            repeat(5) @(posedge rx_clk);
            @(negedge rx_clk);

            if (rx_data !== expected_data)
                $display("ERROR: tx_data = %0d, rx_data = %0d", expected_data, rx_data);
        end

        $display("PASS: all values checked");
        #50;
        $stop;
    end

endmodule