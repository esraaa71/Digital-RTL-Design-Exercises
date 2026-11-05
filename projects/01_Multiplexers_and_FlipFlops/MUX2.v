module MUX2(s0,s1,in0,in1,in2,out);
input s0,s1,in0,in1,in2;
output reg out;
always @(*) begin 
   case({s0,s1})
        2'b 00: out=in0;
        2'b 01: out=in1;
        2'b 10: out=in2;
       default: out=1'b0;
   endcase 
  end
endmodule
