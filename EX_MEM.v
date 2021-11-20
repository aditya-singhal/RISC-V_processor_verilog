// Signals used for Memory and Write back stage must be used here

`include "defs.v"

module EX_MEM (
  input clk,
  input is_flush,
  input [4:0] rd_reg_addr_in,
  input [31:0] instr_adder_in,
  input [31:0] ALU_result_in,
  input branch_in,
  input [31:0] read_data_2_in,
  input reg_write_en_in,
  input PC_src_in,
  input mem_read_in,
  input mem_write_in,
  input mem_to_reg_in,
  output reg [31:0] instr_adder_out,
  output reg [31:0] ALU_result_out,
  output reg branch_out,
  output reg [31:0] read_data_2_out,
  output reg reg_write_en_out,
  output reg PC_src_out,
  output reg mem_read_out,
  output reg mem_write_out,
  output reg mem_to_reg_out,
  output reg [4:0] rd_reg_addr_out
);
  
  initial begin
  	PC_src_out = 0;
    branch_out = 0;
   	// PC_src_out = 0;	// This is added later on. not verified
  end
  
  integer flush_count = 0;
  always@(posedge clk) begin
    if ((is_flush !== 1'b1) || (flush_count == `MAX_FLUSH_COUNT)) begin // ( !== operator will include x and z condition also)
      instr_adder_out <= instr_adder_in;
      ALU_result_out <= ALU_result_in;
      branch_out <= branch_in;
      read_data_2_out <= read_data_2_in;
      reg_write_en_out <= reg_write_en_in;
      PC_src_out <= PC_src_in;
      mem_read_out <= mem_read_in;
      mem_write_out <= mem_write_in;
      mem_to_reg_out <= mem_to_reg_in;
      rd_reg_addr_out <= rd_reg_addr_in;
      if (flush_count == `MAX_FLUSH_COUNT) begin flush_count = 0; end	// reset flush count value
    end else begin
      // Flushing the last decoded instruction
      $display("EX_MEM: instruction flushed, is_flush: %0d, flush_count: %0d", is_flush, flush_count);
      instr_adder_out <= 0;
      ALU_result_out <= 0;
      branch_out <= 0;
      read_data_2_out <= 0;
      reg_write_en_out <= 0;
      PC_src_out <= 0;
      mem_read_out <= 0;
      mem_write_out <= 0;
      mem_to_reg_out <= 0;
      rd_reg_addr_out <= 0;    
      flush_count = flush_count + 1;
    end
  end
  
endmodule
