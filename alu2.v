`include "submodules.v"

module alu (input [5:0] opcode, input [5:0] funct, input [31:0] in1, input [31:0] in2, output [31:0] out_alu, input [4:0] shamt);
// for r-type instructions in1 is value of rs and in2 is rt
// for i-type instructions in1 is value of rs and in2 is fed via external mux
// for j-type instructions no action is to be taken

// for CONDITIONAL branch statements, out_alu[0] is the output port

wire [31:0] out_add, out_addu, out_sub, out_subu, out_slt, bitwise_or, bitwise_and, out_srl, out_sll;
reg [31:0] out_alu; // should be wire ideally, entirely combinational circuit
wire equality;
add add		(.in1(in1), .in2(in2), .result(out_add));
addu addu	(.in1(in1), .in2(in2), .result(out_addu));
sub sub		(.in1(in1), .in2(in2), .result(out_sub));
subu subu	(.in1(in1), .in2(in2), .result(out_subu));
or1 or1		(.in1(in1), .in2(in2), .result(bitwise_or));
and1 and1	(.in1(in1), .in2(in2), .result(bitwise_and));
slt slt		(.in1(in1), .in2(in2), .result(out_slt));
equal eq	(.in1(in1), .in2(in2), .result(equality));
sll sll 	(.in1(in1), .shamt(shamt), .result(out_sll));
srl srl		(.in1(in1), .shamt(shamt), .result(out_srl));

always @* begin
	case(opcode)
		6'b000000: out_alu = out_add;
		6'b100000: out_alu = out_add;
		6'b000001: out_alu = out_addu;
		6'b100001: out_alu = out_addu;
		6'b000010: out_alu = out_sub;
		6'b000011: out_alu = out_subu;
		6'b000100: out_alu = bitwise_or;
		6'b100100: out_alu = bitwise_or;
		6'b000101: out_alu = bitwise_and;
		6'b100101: out_alu = bitwise_and;
		6'b000110: out_alu = out_sll;
		6'b000111: out_alu = out_srl;
		6'b001000: out_alu = out_slt;
		6'b101000: out_alu = out_slt;
		6'b110010: out_alu = out_add;
		6'b110011: out_alu = out_add;

		6'b111000: out_alu = {31'b0, equality};
		6'b111001: out_alu = {31'b0, ~equality}; // bne
		6'b111010: out_alu = {31'b0, (~equality)&&(~out_slt)}; // bgt
		6'b111011: out_alu = {31'b0, 1'b0 || (~out_slt)}; // bgte
		6'b111100: out_alu = {31'b0, 1'b0 || (out_slt)}; // blt
		6'b111101: out_alu = {31'b0, equality || out_slt }; // blte
		default: out_alu = 32'b0;
	endcase
end

endmodule
