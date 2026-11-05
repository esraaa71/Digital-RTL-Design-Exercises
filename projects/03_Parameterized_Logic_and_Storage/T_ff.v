module T_ff (t, q, qbar, rstn, clk);
    input t, rstn, clk;
    output reg q, qbar;

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            q <= 1'b0;
            qbar <= 1'b1;
        end
        else if (t) begin
            q <= ~q;
            qbar <= ~qbar;
        end
    end
endmodule
