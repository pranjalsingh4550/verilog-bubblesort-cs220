`include "veda.v"

module tb ;

reg [4:0] r1, r2, w1;
reg we;
reg [31:0] wr1;
wire [31:0] out1, out2;

veda uut ( .read1(r1), .read2(r2), .write1(w1),
.datain(wr1), .we(we), .clk(we), .data_out1(out1), .data_out2(out2));

initial begin
	$dumpfile("dump.vcd");
	$dumpvars(0,tb);
	
	wr1 = 1023;
	w1 = 5;
	r1 = 5;
	r2 = 6;
	#5 we = 1;
	#5 r1 = 8;
	#5 we = 0;
	#5 w1 = 8;
	#5 wr1 = 31;
	#5 we = 1;
	#5 wr1 = 255;
	#5 $finish;
end
endmodule
