module D_ff(d, q, qn, rstn, clk);
    input d, rstn, clk;
    output reg q, qn;

always @(posedge clk or negedge rstn) begin
    if (~rstn) begin
        q <= 1'b0;
        qn <= 1'b1;
    end
    else begin
        q <= d;
        qn <= ~d;
    end
end

endmodule
