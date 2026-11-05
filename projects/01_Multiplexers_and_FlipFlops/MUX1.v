module MUX1(s0,s1,in0,in1,in2,out_ref);
input s0,s1,in0,in1,in2;
output out_ref;
assign out_ref= ({s0,s1}==2'b00)? in0: ({s0,s1}==2'b01)? in1: ({s0,s1}==2'b10)? in2: 1'b0;
endmodule 