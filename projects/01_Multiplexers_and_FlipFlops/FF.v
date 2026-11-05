module FF(D, Q, clk, pr_n, E);
    input D, clk, pr_n, E;
    output reg Q;

    always @(posedge clk, negedge pr_n) begin
        if (!pr_n) begin
            Q <= 1'b1;
        end
        else begin
            if (E) begin
                Q <=D ;
            end
            else begin
                Q <= Q;
            end
        end
    end
endmodule