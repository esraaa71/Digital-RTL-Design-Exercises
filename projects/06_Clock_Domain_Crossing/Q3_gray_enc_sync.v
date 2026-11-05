`timescale 1ns/1ps

module binary_to_gray #(parameter WIDTH = 8)(
    input  wire [WIDTH-1:0] binary,
    output wire [WIDTH-1:0] gray
);
    assign gray[WIDTH-1] = binary[WIDTH-1];

    genvar i;
    generate
        for (i = WIDTH-2; i >= 0; i = i - 1) begin : b2g
            assign gray[i] = binary[i+1] ^ binary[i];
        end
    endgenerate
endmodule


module gray_to_binary #(parameter WIDTH = 8)(
    input  wire [WIDTH-1:0] gray,
    output wire [WIDTH-1:0] binary
);
    assign binary[WIDTH-1] = gray[WIDTH-1];

    genvar i;
    generate
        for (i = WIDTH-2; i >= 0; i = i - 1) begin : g2b
            assign binary[i] = binary[i+1] ^ gray[i];
        end
    endgenerate
endmodule


module DFF2_sync #(
    parameter WIDTH   = 8,
    parameter RSTTYPE = "SYNC",
    parameter STAGES  = 2
)(
    input  wire              clk, rst,
    input  wire [WIDTH-1:0]  d_async,
    output wire [WIDTH-1:0]  q_sync
);
    integer i;
    reg [WIDTH-1:0] chain [0:STAGES-1];

    generate
        if (RSTTYPE == "SYNC") begin : sync_rst
            always @(posedge clk) begin
                if (rst) begin
                    for (i = 0; i < STAGES; i = i + 1) chain[i] <= 0;
                end else begin
                    chain[0] <= d_async;
                    for (i = 1; i < STAGES; i = i + 1) chain[i] <= chain[i-1];
                end
            end
        end else begin : async_rst
            always @(posedge clk or posedge rst) begin
                if (rst) begin
                    for (i = 0; i < STAGES; i = i + 1) chain[i] <= 0;
                end else begin
                    chain[0] <= d_async;
                    for (i = 1; i < STAGES; i = i + 1) chain[i] <= chain[i-1];
                end
            end
        end
    endgenerate

    assign q_sync = chain[STAGES-1];
endmodule


module gray_enc_sync #(
    parameter WIDTH   = 8,
    parameter RSTTYPE = "SYNC"
)(
    input  wire [WIDTH-1:0] tx_data,
    output wire [WIDTH-1:0] rx_data,
    input  wire             tx_clk, rx_clk, rst
);
    reg  [WIDTH-1:0] tx_data_r, gray_r;
    wire [WIDTH-1:0] gray_w, gray_synced;

    binary_to_gray #(.WIDTH(WIDTH)) u_b2g (.binary(tx_data_r), .gray(gray_w));

    generate
        if (RSTTYPE == "SYNC") begin : tx_sync
            always @(posedge tx_clk) begin
                if (rst) begin tx_data_r <= 0; gray_r <= 0; end
                else     begin tx_data_r <= tx_data; gray_r <= gray_w; end
            end
        end else begin : tx_async
            always @(posedge tx_clk or posedge rst) begin
                if (rst) begin tx_data_r <= 0; gray_r <= 0; end
                else     begin tx_data_r <= tx_data; gray_r <= gray_w; end
            end
        end
    endgenerate

    // one 2-FF sync per gray bit
    genvar b;
    generate
        for (b = 0; b < WIDTH; b = b + 1) begin : cdc_bits
            DFF2_sync #(.WIDTH(1), .RSTTYPE(RSTTYPE)) u_sync (
                .clk(rx_clk), .rst(rst),
                .d_async(gray_r[b]),
                .q_sync(gray_synced[b])
            );
        end
    endgenerate

    gray_to_binary #(.WIDTH(WIDTH)) u_g2b (.gray(gray_synced), .binary(rx_data));

endmodule
