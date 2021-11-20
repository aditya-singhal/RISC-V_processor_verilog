`include "defs.v"

module ALU (
  	input clock,
  	input [31:0] PC_current,
	input [31:0] data1, data2,
  	input [4:0] alu_control,
	output reg [31:0] result,
	output reg branch
);
  
  always@(*) begin 
    case (alu_control)
      //`ALU_CONTROL_ADD  : begin result = data1 + data2; $display ("data1: %0d, data2: %0d, Result: %0d", data1, data2, result); end
      //`ALU_CONTROL_SUB  : begin result = data1 - data2; $display ("data1: %0d, data2: %0d, Result: %0d", data1, data2, result); end
      `ALU_CONTROL_ADD  : begin result = data1 + data2; end
      `ALU_CONTROL_SUB  : begin result = data1 - data2; end
      `ALU_CONTROL_SLL  : begin result = data1 << data2; end
      `ALU_CONTROL_SLT  : begin if (data1 < data2) begin result = 1; end else begin result = 0; end end
      `ALU_CONTROL_SLTU : begin if (data1 < data2) begin result = 1; end else begin result = 0; end end
      `ALU_CONTROL_XOR  : begin result = data1 ^ data2; end
      `ALU_CONTROL_SRL  : begin result = data1 >> data2; end
      `ALU_CONTROL_SRA  : begin result = data1 >>> data2; end
      `ALU_CONTROL_OR   : begin result = data1 | data2; end
      `ALU_CONTROL_AND  : begin result = data1 & data2; end
      `ALU_CONTROL_SLLI	: begin result = data1 << data2[4:0]; end
      `ALU_CONTROL_SRLI_SRAI : begin if (data2[11:5] == `IMM_CODE_SRLI) begin result = data1 >> data2[4:0]; end 
        							 else if (data2[11:5] == `IMM_CODE_SRAI) begin result = data1 >>> data2[4:0]; end end
      `ALU_CONTROL_LUI   : begin result = data2; end
      `ALU_CONTROL_AUIPC : begin result = PC_current + data2; end

      `ALU_CONTROL_B_EQUAL	: begin if (data1 == data2) begin branch = 1; end else begin branch = 0; end end
      `ALU_CONTROL_B_NOT_EQ : begin if (data1 != data2) begin branch = 1; end else begin branch = 0; end end
      `ALU_CONTROL_B_LT		: begin if (data1 < data2) begin branch = 1; end else begin branch = 0; end end
      `ALU_CONTROL_B_GE		: begin if (data1 >= data2) begin branch = 1; end else begin branch = 0; end end
      `ALU_CONTROL_B_LTU	: begin if (data1 < data2) begin branch = 1; end else begin branch = 0; end end
      `ALU_CONTROL_B_GEU	: begin if (data1 >= data2) begin branch = 1; end else begin branch = 0; end end          
      default : begin $display ("ALU: No valid operation"); end
    endcase
  end
endmodule
