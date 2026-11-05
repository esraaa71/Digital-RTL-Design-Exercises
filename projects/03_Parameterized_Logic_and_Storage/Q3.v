module Q3(G, D, CLR, Q);
    input G, D, CLR;
    output reg Q;

    always @(*) begin
        if (~CLR)
            Q <= 1'b0;
        else if (G)
            Q <= D;
    end

endmodule
