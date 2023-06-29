`include "alu2.v"
`include "mux32.v"
`include "pc.v"
`include "veda.v"
`include "ext_memory.v"
// to-do - manage 16 bit signed numbers.

module cu(
    output [31:0] ireg,
    input wire clk
);

//control pins:
wire mux_imm; // for immediate instructions
wire conditional_branch ; // for conditional branch instructions
wire jump; // for unconditional jump instructions
wire we_dm; //write enable for data memory
wire we_ext; //write enable for external memory
wire where_to_jump; // 0 if jump to reg, 1 if jump to immediate address
wire jal; // 1 if pc+1 is to be written to $31, else 0
wire load_from_ext; // 1 if ext_out is to be written to dm, else 0
reg [7:0] state;

parameter RTYPE = 8'b00010000; // add, addu, sub, subu, or, and, sll, srl, slt
parameter ITYPE = 8'b10010000; // addi, addui, slti, ori, andi
parameter BRANCH = 8'b01000000; //beq, bne, blt, blte, bgt, bgte
parameter J_ADDRESS = 8'b00100100; // ja
parameter JAL = 8'b00110110; // jal
parameter JR = 8'b00100000; // jr
parameter LW = 8'b10010001;
parameter SW = 8'b10001000;


assign mux_imm = state[7]; // if yes then destination reg is rt
assign conditional_branch = state[6];
assign jump = state[5];
assign we_dm = state[4];
assign we_ext = state[3];
assign where_to_jump = state[2];
assign jal = state[1];
assign load_from_ext = state[0];

//internal connections
wire [31:0] ireg; //instruction register
wire [31:0] out_alu; // output from alu
wire [31:0] alu_in1, alu_in2; // inputs to alu
wire [31:0] next_instr_address; // program counter value
wire [31:0] jump_mux_to_pc; // carries jump address to pc
wire [31:0] ext_out; //read port of external memory

wire [31:0] dm_out1, dm_out2, dm_in1; // read and write ports of data memory
wire lsb_alu; // lsb of out_alu contains result of conditonal branch evaluations

assign alu_in1 = dm_out1;

veda1 dm (
	.data_out1(dm_out1),
	.data_out2(dm_out2),
	.read1(ireg[25:21]),
	.read2(ireg[20:16]),
	.write1((jal == 1'b1) ? 5'b11111 : ((mux_imm == 1'b1) ? ireg[20:16] : ireg[15:11])),
	.datain( (load_from_ext == 1'b1) ? ext_out : ((jal == 1'b1) ? (next_instr_address + 1) : out_alu)), //check later
	.we(we_dm)
);

veda2 im (
	.data_out1(ireg),
	.data_out2(),
	.read1(next_instr_address[4:0]),
	.read2(),
	.write1(),
	.datain(),
	.we(1'b0)
);

//to facilitate i-type instructions
mux32 imm_or_reg (.s(mux_imm), .v0(dm_out2), .v1({16'b0, ireg[15:0]}), .v(alu_in2)) ;

// jr $ra when s=0, jump to address when s=1
// dm_out1 is always $rs
mux32 jReg_or_jAddress (.s(where_to_jump), .v1({6'b0,ireg[25:0]}), .v0(dm_out1), .v(jump_mux_to_pc));

pc pc (
	.clk(clk),
	.conditional_branch(conditional_branch & out_alu[0]),
	.jump_i(jump),
	.add(ireg[15:0]), // value to add in conditional branch instructions
	.jump(jump_mux_to_pc),
	.program_count(next_instr_address)
);

alu alu0 (
	.opcode(ireg[31:26]),
	.funct(ireg[5:0]),
	.shamt(ireg[10:6]),
	.in1(alu_in1),
	.in2(alu_in2),
	.out_alu(out_alu)
);

external_memory mainMemory (
    .read_address(out_alu),
    .we_ext(we_ext),
    .write_address(out_alu),
    .write_data(), //check later - dmout*
    .clk(clk),
    .ext_read(ext_out)
);

always @ (posedge clk) state = 8'b0;

always @ (negedge clk) begin
    if (ireg[31:26] == 6'b110010) state = LW;
    else if (ireg[31:26] == 6'b110011) state = SW;
    else if (ireg[31:26] == 6'b110100) state = J_ADDRESS;
    else if (ireg[31:26] == 6'b110110) state = JR;
    else if (ireg[31:26] == 6'b110101) state = JAL;
    else if (ireg[31:29] == 3'b111) state = BRANCH;
    else if (ireg[31] == 1) state = ITYPE;
    else state = RTYPE;
end

endmodule
