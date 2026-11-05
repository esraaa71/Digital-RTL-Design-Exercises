module tb_MUX();
reg s0, s1, in0, in1, in2;
wire out1, out2;
MUX1 dut1 (.s0(s0), .s1(s1), .in0(in0), .in1(in1), .in2(in2), .out_ref(out1));

MUX2 dut2 (.s0(s0), .s1(s1), .in0(in0), .in1(in1), .in2(in2), .out(out2));
integer i;
initial begin 
     for (i=0;i<99;i=i+1) begin 
         s0=$random;
         s1=$random;
         in0=$random;
         in1=$random;
         in2=$random;
	#10;
         if (out1!=out2)begin
            $display ("Error found in this case");
            $stop;
       
          end
       end
       $stop;
   end
endmodule