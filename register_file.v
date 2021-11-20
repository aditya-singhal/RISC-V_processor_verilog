/*
 * 31 32-bit General purpose registers, x1 - x31
 * x0 is hard wired to 0
 * x1 is used to hold the return address
 * PC holds the address of the current instruction
 */

// Todo: Verify: The data in registers is stored as integers in 2’s complement binary representation

module register_file (
    input wire clk,
	input wire reg_write_en,
    input wire [4:0] read_reg_1,
	input wire [4:0] read_reg_2,
	input wire [4:0] write_reg,
    input wire [31:0] write_data,
    output [31:0] read_data_1,
    output [31:0] read_data_2
);

    reg [31 : 0] mem [31 : 0];  // 32, 32-bit registers
	reg PC;						// Program counter

	integer i;
	initial begin
      for (i=0; i<32; i=i+1) begin
        mem[i] = i * 10;
		end
	end

	// Write to particular register at posedge clk
  	//always @(write_data, write_reg) begin
  	//always @(posedge clk) begin
  	always @(*) begin
       	if ((reg_write_en == 1) && (write_reg != 5'b00000)) begin 
          $display("Register %0d is written with value: %0d", write_reg, write_data);
          mem[write_reg] = write_data;
		end 
      	else if ((reg_write_en == 1) && (write_reg == 5'b00000)) begin
          $display("NOP instruction");
	  	end 
    end
	
//   	always@(read_reg_1, read_reg_2) begin
//       read_data_1 =  mem[read_reg_1];
//       read_data_2 =  mem[read_reg_2];
//       //$display("read_data_1: %0d, read_data_2: %0d", read_data_1, read_data_2);
//     end
  
	assign read_data_1 = mem[read_reg_1];
	assign read_data_2 = mem[read_reg_2];
	
endmodule
