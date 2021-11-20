// Todo: Make the memory: 32-bit byte addressable memory: data + instructions if needed
// or keep them separate. Decide according to the RISCV ISA.

module instruction_memory(clk, address, instruction);
  input clk;
  input [31:0] address;
  output reg [31:0] instruction;

  reg [31:0] compressed_or_not_address;		// Either this will come as an input or define it as a MACRO, Also update the name
  reg [31:0] instr_dictionary_address;
  reg [31:0] opcode_dictionary_address;
  reg [31:0] compressed_or_not_block;
  reg [31:0] compressed_instr;
  reg [1:0] total_bit_changes;
  reg [1:0] dictionary_index;
  reg [4:0] bit_location;
  reg [`CODE_MEMORY_WORD_SIZE:0] mem_array [`CODE_MEMORY_SIZE:0];
  reg [31:0] temp;
  integer is_compressed = 0;
  integer compressed_or_not_block_number = 0;
  integer compressed_or_not_block_index = 0;
  integer dict_index_location;
  integer instr_count;
  integer i;
  
	initial begin
      instr_dictionary_address = `INSTR_DICTIONARY_START_ADDR;
      opcode_dictionary_address = `OPCODE_DICTIONARY_START_ADDR;
      compressed_or_not_address = `COMPRESSED_OR_NOT_ADDR;
      
      for (i=0; i<`CODE_MEMORY_SIZE; i=i+1) begin
        mem_array[i]=32'b0;
      end
      
