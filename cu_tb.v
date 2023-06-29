`include "cu2.v"

module controlUnit_tb;

reg clk;
wire [31:0] ins;
cu uut (.clk(clk), .ireg(ins));

initial begin
	clk = 1;
	forever #5 clk <= ~clk;
end

initial begin
	$dumpfile("dump2.vcd");
	$dumpvars (0, controlUnit_tb);
	#250 $finish;
end

endmodule
