module add (output wire [31:0] result, input [31:0] in1, input [31:0] in2);
	assign result = in1 + in2;
endmodule

module addu (output wire [31:0] result, input [31:0] in1, input [31:0] in2);
	assign result = in1 + in2 ;
endmodule

module sub (output wire [31:0] result, input [31:0] in1, input [31:0] in2);
assign result = in1 - in2;
endmodule

module subu (output wire [31:0] result, input [31:0] in1, input [31:0] in2);
assign result = in1 - in2;
endmodule

module or1 (output wire [31:0] result, input [31:0] in1, input [31:0] in2);
assign result = in1 | in2;
endmodule

module and1 (output wire [31:0] result, input [31:0] in1, input [31:0] in2);
assign result = in1 & in2;
endmodule

module slt (output wire [31:0] result, input [31:0] in1, input [31:0] in2);
assign result = in1 < in2;
endmodule

module sll (output wire [31:0] result, input [31:0] in1, input [4:0] shamt);
assign result = in1 << shamt;
endmodule

module srl (output wire [31:0] result, input [31:0] in1, input [4:0] shamt);
assign result = in1 >> shamt;
endmodule

module equal (output wire result, input [31:0] in1, input [31:0] in2);
assign result = (in1 == in2);
endmodule
