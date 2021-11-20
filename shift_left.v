module shift_left_32bit(in_data, out_data);
	input[31:0] in_data;
	output reg[31:0] out_data;
	
	always@(in_data) begin
		out_data = in_data << 1;
	end
endmodule
