`timescale 1ns/1ps

module mini_soc (
    input wire clk_ctrl,
    input wire clk_wrk,
    input wire rst_n
);
    wire start_pulse_ctrl, start_pulse_wrk;
    wire cmd_valid_ctrl, cmd_valid_wrk, cmd_valid_synced;
    wire cmd_ready;
    wire [7:0] cmd_data_ctrl, cmd_data_wrk;
    wire done_pulse_wrk, done_pulse_ctrl;

    assign cmd_ready    = 1'b1;
    assign cmd_data_wrk = cmd_data_ctrl;

    // Problem 1: start_pulse fast->slow using pulse synchronizer
    cdc_pulse_sync #(.STAGES(2)) u_pulse_sync (
        .src_clk   (clk_ctrl),
        .src_rst_n (rst_n),
        .src_pulse (start_pulse_ctrl),
        .dst_clk   (clk_wrk),
        .dst_rst_n (rst_n),
        .dst_pulse (start_pulse_wrk)
    );

    // Problem 2 step 1: sync cmd_valid level signal with 2-FF
    cdc_sync_bit #(.STAGES(2)) u_bit_sync (
        .clk     (clk_wrk),
        .rst_n   (rst_n),
        .d_async (cmd_valid_ctrl),
        .q_sync  (cmd_valid_synced)
    );

    // Problem 2 step 2: convert level to pulse using posedge detector
    posedge_detector u_pos_detect (
        .clk      (clk_wrk),
        .rst_n    (rst_n),
        .sig_in   (cmd_valid_synced),
        .pulse_out(cmd_valid_wrk)
    );

    // Problem 3: done_pulse slow->fast using pulse synchronizer
    cdc_pulse_sync #(.STAGES(2)) u_pulse_sync2 (
        .src_clk   (clk_wrk),
        .src_rst_n (rst_n),
        .src_pulse (done_pulse_wrk),
        .dst_clk   (clk_ctrl),
        .dst_rst_n (rst_n),
        .dst_pulse (done_pulse_ctrl)
    );

    ctrl_ip u_ctrl (
        .clk        (clk_ctrl),
        .rst_n      (rst_n),
        .start_pulse(start_pulse_ctrl),
        .cmd_valid  (cmd_valid_ctrl),
        .cmd_data   (cmd_data_ctrl),
        .cmd_ready  (cmd_ready),
        .done_pulse (done_pulse_ctrl)
    );

    worker_ip u_worker (
        .clk        (clk_wrk),
        .rst_n      (rst_n),
        .start_pulse(start_pulse_wrk),
        .cmd_valid  (cmd_valid_wrk),
        .cmd_data   (cmd_data_wrk),
        .done_pulse (done_pulse_wrk)
    );

endmodule
