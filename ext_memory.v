module external_memory(
	input wire [31:0] read_address,
	input wire we_ext,
	input [31:0] write_address,
	input write_data,
	input clk,
	output wire [31:0] ext_read
);

reg [31:0] memory [255:0];
wire [7:0] write_address_internal;
assign write_address_internal = write_address[7:0];

assign ext_read = memory[read_address[7:0]];

always @ (negedge we_ext) begin
	// check later: posedge or negedge
	memory[write_address_internal] <= write_data;
end

endmodule