//       mem_array[0] = {7'b0000000, 5'b00001, 5'b00000, 3'b000, 5'b01010, 7'b0110011};	// ADD R[10] = R[0] + R[1] = 10
//       mem_array[4] = {7'b0100000, 5'b00111, 5'b01001, 3'b000, 5'b01011, 7'b0110011};	// SUB R[11] = R[9] - R[7] = 20
//       mem_array[8] = {7'b0000000, 5'b00001, 5'b00100, 3'b001, 5'b01100, 7'b0110011};	// SLL R[12] = R[4] << R[1] = 40960
//       mem_array[12] = {7'b0000000, 5'b00101, 5'b00010, 3'b010, 5'b01101, 7'b0110011};	// SLT R[13] = (R[2] < R[5]) ? 1 : 0 = 1
//       mem_array[16] = {7'b0000000, 5'b00111, 5'b00011, 3'b100, 5'b01110, 7'b0110011};	// XOR R[14] = R[3] ^ R[7] = 88
//       mem_array[20] = {7'b0000000, 5'b00111, 5'b00011, 3'b110, 5'b01111, 7'b0110011};	// OR R[15] = R[3] | R[7] = 94
//       mem_array[24] = {7'b0000000, 5'b00111, 5'b00011, 3'b111, 5'b10000, 7'b0110011};	// AND R[16] = R[3] & R[7] = 6
//       mem_array[28] = {7'b0000000, 5'b00010, 5'b00011, 3'b010, 5'b01001, 7'b0000011};	// LW type R[9] = Mem[imm + R[3]] imm = 2: 320
//       mem_array[32] = {7'b0000000, 5'b11011, 5'b00011, 3'b010, 5'b01000, 7'b0100011};	// SW type Mem[imm + R[3]] = R[27] imm = 8: MEM[38] = 270
//       mem_array[36] = {7'b0000000, 5'b00011, 5'b00011, 3'b000, 5'b00111, 7'b1100011};	// BEQ if (R[3] == R[3]), Jump to (PC+imm<<1), imm = 7 = B->PC=50
//       mem_array[50] = {7'b0000000, 5'b00011, 5'b00010, 3'b000, 5'b00111, 7'b0110011};	// ADD R[7] = R[2] + R[3] = 50
//       mem_array[54] = {7'b0000000, 5'b00011, 5'b00010, 3'b000, 5'b01000, 7'b0110011};	// ADD R[8] = R[2] + R[3] = 50
//       mem_array[58] = {7'b0000000, 5'b00011, 5'b00010, 3'b000, 5'b01001, 7'b0110011};	// ADD R[9] = R[2] + R[3] = 50
//       mem_array[60] = {7'b0000000, 5'b00011, 5'b00010, 3'b000, 5'b01010, 7'b0110011};	// ADD R[10] = R[2] + R[3] = 50

      mem_array[0] = {32'h104};		// ADD R[10] = R[0] + R[1] = 10
      mem_array[4] = {32'h66292};	// SUB R[11] = R[9] - R[7] = 20
      mem_array[8] = {32'h104};		// ADD R[10] = R[0] + R[1] = 10
      mem_array[12] = {32'h66292};	// SUB R[11] = R[9] - R[7] = 20
      mem_array[16] = {32'h104};	// ADD R[10] = R[0] + R[1] = 10
      mem_array[20] = {32'h66292};	// SUB R[11] = R[9] - R[7] = 20
      mem_array[24] = {32'h104};	// ADD R[10] = R[0] + R[1] = 10
      mem_array[28] = {32'h66292};	// SUB R[11] = R[9] - R[7] = 20
      mem_array[32] = {32'h104};	// ADD R[10] = R[0] + R[1] = 10
      mem_array[36] = {32'h66292};	// SUB R[11] = R[9] - R[7] = 20
      
      mem_array[`COMPRESSED_OR_NOT_ADDR] = {32'hFFFFFFFF};
      
      mem_array[`INSTR_DICTIONARY_START_ADDR] = {32'h00000000};
      mem_array[`INSTR_DICTIONARY_START_ADDR+1] = {32'h00000001};
      mem_array[`INSTR_DICTIONARY_START_ADDR+2] = {32'h100531};
      mem_array[`INSTR_DICTIONARY_START_ADDR+3] = {32'h407485C3};
      
      //$readmemh("code.hex", mem_array, 0, 100);
    end
    
	always@(address) begin
      compressed_instr = mem_array[address];
      instr_count = address/4;
      compressed_or_not_block_number = instr_count / 32;
      compressed_or_not_block_index = instr_count % 32;
//       $display("compressed_or_not_block_number: %0d", compressed_or_not_block_number);
//       $display("compressed_or_not_block_index: %0d", compressed_or_not_block_index);
      
      compressed_or_not_block = mem_array[compressed_or_not_address + compressed_or_not_block_number];
      is_compressed = compressed_or_not_block[compressed_or_not_block_index];
      
      if (is_compressed == 1) begin
        //$display("Compressed instruction");
        total_bit_changes = compressed_instr[1:0];
        
       	case(total_bit_changes)
          2'b00: begin
            bit_location = compressed_instr[6:2];	// (4*bit_location + total_bit_changes )
            dictionary_index = compressed_instr[8:7];
            instruction = mem_array[instr_dictionary_address + dictionary_index];
            instruction = instruction ^ (1 << bit_location);

          end 
          2'b01: begin
            dictionary_index = compressed_instr[12+2 : 12];	// (4*bit_location + total_bit_changes )
            instruction = mem_array[instr_dictionary_address + dictionary_index];
            
            bit_location = compressed_instr[6:2];
            instruction = instruction ^ (1 << bit_location);
            bit_location = compressed_instr[11:7];
            instruction = instruction ^ (1 << bit_location);
          end 
          2'b10: begin
            dictionary_index = compressed_instr[17+2 : 17];	// (4*bit_location + total_bit_changes )
            instruction = mem_array[instr_dictionary_address + dictionary_index];
            
            bit_location = compressed_instr[6:2];
            instruction = instruction ^ (1 << bit_location);
            bit_location = compressed_instr[11:7];
            instruction = instruction ^ (1 << bit_location);
            bit_location = compressed_instr[16:12];
            instruction = instruction ^ (1 << bit_location);
            
          end 
          2'b11: begin
            dictionary_index = compressed_instr[22+2 : 22];	// (4*bit_location + total_bit_changes )
            instruction = mem_array[instr_dictionary_address + dictionary_index];
            
            bit_location = compressed_instr[6:2];
            instruction = instruction ^ (1 << bit_location);
            bit_location = compressed_instr[11:7];
            instruction = instruction ^ (1 << bit_location);
            bit_location = compressed_instr[16:12];
            instruction = instruction ^ (1 << bit_location);
            bit_location = compressed_instr[21:17];
            instruction = instruction ^ (1 << bit_location);
          end 
        endcase
        // Now instruction is the size of 27 bits, Update the opcode for this instruction
        
	  end else begin 
      	instruction = compressed_instr;
        //$display("Uncompressed instruction");
      end
      
//  	 $display("PC current Address: %0d, read intruction: %0h", address, instruction);
//       $display("PC current Address: %0h, read intruction: %0h", address+1, mem_array[address+1]);
//       $display("PC current Address: %0h, read intruction: %0h", address+2, mem_array[address+2]);
//       $display("PC current Address: %0h, read intruction: %0h", address+3, mem_array[address+3]);
    end
  
endmodule
