`timescale 1ns/1ps

module tb_mini_soc_no_cdc;
    reg clk_ctrl = 0;
    reg clk_wrk = 0;
    reg rst_n = 0;

    // Clock generation
    always #5 clk_ctrl = ~clk_ctrl;   // 100 MHz
    always #20  clk_wrk  = ~clk_wrk;  // 25 MHz

    // Reset
    initial begin
        rst_n = 0;
        #25;
        rst_n = 1;
    end

    // Instantiate DUT
    mini_soc u_soc (
        .clk_ctrl(clk_ctrl),
        .clk_wrk(clk_wrk),
        .rst_n(rst_n)
    );

    // Run simulation
    initial begin
        #6880 $finish;
    end
endmodule

