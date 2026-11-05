`timescale 1ns/1ps

module posedge_detector (
    input  wire clk, rst_n,
    input  wire sig_in,
    output wire pulse_out
);
    reg sig_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) sig_d <= 0;
        else        sig_d <= sig_in;
    end

    assign pulse_out = sig_in & ~sig_d;
endmodule


module cdc_sync_bit #(parameter STAGES = 2)(
    input  wire clk, rst_n,
    input  wire d_async,
    output wire q_sync
);
    integer i;
    reg [STAGES-1:0] chain;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) chain <= 0;
        else begin
            chain[0] <= d_async;
            for (i = 1; i < STAGES; i = i + 1)
                chain[i] <= chain[i-1];
        end
    end

    assign q_sync = chain[STAGES-1];
endmodule


module cdc_pulse_sync #(parameter STAGES = 2)(
    input  wire src_clk, src_rst_n,
    input  wire src_pulse,
    input  wire dst_clk, dst_rst_n,
    output wire dst_pulse
);
    reg src_toggle;
    integer i;
    reg [STAGES:0] dst_chain;

    always @(posedge src_clk or negedge src_rst_n) begin
        if (!src_rst_n)     src_toggle <= 0;
        else if (src_pulse) src_toggle <= ~src_toggle;
    end

    always @(posedge dst_clk or negedge dst_rst_n) begin
        if (!dst_rst_n) dst_chain <= 0;
        else begin
            dst_chain[0] <= src_toggle;
            for (i = 1; i <= STAGES; i = i + 1)
                dst_chain[i] <= dst_chain[i-1];
        end
    end

    assign dst_pulse = dst_chain[STAGES] ^ dst_chain[STAGES-1];
endmodule
