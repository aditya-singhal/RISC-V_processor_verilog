`include "defs.v"

module imm_generator(clk, in_data, out_data);
  	input clk;
	input wire [31:0] in_data;
	output reg [31:0] out_data;
  
 	wire [6:0] opcode;
  	assign opcode = in_data[6:0];
  
  	always@(*) begin
		case(opcode)
			`L_type: begin
              out_data[11:0]  = in_data[31:20];
              out_data[31:12] = {20{in_data[31]}};
			end
			`S_type: begin
              out_data[4:0]   = in_data[11:7];
              out_data[11:5]  = in_data[31:25];
              out_data[31:12] = {20{in_data[31]}};
			end			
			`CB_type: begin
              out_data[4:0]   = in_data[11:7];
              out_data[11:5]  = in_data[31:25];
              out_data[31:12] = {20{in_data[31]}};
			end
          	`LUI_type: begin 
              out_data[31:12] = in_data[31:12];
              out_data[11:0]  = 0;
            end
          	`AUIPC_type: begin 
              out_data[31:12] = in_data[31:12];
              out_data[11:0]  = 0;
            end
          	`JAL_type: begin
              out_data[0]  	  = 0;					// The address is in mutiple of 2bytes
              out_data[10:1]  = in_data[30:21];
              out_data[11]    = in_data[20];
              out_data[19:12] = in_data[19:12];
              out_data[20] 	  = in_data[31];
              out_data[31:21] = {11{in_data[31]}};
			end
          	`JALR_type: begin
              out_data[11:0]  = in_data[31:20];
              out_data[31:12] = {20{in_data[31]}};
            end
          	default: begin
              //$display ("Immediate value not used!");
            end
		endcase
      //$display ("Final Immediate value after sign extension: %0h", out_data);
	end
endmodule
