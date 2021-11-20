/* 
 * Duty cycle is considered as 50%
 *
 */

`include "defs.v"

module clock_generator(clk_enable, clk);
    input clk_enable;
    output reg clk;
  
  	reg start_clk;
  	real clk_pd = (1.0/(`CLK_FREQ_KHZ * 1e3)) * 1e9;
  
    initial begin 
      clk = 0;
      start_clk = 0;
   	end
  
    always@(posedge clk_enable or negedge clk_enable) begin
      if (clk_enable) begin
        $display("Clock started!");
    	start_clk = 1;
      end else begin
        $display("Clock stopped!");
      	start_clk = 0;
      end
    end
  
    always@(posedge start_clk) begin
      while(start_clk) begin 
        #(clk_pd) clk = ~clk;
        if (clk) begin 
          //$display("Clock rising edge!!");
        end
      end
      $display("Break from while, start_clk = 0 !!");
  	end

endmodule
