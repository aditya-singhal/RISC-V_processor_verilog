module mux_2x1 (
	input select,
  	input[31:0] a,
  	input[31:0] b,
	output reg [31:0] y
);
  
  	initial begin
		y = 0;
    end
	
	always@(select,a,b) begin
		case(select)
          1'b0: begin y = a; end
          1'b1: begin y = b; end
		  default: begin y = a;	end			// This must be added
//          1'b0: begin $display ("MUX %m, case: select=0"); y = a; end
//          1'b1: begin $display ("MUX %m, case: select=1"); y = b; end
//           default: begin $display ("MUX %m, default case");	y = a; end
		endcase
	end
endmodule

module mux_3x1 (
  	input [1:0] select,
  	input[31:0] a, 
  	input[31:0] b, 
  	input[31:0] c,
	output reg [31:0] y
);
  
  	initial begin
		y = 0;
    end
	
  	always@(select,a,b,c) begin
		case(select)
          2'b00: begin y = a; end
          2'b01: begin y = b; end
          2'b10: begin y = c; end
          default: begin y = a;	end
            2'b00: begin $display ("MUX case: select=00, %0d", a); y = a; end
//             2'b01: begin $display ("MUX case: select=01, %0d", b); y = b; end
//             2'b10: begin $display ("MUX case: select=10, %0d", c); y = c; end
// 			default: begin $display ("MUX default case: %0d", a); y = a;	end
		endcase
	end
endmodule