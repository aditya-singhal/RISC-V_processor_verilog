`include "defs.v"

module ID_EX (
  input clk,
  input is_stall,
  input is_flush,
  input [4:0] rd_reg_addr_in,
  input [4:0] rs1_reg_addr_in,
  input [4:0] rs2_reg_addr_in,
  input [31:0] PC_address_in,
  input [31:0] read_data_1_in,
  input [31:0] read_data_2_in,
  input [31:0] imm_value_in,
  input reg_write_en_in,
  input alu_src_in,
  input PC_src_in,
  input mem_read_in,
  input mem_write_in,
  input mem_to_reg_in,
  input [4:0] alu_control_in,
  output reg [4:0] rd_reg_addr_out,
  output reg [4:0] rs1_reg_addr_out,
  output reg [4:0] rs2_reg_addr_out,  
  output reg [31:0] PC_address_out,
  output reg [31:0] read_data_1_out,
  output reg [31:0] read_data_2_out,
  output reg [31:0] imm_value_out,
  output reg reg_write_en_out,
  output reg alu_src_out,
  output reg PC_src_out,
  output reg mem_read_out,
  output reg mem_write_out,
  output reg mem_to_reg_out,
  output reg [4:0] alu_control_out
);
  
  // ( !== operator will include x and z condition also)
  integer stall_flush_count = 0;
  always@(posedge clk) begin
    if(((is_stall == 0) && ((is_flush !== 1'b1) || (stall_flush_count == `MAX_STALL_COUNT)) )) begin 
        PC_address_out <= PC_address_in;
        read_data_1_out <= read_data_1_in;
        read_data_2_out <= read_data_2_in;
        imm_value_out <= imm_value_in;
        reg_write_en_out <= reg_write_en_in;
        alu_src_out <= alu_src_in;
        PC_src_out <= PC_src_in;
        mem_read_out <= mem_read_in;
        mem_write_out <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        alu_control_out <= alu_control_in;
        rd_reg_addr_out <= rd_reg_addr_in;
        rs1_reg_addr_out <= rs1_reg_addr_in;
        rs2_reg_addr_out <= rs2_reg_addr_in;
      	if (stall_flush_count == `MAX_STALL_COUNT) begin stall_flush_count = 0; end	// reset stall flush count value
	end else begin
        // Flushing the last decoded instruction
      $display("ID_EX: instruction flushed, is_flush: %0d, is_stall: %0d, flush_count: %0d", is_flush, is_stall, stall_flush_count);
// 		$display("ID_EX: Pipeline is stalled"); 
        reg_write_en_out <= 0;
        alu_src_out <= 0;
        PC_src_out <= 0;
        mem_read_out <= 0;
        mem_write_out <= 0;
        mem_to_reg_out <= 0;
        alu_control_out <= 0;
        stall_flush_count = stall_flush_count + 1;
	end
  end
  
endmodule
