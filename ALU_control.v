// This is level 2 of instruction decoding, alu_op is generated from the 1st level of decoding
// At this level ALU control is generated which is the input for ALU

`include "defs.v"

module ALU_control_unit(
  input clk,
  input [2:0] func3,
  input [6:0] func7,
  input [2:0] alu_op,
  output reg [4:0] alu_control
);

  always@(*) begin
    if (alu_op == `ALU_OP_I_type) begin 
      case(func3)
        `FUNC3_OP_ADD  : begin alu_control = `ALU_CONTROL_ADD;  end
        `FUNC3_OP_SLT  : begin alu_control = `ALU_CONTROL_SLT;  end
        `FUNC3_OP_SLTU : begin alu_control = `ALU_CONTROL_SLTU; end  
        `FUNC3_OP_XOR  : begin alu_control = `ALU_CONTROL_XOR;  end
        `FUNC3_OP_OR   : begin alu_control = `ALU_CONTROL_OR;   end
        `FUNC3_OP_AND  : begin alu_control = `ALU_CONTROL_AND;  end
        `FUNC3_OP_SLLI : begin alu_control = `ALU_CONTROL_SLLI;  end
        `FUNC3_OP_SRLI_SRAI : begin alu_control = `ALU_CONTROL_SRLI_SRAI;  end
      endcase
    end
    else if (alu_op == `ALU_OP_LW_SW_type) begin alu_control = `ALU_CONTROL_ADD; end 
    else if (alu_op == `ALU_OP_CB_type) begin
        case(func3)
          `FUNC3_OP_BEQ: begin alu_control  = `ALU_CONTROL_B_EQUAL; end
          `FUNC3_OP_BNE: begin alu_control  = `ALU_CONTROL_B_NOT_EQ; end
          `FUNC3_OP_BLT: begin alu_control  = `ALU_CONTROL_B_LT; end
          `FUNC3_OP_BGE: begin alu_control  = `ALU_CONTROL_B_GE; end
          `FUNC3_OP_BLTU: begin alu_control = `ALU_CONTROL_B_LTU; end
          `FUNC3_OP_BGEU: begin alu_control = `ALU_CONTROL_B_GEU; end
        endcase
    end   
    else if (alu_op == `ALU_OP_R_type) begin
      if (func7 == `FUNC7_OP_0) begin
        case(func3)
          `FUNC3_OP_ADD: begin alu_control  = `ALU_CONTROL_ADD; end
          `FUNC3_OP_SLL: begin alu_control  = `ALU_CONTROL_SLL; end
          `FUNC3_OP_SLT: begin alu_control  = `ALU_CONTROL_SLT; end
          `FUNC3_OP_SLTU: begin alu_control = `ALU_CONTROL_SLTU; end
          `FUNC3_OP_XOR: begin alu_control  = `ALU_CONTROL_XOR; end
          `FUNC3_OP_SRL: begin alu_control  = `ALU_CONTROL_SRL; end
          `FUNC3_OP_OR: begin alu_control   = `ALU_CONTROL_OR; end
          `FUNC3_OP_AND: begin alu_control  = `ALU_CONTROL_AND; end
          default: begin $display("ALU_control: No valid value for func3"); end
        endcase
      end else if (func7 == `FUNC7_OP_1) begin 
        case(func3)
          `FUNC3_OP_SUB: begin alu_control = `ALU_CONTROL_SUB; end
          `FUNC3_OP_SRA: begin alu_control = `ALU_CONTROL_SRA; end
          default: begin $display("ALU_control: No valid value for func3"); end
        endcase       
      end      
    else if (alu_op == `ALU_OP_LUI_type) begin
      alu_control = `ALU_CONTROL_LUI;
    end
    else if (alu_op == `ALU_OP_AUIPC_type) begin
      alu_control = `ALU_CONTROL_AUIPC;
    end
    else begin $display("ALU_control: No valid value for func3 and func7"); end
	end
   end
endmodule
