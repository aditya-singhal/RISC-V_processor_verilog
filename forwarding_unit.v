/*
 * !(ex_mem_regwrite && (ex_mem_reg_rd != 0) && (ex_mem_reg_rd == id_ex_reg_rs2))
 * Above line in the MEM hazard detection is to handle the sequence instructions like: 
 * add x1, x1, x2
 * add x1, x1, x3
 * add x1, x1, x4
 * In this case, the result should be forwarded from the MEM stage because the result in the MEM stage is the more recent result.
 *
 */

module forwarding_unit(
	input ex_mem_regwrite,
    input mem_wb_regwrite,
  	input [4:0] ex_mem_reg_rd,
  	input [4:0] id_ex_reg_rd,
  	input [4:0] id_ex_reg_rs1,
  	input [4:0] id_ex_reg_rs2,
  	input [4:0] mem_wb_reg_rd,
  	output reg [1:0] forward_A,
  	output reg [1:0] forward_B
);
  
  always@(*) begin
      if ((ex_mem_regwrite == 1) && (ex_mem_reg_rd != 0) && (ex_mem_reg_rd == id_ex_reg_rs1)) begin  
        $display("EX hazard rs1"); 
        forward_A = 2'b10; 
      end
	  else if (mem_wb_regwrite && (mem_wb_reg_rd != 0) && !(ex_mem_regwrite && (ex_mem_reg_rd != 0) && (ex_mem_reg_rd == id_ex_reg_rs1)) && (mem_wb_reg_rd == 
        id_ex_reg_rs1)) begin $display("MEM hazard rs1"); forward_A = 2'b01; end
	  else begin forward_A = 2'b00; end

      if ((ex_mem_regwrite == 1) && (ex_mem_reg_rd != 0) && (ex_mem_reg_rd == id_ex_reg_rs2)) begin
		$display("EX hazard rs2");
        forward_B = 2'b10;
      end
	  else if (mem_wb_regwrite && (mem_wb_reg_rd != 0) && !(ex_mem_regwrite && (ex_mem_reg_rd != 0) && (ex_mem_reg_rd == id_ex_reg_rs2)) && (mem_wb_reg_rd == 
        id_ex_reg_rs2)) begin $display("MEM hazard rs2"); forward_B = 2'b01; end
	  else begin  forward_B = 2'b00; end
    end
endmodule
