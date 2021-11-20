`include "defs.v"

module control_unit(
	input wire clk,
  input wire [6:0] opcode,
  output reg [2:0] alu_op,
	output reg reg_write_en, alu_src, PC_src, mem_read, mem_write, mem_to_reg
);

  	always@(*) begin
		case(opcode)
			`R_type: begin
              //$display("Control unit: R-type");
              alu_op = `ALU_OP_R_type;
              reg_write_en = 1'b1;
              alu_src = 1'b0;
              PC_src = 1'b0;
              mem_read = 1'b0;
              mem_write = 1'b0;
              mem_to_reg = 1'b0;
			end
			`I_type: begin
              //$display("Control unit: I-type");
              alu_op = `ALU_OP_I_type;
              reg_write_en = 1'b1;
              alu_src = 1'b1;
              PC_src = 1'b0;
              mem_read = 1'b0;		// Earlier this was 1, I have updated it to 0
              mem_write = 1'b0;
              mem_to_reg = 1'b0;
			end          	
			`L_type: begin
              //$display("Control unit: L-type");
              alu_op = `ALU_OP_LW_SW_type;
              reg_write_en = 1'b1;
              alu_src = 1'b1;
              PC_src = 1'b0;
              mem_read = 1'b1;
              mem_write = 1'b0;
              mem_to_reg = 1'b1;
			end
			`S_type: begin
              //$display("Control unit: S-type");
              alu_op = `ALU_OP_LW_SW_type;
              reg_write_en = 1'b0;
              alu_src = 1'b1;
              PC_src = 1'b0;
              mem_read = 1'b0;
              mem_write = 1'b1;
              mem_to_reg = 1'b0;	// This is don't care
			end
			`CB_type: begin
              $display("Control unit: CB-type");
              alu_op = `ALU_OP_CB_type;
              reg_write_en = 1'b0;
              alu_src = 1'b0;
              PC_src = 1'b1;
              mem_read = 1'b0;
              mem_write = 1'b0;
              mem_to_reg = 1'b0;	// This is don't care
			end
          	`LUI_type: begin
              //$display("Control unit: LUI-type");
              alu_op = `ALU_OP_LUI_type;
              reg_write_en = 1'b1;
              alu_src = 1'b1;
              PC_src = 1'b0;
              mem_read = 1'b0;
              mem_write = 1'b0;
              mem_to_reg = 1'b0;
          	end
          	`AUIPC_type: begin
              //$display("Control unit: AUIPC-type");
              alu_op = `ALU_OP_AUIPC_type;
              reg_write_en = 1'b1;
              alu_src = 1'b1;
              PC_src = 1'b0;
              mem_read = 1'b0;
              mem_write = 1'b0;
              mem_to_reg = 1'b0;
          	end
          	`JAL_type: begin
              //$display("Control unit: JAL-type");
//               alu_op = 2'b01;
//               reg_write_en = 1'b0;
//               alu_src = 1'b0;
//               PC_src = 1'b1;
//               mem_read = 1'b0;
//               mem_write = 1'b0;
//               mem_to_reg = 1'b0;
          	end
          	`JALR_type: begin
              //$display("Control unit: JALR-type");
//               alu_op = 2'b01;
//               reg_write_en = 1'b0;
//               alu_src = 1'b0;
//               PC_src = 1'b1;
//               mem_read = 1'b0;
//               mem_write = 1'b0;
//               mem_to_reg = 1'b0;
          	end
          default : begin 
              //$display ("Control unit: No valid operation"); 
              alu_op = 3'b000;
              reg_write_en = 1'b0;
              alu_src = 1'b0;
              PC_src = 1'b0;
              mem_read = 1'b0;
              mem_write = 1'b0;
              mem_to_reg = 1'b0;
          end
		endcase
	end
endmodule
