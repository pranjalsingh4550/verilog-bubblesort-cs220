module veda1 ( // data memory
	input wire [4:0] read1,
	input wire [4:0] read2,
	input wire [4:0] write1,
	input wire [31:0] datain,
	input wire we,
	output reg [31:0] data_out1,
	output reg [31:0] data_out2
);

reg [31:0] data [32];

initial begin
	data[0] = 32'b0;
	data[1] = 32'b0;
	data[2] = 32'b0;
	data[3] = 32'b0;
	data[4] = 32'b0;
	data[5] = 32'b0;
	data[6] = 32'b0;
	data[7] = 32'b0;
	data[8] = 32'b0;
	data[9] = 32'b0;
	data[10] = 32'b0;
	data[11] = 32'b0;
	data[12] = 32'b0;
	data[13] = 32'b0;
	data[14] = 32'b0;
	data[15] = 32'b0;
	data[16] = 32'b0;
	data[17] = 32'b0;
	data[18] = 32'b0;
	data[19] = 32'b0;
	data[20] = 32'b0;
	data[21] = 32'b0;
	data[22] = 32'b0;
	data[23] = 32'b0;
	data[24] = 32'b0;
	data[25] = 32'b0;
	data[26] = 32'b0;
	data[27] = 32'b0;
	data[28] = 32'b0;
	data[29] = 32'b0;
	data[30] = 32'b0;
	data[31] = 32'b0;
	// fill instructions/data here
end

always @* data_out1 = data[read1] ;
always @* data_out2 = data[read2] ;
always @ (negedge we) data[write1] <= datain;

endmodule


module veda2 ( // instruction memory
	input wire [4:0] read1,
	input wire [4:0] read2,
	input wire [4:0] write1,
	input wire [31:0] datain,
	input wire we,
	output reg [31:0] data_out1,
	output reg [31:0] data_out2
);

reg [31:0] data [32];

parameter add  = 6'b000000;
parameter addi = 6'b100000;
parameter addu = 6'b000001;
parameter addui= 6'b100001;
parameter sub  = 6'b000010;
parameter  subu= 6'b000011;
parameter orr  = 6'b000100;
parameter ori  = 6'b100100;
parameter andd=  6'b000101;
parameter andi=  6'b100101;
parameter sll =  6'b000110;
parameter srl =  6'b000111;
parameter slt =  6'b001000;
parameter slti=  6'b101000;
parameter lw  =  6'b110010;
parameter  sw  = 6'b110011;
parameter  j   = 6'b110100;
parameter  jal = 6'b100101;
parameter   jr = 6'b110110;


parameter beq = 6'b111000;
parameter bne = 6'b111001;
parameter bgt = 6'b111010;
parameter bgte= 6'b111011;
parameter blt = 6'b111100;
parameter blte= 6'b111101;

parameter dummy = 5'b00000;

initial begin
	data[0] = {addi, dummy, 5'b01000, 16'b00000000_11111111}; // addi $8, $0, 255
	data[1] = {addi, dummy, 5'b01001, 16'b00000000_11111110}; // addi $9, $0, 254
	data[2] = {add, 5'b01000, 5'b01001, 5'b01010,11'b0}; // add $10, $9, $8
	data[3] = {bne, 5'b01000, 5'b01001, 16'b00000000_00010000}; // bne $8, $9, 16
	data[4] = {andd, 5'b01011, 5'b01001, 5'b01100, 11'b0}; // and $11, $9, $12
	data[5] = 32'b011011_01100_01101_00010_00000_000010; // bgt $12, $13, 2
	data[6] = 32'b011011_01100_01101_00010_00000_000011; // bgte $12, $13, 2
	data[7] = 32'b0;
	data[8] = 32'b100000_00000_01000_00000001_11111111; // addi $8, $0, 511
	data[9] = 32'b100000_00000_01001_00000000_11111100; // addi $9, $0, 252;
	data[10] = 32'b000000_01000_01001_01011_00000_000000; // add $11, $8, $9
	data[11] = 32'b100001_01000_01011_00000000_00001010; // subi $11, $8, 10
	data[12] = 32'b011011_01011_01000_00110_00000_000100; // ble $11, $8, 6
	data[13] = 32'b0;
	data[14] = 32'b0;
	data[15] = 32'b0;
	data[16] = 32'b0;
	data[17] = 32'b0;
	data[18] = 32'b0;
	data[19] = 32'b100000_00000_01100_00000000_00001100; // addi $12, $0, 12
	//data[20] = 32'b100000_00000_01101_00000000_00001100; // addi $13, $0, 12
	data[20] = {addi, dummy, 5'b01101, 00000000_00001100};	
	data[21] = 32'b011011_01100_01101_01110_00000_000000; // beq $12, $13, 01110 = 14;
	data[22] = 32'b0;
	data[23] = 32'b0;
	data[24] = 32'b0;
	data[25] = 32'b0;
	data[26] = 32'b0;
	data[27] = 32'b0;
	data[28] = 32'b0;
	data[29] = 32'b0;
	data[30] = 32'b0;
	data[31] = 32'b0;
	// fill instructions/data here
end

always @* data_out1 = data[read1] ;
always @* data_out2 = data[read2] ;
always @ (posedge we) data[write1] <= datain;

endmodule
