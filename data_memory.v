module data_memory(clk, memread, memwrite, address, writedata, readdata);
	input clk;
  	input memread;
	input memwrite;
	input [31:0] address;
	input [31:0] writedata;
	output reg [31:0] readdata;
 
	reg [31:0] mem_array [127:0];
	
  	integer i;  
	initial begin
		for (i=0; i<127; i=i+1) begin
			mem_array[i]=i*10;
		end
	end

  	always@(address) begin // working line
		if(memread) begin
			readdata = mem_array[address];
          //$display("Dataread value at address: %0d is %0d", address, readdata);
		end

		if(memwrite) begin
          mem_array[address] = writedata;
          $display("Data value writen at address: %0d is %0d", address, writedata);
		end
	end
endmodule
