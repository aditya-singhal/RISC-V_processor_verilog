// Todo: Make the memory: 32-bit byte addressable memory: data + instructions if needed
// or keep them separate. Decide according to the RISCV ISA.

module instruction_memory(clk, address, instruction);
    input clk;
  	input [31:0] address;
  	output reg [31:0] instruction;
  
  reg [31:0] mem_array [255:0];
	reg [31:0] temp;
	integer i;
	initial begin
      for (i=11; i<255; i=i+1) begin
        mem_array[i]=32'b0;
      end
      
      //$readmemh("code.hex", mem_array, 0, 100);
      
      mem_array[0] = {7'b0000000, 5'b00001, 5'b00000, 3'b000, 5'b01010, 7'b0110011};	// ADD R[10] = R[0] + R[1] = 10
      mem_array[1] = {7'b0100000, 5'b00111, 5'b01001, 3'b000, 5'b01011, 7'b0110011};	// SUB R[11] = R[9] - R[7] = 20
      mem_array[2] = {7'b0000000, 5'b00001, 5'b00100, 3'b001, 5'b01100, 7'b0110011};	// SLL R[12] = R[4] << R[1] = 40960
      mem_array[3] = {7'b0000000, 5'b00101, 5'b00010, 3'b010, 5'b01101, 7'b0110011};	// SLT R[13] = (R[2] < R[5]) ? 1 : 0
      mem_array[4] = {7'b0000000, 5'b00111, 5'b00011, 3'b100, 5'b01110, 7'b0110011};	// XOR R[14] = R[3] ^ R[7] = 88
      mem_array[5] = {7'b0000000, 5'b00111, 5'b00011, 3'b110, 5'b01111, 7'b0110011};	// OR R[15] = R[3] | R[7] = 94
      mem_array[6] = {7'b0000000, 5'b00111, 5'b00011, 3'b111, 5'b10000, 7'b0110011};	// AND R[16] = R[3] & R[7] = 6
      mem_array[7] = {7'b0000000, 5'b00010, 5'b00011, 3'b010, 5'b01001, 7'b0000011};	// LW type R[9] = Mem[imm + R[3]] imm = 2: 320
      mem_array[8] = {7'b0000000, 5'b11011, 5'b00011, 3'b010, 5'b01000, 7'b0100011};	// SW type Mem[imm + R[3]] = R[27] imm = 8: 
      mem_array[9] = {7'b0000000, 5'b00011, 5'b00011, 3'b000, 5'b01000, 7'b1100011};	// BEQ if (R[3] == R[3]), Jump to (PC+imm<<1), imm = 8
      mem_array[13] = {7'b0000000, 5'b00011, 5'b00010, 3'b000, 5'b00111, 7'b0110011};	// ADD R[7] = R[2] + R[3]
      mem_array[14] = {7'b0000000, 5'b00011, 5'b00010, 3'b000, 5'b01000, 7'b0110011};	// ADD R[8] = R[2] + R[3]

      
	end
  	// I think this can also be replaced by assign keyword
  	//always@(posedge clk) begin
	always@(address) begin
      instruction = mem_array[address/4];
//       $display("PC current Address: %0h, read intruction: %0h", address, mem_array[address]);
//       $display("PC current Address: %0h, read intruction: %0h", address+1, mem_array[address+1]);
//       $display("PC current Address: %0h, read intruction: %0h", address+2, mem_array[address+2]);
//       $display("PC current Address: %0h, read intruction: %0h", address+3, mem_array[address+3]);
    end
  
endmodule
