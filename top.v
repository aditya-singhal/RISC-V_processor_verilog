/*
 * To branch or not condition will be decided in the MEM stage. The next 3 instructions in the IF, ID and EX stages will be flushed.
 * 
 */

`include "PC.v"
`include "PC_increment.v"
//`include "inst_decompress.v"
`include "instruction_memory.v"
`include "data_memory.v"
`include "control_unit.v"
`include "register_file.v"
`include "ALU_control.v"
`include "ALU.v"
`include "imm_generator.v"
`include "shift_left.v"
`include "mux.v"
`include "adder_32bit.v"
`include "IF_ID.v"
`include "ID_EX.v"
`include "EX_MEM.v"
`include "MEM_WB.v"
`include "hazard_detection_unit.v"
`include "forwarding_unit.v"

module top(clk, PC_enable);
    input clk;
  	input PC_enable;

  	// Instruction fetch stage
    wire [31:0] PC_next;
    wire [31:0] PC_current;
	wire [31:0] PC_incr_by_4_adder_out;
  	wire [31:0] instr_current;
  	wire [31:0] IF_ID_PC_current_out;
    wire [31:0] IF_ID_instr_current;
  	     
  	// Instruction decode stage
    wire [31:0] read_data_1, read_data_2;
  	wire [31:0] immediate_value;
    wire [31:0] write_data;
  	wire [31:0] ID_EX_PC_current_out;
    wire [31:0] ID_EX_read_data_1_out;
    wire [31:0] ID_EX_read_data_2_out;
    wire [31:0] ID_EX_imm_value_out;
    wire ID_EX_reg_write_en_out;
    wire ID_EX_alu_src_out;
    wire ID_EX_PC_src_out;
    wire ID_EX_mem_read;
    wire ID_EX_mem_write_out;
    wire ID_EX_mem_to_reg_out;
  	wire [4:0] ID_EX_alu_control_out;
  	wire [4:0] ID_EX_rd_reg_addr;
  	wire [4:0] ID_EX_rs1_reg_addr;
  	wire [4:0] ID_EX_rs2_reg_addr;

  	// Hazard detection signals
  	wire is_stall;
  	wire is_flush;
  
	// Control signals
  	wire reg_write_en;
    wire ALU_src;
    wire PC_src;
    wire mem_write;
    wire mem_read;
    wire mem_to_reg;
  	wire[4:0] alu_control;
  	wire [2:0]  alu_op;
  
  	// Forwarding signals
  	wire [1:0] forward_A;
  	wire [1:0] forward_B;
  	wire [31:0] mux_data1_fw;
  	wire [31:0] mux_data2_fw;
    
  	// Execution stage
    wire [31:0] shift_by_1_out;
    wire [31:0] PC_plus_immmediate_adder_out;
  	wire [31:0] ALU_result;
  	wire ALU_branch_out;
  	wire [31:0] EX_MEM_instr_adder_out;
  	wire [31:0] EX_MEM_ALU_result_out;
    wire EX_MEM_ALU_branch_out;
  	wire [31:0]  EX_MEM_read_data_2_out;
    wire EX_MEM_reg_write_en_out;
    wire EX_MEM_PC_src_out;
    wire EX_MEM_mem_read_out;
    wire EX_MEM_mem_write_out;
    wire EX_MEM_mem_to_reg_out;
  	wire [4:0] EX_MEM_rd_reg_addr;
  
  	// Memory stage
  	wire [31:0] data_memory_out;
  	wire MEM_WB_mem_to_reg_out;
  	wire MEM_WB_reg_write_en_out;
  	wire [31:0] MEM_WB_instr_current;
  	wire [31:0] MEM_WB_instr_adder_out;
  	wire [31:0] MEM_WB_data_memory_out;
  	wire [31:0] MEM_WB_ALU_result_out;
    wire [31:0] mux_ALU_src_out;
  	wire [4:0] MEM_WB_rd_reg_addr;
    
  	initial begin
      //$display("top initial called");
    	//assign PC_next = 32'b0;
    end

  	// Instruction fetch blocks
  	PC PC_obj(clk, is_stall, PC_next, PC_enable, PC_current);
  	PC_increment PC_increment_adder(PC_current, PC_incr_by_4_adder_out);
  	mux_2x1 mux_PC_src_sel((EX_MEM_PC_src_out & EX_MEM_ALU_branch_out), PC_incr_by_4_adder_out, EX_MEM_instr_adder_out, PC_next);
  	instruction_memory instruction_memory_obj(clk, PC_current, instr_current);
  
  	// IF_ID pipeline register
  	IF_ID if_id_obj(clk, is_stall, is_flush, PC_current, instr_current, IF_ID_PC_current_out, IF_ID_instr_current);
  
  	// Hazard detection unit
    hazard_detection_unit hzrd_detect_obj(ID_EX_mem_read, ID_EX_rd_reg_addr, IF_ID_instr_current[19:15], IF_ID_instr_current[24:20], is_stall);
  	assign is_flush = EX_MEM_PC_src_out & EX_MEM_ALU_branch_out;
  
  	// Decode blocks
  	control_unit control_unit_obj(clk, IF_ID_instr_current[6:0], alu_op, reg_write_en, ALU_src, PC_src, mem_read, mem_write, mem_to_reg);
  	ALU_control_unit alu_control_unit_obj(clk, IF_ID_instr_current[14:12], IF_ID_instr_current[31:25], alu_op, alu_control);
  	register_file registers(clk, MEM_WB_reg_write_en_out, IF_ID_instr_current[19:15], IF_ID_instr_current[24:20], MEM_WB_rd_reg_addr, 
                            write_data, read_data_1, read_data_2);
  	imm_generator immediate_generator(clk, IF_ID_instr_current, immediate_value);    
    
	// ID_EX pipeline register
  	ID_EX id_ex_obj(clk, is_stall, is_flush, IF_ID_instr_current[11:7], IF_ID_instr_current[19:15], IF_ID_instr_current[24:20], IF_ID_PC_current_out, 
                    read_data_1, read_data_2, immediate_value, reg_write_en, ALU_src, PC_src, mem_read, mem_write, mem_to_reg, alu_control,
                    ID_EX_rd_reg_addr, ID_EX_rs1_reg_addr, ID_EX_rs2_reg_addr, ID_EX_PC_current_out, ID_EX_read_data_1_out,
                    ID_EX_read_data_2_out, ID_EX_imm_value_out, ID_EX_reg_write_en_out, ID_EX_alu_src_out, ID_EX_PC_src_out,
                  	ID_EX_mem_read, ID_EX_mem_write_out, ID_EX_mem_to_reg_out, ID_EX_alu_control_out);

  	// Forwarding unit
  	forwarding_unit forwarding_unit_obj(EX_MEM_reg_write_en_out, MEM_WB_reg_write_en_out, EX_MEM_rd_reg_addr, 
										ID_EX_rd_reg_addr, ID_EX_rs1_reg_addr, ID_EX_rs2_reg_addr, MEM_WB_rd_reg_addr,
                                        forward_A, forward_B);
  
  	// Data forwarding
  	mux_3x1 mux_data1_fw_sel(forward_A, ID_EX_read_data_1_out, write_data, EX_MEM_ALU_result_out, mux_data1_fw);
  	mux_3x1 mux_data2_fw_sel(forward_B, ID_EX_read_data_2_out, write_data, EX_MEM_ALU_result_out, mux_data2_fw);
  
  	// Execution stage blocks
  	mux_2x1 mux_ALU_src_sel(ID_EX_alu_src_out, mux_data2_fw, ID_EX_imm_value_out, mux_ALU_src_out);
  	ALU ALU_obj(clk, ID_EX_PC_current_out, mux_data1_fw, mux_ALU_src_out, ID_EX_alu_control_out, ALU_result, ALU_branch_out);    
  	shift_left_32bit shift_left_by_1(ID_EX_imm_value_out, shift_by_1_out);	
  	adder_32bit PC_plus_immmediate_adder(ID_EX_PC_current_out, shift_by_1_out, PC_plus_immmediate_adder_out);
  
  	// EX_MEM pipeline register
  	EX_MEM ex_mem_obj(clk, is_flush, ID_EX_rd_reg_addr, PC_plus_immmediate_adder_out, ALU_result, ALU_branch_out, ID_EX_read_data_2_out,
                      ID_EX_reg_write_en_out, ID_EX_PC_src_out, ID_EX_mem_read, ID_EX_mem_write_out, ID_EX_mem_to_reg_out,
                      EX_MEM_instr_adder_out, EX_MEM_ALU_result_out, EX_MEM_ALU_branch_out, EX_MEM_read_data_2_out, EX_MEM_reg_write_en_out,
                      EX_MEM_PC_src_out, EX_MEM_mem_read_out, EX_MEM_mem_write_out, EX_MEM_mem_to_reg_out, EX_MEM_rd_reg_addr);
  
  	// Memory blocks
  	data_memory data_memory_obj(clk, EX_MEM_mem_read_out, EX_MEM_mem_write_out, EX_MEM_ALU_result_out, EX_MEM_read_data_2_out, data_memory_out);
  	
  	// MEM_WB pipeline register
  	MEM_WB mem_wb_obj(clk, EX_MEM_mem_to_reg_out, EX_MEM_reg_write_en_out, EX_MEM_rd_reg_addr, data_memory_out, EX_MEM_ALU_result_out, 
                      MEM_WB_mem_to_reg_out, MEM_WB_reg_write_en_out,MEM_WB_data_memory_out, MEM_WB_ALU_result_out, MEM_WB_rd_reg_addr);

    // Write back blocks
    mux_2x1 mux_data_out_sel(MEM_WB_mem_to_reg_out, MEM_WB_ALU_result_out, MEM_WB_data_memory_out, write_data);

endmodule
