module PC_increment(in1, out);
  	input [31:0] in1;
    output reg [31:0] out;
  
  	initial begin
      out = 0;
    end
	
  	always@(in1) begin
		out = in1 + 4;
      	//$display("PC incremented value: %0h", out);
	end
endmodule
