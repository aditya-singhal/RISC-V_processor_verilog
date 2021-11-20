// Signals required in the WB stage are: 
// 1. MemtoReg, which decides between sending the ALU result or the memory value to the register file, and 
// 2. RegWrite, which writes the final value to the register

`include "defs.v"

module MEM_WB (
  input clk,
  input mem_to_reg_in,
  input reg_write_en_in,
  input [4:0] rd_reg_addr_in,
  input [31:0] data_memory_in,
  input [31:0] ALU_result_in,
  output reg mem_to_reg_out,
  output reg reg_write_en_out,
  output reg [31:0] data_memory_out,
  output reg [31:0] ALU_result_out,
  output reg [4:0] rd_reg_addr_out
);
  
  always@(posedge clk) begin
    data_memory_out <= data_memory_in;
    ALU_result_out <= ALU_result_in;
    mem_to_reg_out <= mem_to_reg_in;
    reg_write_en_out <= reg_write_en_in;
    rd_reg_addr_out <= rd_reg_addr_in;
  end
  
endmodule
