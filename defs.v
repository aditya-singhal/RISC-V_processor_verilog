`define CLK_FREQ_KHZ			50		// Clock frequency in Khz
`define CODE_START_ADDR			0		// PC start address
`define CODE_MEMORY_WORD_SIZE	32		// Size of each word of code memory
`define CODE_MEMORY_SIZE		255		// Code memory size in 32-bit words

`define INSTR_DICTIONARY_START_ADDR			200
`define OPCODE_DICTIONARY_START_ADDR		210
`define COMPRESSED_OR_NOT_ADDR	220

`define R_type		7'b0110011
`define I_type      7'b0010011
`define L_type      7'b0000011
`define S_type      7'b0100011
`define CB_type     7'b1100011
`define JALR_type   7'b1100111
`define JAL_type    7'b1101111
`define AUIPC_type	7'b0010111
`define LUI_type    7'b0110111

`define ALU_CONTROL_ADD			5'b00000
`define ALU_CONTROL_SUB			5'b00001
`define ALU_CONTROL_SLL			5'b00010	// logical shift left
`define ALU_CONTROL_SLT			5'b00011	// signed less than
`define ALU_CONTROL_SLTU		5'b00100	// unsigned less than
`define ALU_CONTROL_XOR			5'b00101
`define ALU_CONTROL_SRL			5'b00110	// logical shift right
`define ALU_CONTROL_SRA			5'b00111	// shift right arithmetic
`define ALU_CONTROL_OR			5'b01000
`define ALU_CONTROL_AND			5'b01001
`define ALU_CONTROL_SLLI		5'b01110
`define ALU_CONTROL_SRLI_SRAI	5'b01111
`define ALU_CONTROL_LUI			5'b10000
`define ALU_CONTROL_AUIPC		5'b10001

`define ALU_CONTROL_B_EQUAL		5'b10010
`define ALU_CONTROL_B_NOT_EQ	5'b10011
`define ALU_CONTROL_B_LT		5'b10100
`define ALU_CONTROL_B_GE		5'b10101
`define ALU_CONTROL_B_LTU		5'b10110
`define ALU_CONTROL_B_GEU		5'b10111

`define IMM_CODE_SRLI			7'b0000000
`define IMM_CODE_SRAI			7'b0100000

`define FUNC7_OP_0			7'b0000000
`define FUNC7_OP_1			7'b0100000
`define FUNC3_OP_ADD 		3'b000
`define FUNC3_OP_SUB 		3'b000
`define FUNC3_OP_SLL 		3'b001
`define FUNC3_OP_SLT 		3'b010
`define FUNC3_OP_SLTU 		3'b011
`define FUNC3_OP_XOR 		3'b100
`define FUNC3_OP_SRL 		3'b101
`define FUNC3_OP_SRA 		3'b101
`define FUNC3_OP_OR 		3'b110
`define FUNC3_OP_AND 		3'b111

`define FUNC3_OP_SLLI 		3'b001
`define FUNC3_OP_SRLI_SRAI 	3'b101

`define FUNC3_OP_BEQ    	3'b000
`define FUNC3_OP_BNE    	3'b001
`define FUNC3_OP_BLT    	3'b100
`define FUNC3_OP_BGE    	3'b101
`define FUNC3_OP_BLTU   	3'b110
`define FUNC3_OP_BGEU   	3'b111

`define ALU_OP_LW_SW_type	3'b000
`define ALU_OP_CB_type      3'b001
`define ALU_OP_R_type       3'b010
`define ALU_OP_I_type       3'b011
`define ALU_OP_LUI_type     3'b100
`define ALU_OP_AUIPC_type   3'b101

`define MAX_STALL_COUNT 	1
`define MAX_FLUSH_COUNT		1