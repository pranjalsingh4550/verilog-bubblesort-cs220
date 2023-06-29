module mux32 (input wire s, input wire [31:0] v0, input wire [31:0] v1, output wire [31:0] v);
assign v = (s==1'b1 ? v1 : v0);
endmodule
