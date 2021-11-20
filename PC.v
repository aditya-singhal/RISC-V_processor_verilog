`include "defs.v"

// Todo: Add reset signal implementation

module PC(
	input clock, 
	input is_stall,
  	input [31:0] in,
  	input enable,
    output reg [31:0] out
);
  
  integer is_first_inst = 1;
  always @(posedge clock) begin
      if(enable == 1'b1) begin
        if (is_stall == 0) begin
        	if(is_first_inst == 1) begin out <= `CODE_START_ADDR; is_first_inst = 0; end
        	else begin out <= in; end
          $display("Clock rising edge!");
        end else begin $display("PC: Pipeline is stalled"); end
      end
    end 
endmodule
