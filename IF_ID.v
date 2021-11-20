`include "defs.v"

// Todo: cehck if stall and flush count can be merged

module IF_ID (
  input clk,
  input is_stall,
  input is_flush,
  input [31:0] PC_address_in,
  input [31:0] instr_in,
  output reg [31:0] PC_address_out,
  output reg [31:0] instr_out
);
  
  integer stall_count = 0;
  integer flush_count = 0;
  always@(posedge clk) begin
    if((is_stall == 0) || (stall_count == `MAX_STALL_COUNT)) begin 
      if ((is_flush !== 1'b1) || (flush_count == `MAX_FLUSH_COUNT)) begin // ( !== operator will include x and z condition also)
    	PC_address_out <= PC_address_in;
    	instr_out <= instr_in;
        if (flush_count == `MAX_FLUSH_COUNT) begin flush_count = 0; end	// reset flush count value
      end else begin 
        $display("IF_ID: instruction flushed, is_flush: %0d, flush_count: %0d", is_flush, flush_count);
		PC_address_out <= 0;
    	instr_out <= 0;
        flush_count = flush_count + 1;
      end
      if (stall_count == `MAX_STALL_COUNT) begin stall_count = 0; end	// reset stall count value
    end else begin 
      $display("IF_ID: Pipeline is stalled");       
      stall_count = stall_count + 1;
    end
  end
  
endmodule