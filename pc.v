module pc (input clk, input conditional_branch, input jump_i, input [15:0] add, input [31:0] jump, output [31:0] program_count);

reg program_count;
wire conditional_branch, clk, jump_i, add, jump;
wire [15:0] branch;
wire [31:0] adder4, adderb, pc_input, mux_to_mux_intermediate;

initial begin
	program_count = 0;
	#1 program_count = 0;
end

// adders are combinational blocks
assign adder4 = program_count + 1;
assign adderb = adder4 + add;

/* 
	2 muxes control input to the PC regs
	this part of the circuit is combinational.
	the input to pc (pc_input) is calculated during the clock cycle and written to register at clock edge.
*/

mux32 c_branch (.s(conditional_branch), .v0(adder4), .v1(adderb), .v(mux_to_mux_intermediate));
mux32 jump_mux (.s(jump_i), .v0(mux_to_mux_intermediate), .v1(jump), .v(pc_input));
// adder4 and adderb take values at posedge clk. muxes take values at negedge.
always @ (posedge clk) begin
	program_count <=pc_input;
	// update value of program counter at posedge and fetch instruction at negedge
end

/*
	always @ (posedge clk) begin
		if (jump_i == 1'b1) begin
			// unconditional jump
			program_count <= jump;
		end else if (conditional_branch == 0) begin
			program_count <= adder4;
		end
		else begin
			program_count <= adderb;
		end
	end
*/
endmodule
