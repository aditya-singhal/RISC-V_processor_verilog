module hazard_detection_unit(
  input id_ex_mem_rd,
  input [4:0] id_ex_reg_rd,
  input [4:0] if_id_reg_rs1,
  input [4:0] if_id_reg_rs2,
  output reg is_stall
);
  
  initial begin 
  	is_stall = 0;
  end
  
  
  always@(*) begin
    if (id_ex_mem_rd && ((id_ex_reg_rd == if_id_reg_rs1) || (id_ex_reg_rd == if_id_reg_rs2))) begin 
      $display("is_stall = 1");
      is_stall = 1; 
    end
    else begin 
      //isplay("is_stall = 0");
      is_stall = 0; 
    end
  end
endmodule
