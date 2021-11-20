// Todo: Handle negatinve numbers
// Should I have to store the results in 2' s complements.
// This is done by the compiler level or at the processor level
// Similarly with Endianess?

// Read the RISC-V manual and try to understand the instruction formats from there as well
// Add some more instructions
// Create a separate file for the instructions
// Start adding the pipeline part
// Initialize compiler
// Try passing timescale in Run time option: Understand this

// Branch: 4 cycles
// Store: 4 cycles
// All other: 5 cycles

`include "clock.v"
`include "top.v"

`define TOTAL_INSTRCUTIONS		20

module testbench();
  wire clk;
  reg clk_enable;
  wire PC_enable;
  
  initial begin
    clk_enable = 1;
    //display;
  end
  
  clock_generator clock_gen_obj(clk_enable, clk);
  top top_obj(clk, PC_enable);
  assign PC_enable = 1;
 
  integer i = 0;
  always@(posedge clk) begin 
  	i = i+1;
    if (i == `TOTAL_INSTRCUTIONS) begin clk_enable = 0; end
  end
  
//   always begin
//     #7 display;
//   end
  
  task display;
    $display("clk_enable: %0h, Initial clk: %0h", clk_enable, clk);
  endtask
  
endmodule