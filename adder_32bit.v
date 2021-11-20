module adder_32bit (
  input [31:0] in1,
  input [31:0] in2,
  output reg [31:0] out
);
  
  initial begin
    out = 0;
  end

  always@(in1, in2) begin
    out = in1 + in2;
    //$display("Adder in1: %0h, in2: %0h, output: %0h", in1, in2, out);
  end
endmodule
