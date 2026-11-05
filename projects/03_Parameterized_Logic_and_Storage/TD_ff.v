module TD_ff(d, q, qbar, rstn, clk);
    parameter FF_TYPE = "DFF";
    input d, rstn, clk; // d to be used as D input for DFF and Toggle input for TFF
    output reg q, qbar;

    always @(posedge clk or negedge rstn) begin
        if (~rstn) begin
            q <= 1'b0;
            qbar <= 1'b1;
        end
        else begin
            if (FF_TYPE == "DFF") begin
                q <= d;
                qbar <= ~d;
            end
            else if (FF_TYPE == "TFF") begin
                if (d) begin
                    q <= ~q;
                    qbar <= ~qbar;
                end
            end
        end
    end
endmodule
