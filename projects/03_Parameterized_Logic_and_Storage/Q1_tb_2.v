module Q1_tb_2();
reg [3:0] in0, in1, out_expected;
wire [3:0] out_DUT;
Q1 #(.OPCODE(2)) DUT(in0, in1, out_DUT);

integer i;
initial begin
    for (i = 0; i < 1000; i = i+1) begin
    in0 = $random;
    in1 = $random;
    out_expected = in0 - in1;
    #10;
    if (out_expected != out_DUT) begin
    $display("Error at time %0t: in0=%b, in1=%b, expected=%b, got=%b", 
              $time, in0, in1, out_expected, out_DUT);
    $stop;
    end
    end
    $stop;
end

initial
$monitor("in0 = %b, in1 = %b, out_expected = %b, out_DUT = %b", 
          in0, in1, out_expected, out_DUT);
endmodule
