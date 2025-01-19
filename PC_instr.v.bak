`include "define.v"
module PC_instr(
	//input
	input wire [`PC_WIDTH - 1 : 0] F_PC_i,
	//output
	output wire					mini_jmp_sel_o,
	output wire [`XLEN - 1:0]	mini_jmp_o,
	output wire [`INSTR_WIDTH - 1 : 0] instr_o
);
	wire[`OP_WIDTH - 1:0] mini_epcode;
	wire[`XLEN - 1:0] mini_imme;
	reg[7:0] instr_mem[1023:0];
	initial begin
		{instr_mem[3], instr_mem[2],instr_mem[1],instr_mem[0]} = 64'h00500113;
		{instr_mem[7], instr_mem[6],instr_mem[5],instr_mem[4]} = 64'h00C00193;
		{instr_mem[11], instr_mem[10],instr_mem[9],instr_mem[8]} = 64'hFF718393;
		{instr_mem[15], instr_mem[14],instr_mem[13],instr_mem[12]} = 64'h0023E233;
		{instr_mem[19], instr_mem[18],instr_mem[17],instr_mem[16]} = 64'h0041F2B3;
		{instr_mem[23], instr_mem[22],instr_mem[21],instr_mem[20]} = 64'h004282B3;
		{instr_mem[27], instr_mem[26],instr_mem[25],instr_mem[24]} = 64'h02728863;
		{instr_mem[31], instr_mem[30],instr_mem[29],instr_mem[28]} = 64'h0041A233;
		{instr_mem[35], instr_mem[34],instr_mem[33],instr_mem[32]} = 64'h00020463;
		{instr_mem[39], instr_mem[38],instr_mem[37],instr_mem[36]} = 64'h00000293;
		{instr_mem[43], instr_mem[42],instr_mem[41],instr_mem[40]} = 64'h0023A233;
		{instr_mem[47], instr_mem[46],instr_mem[45],instr_mem[44]} = 64'h005203B3;
		{instr_mem[51], instr_mem[50],instr_mem[49],instr_mem[48]} = 64'h402383B3;
		{instr_mem[55], instr_mem[54],instr_mem[53],instr_mem[52]} = 64'h0471AA23;
		{instr_mem[59], instr_mem[58],instr_mem[57],instr_mem[56]} = 64'h06002103;
		{instr_mem[63], instr_mem[62],instr_mem[61],instr_mem[60]} = 64'h005104B3;
		{instr_mem[67], instr_mem[66],instr_mem[65],instr_mem[64]} = 64'h008001EF;
		{instr_mem[71], instr_mem[70],instr_mem[69],instr_mem[68]} = 64'h00100113;
		{instr_mem[75], instr_mem[74],instr_mem[73],instr_mem[72]} = 64'h00910133;
		{instr_mem[79], instr_mem[78],instr_mem[77],instr_mem[76]} = 64'h0221A023;
		{instr_mem[83], instr_mem[82],instr_mem[81],instr_mem[80]} = 64'h00210063;

	end
	//取指令
	assign instr_o = {instr_mem[F_PC_i + 3], instr_mem[F_PC_i + 2], instr_mem[F_PC_i + 1], instr_mem[F_PC_i]};
	//mini-decode
	id mini_decode(
		//input
		.FD_instr_i(instr_o),
		//output
		//OP
		.D_epcode_o(mini_epcode),
		.D_branch_op_o(),
		.D_store_op_o(),
		.D_load_op_o(),
		.D_csr_op_o(),
		.D_ALU_op_o(),
		.D_need_dstE_o(),
		.D_sel_reg_o(),
		//data
		.D_rs1_o(),
		.D_rs2_o(),
		.D_imme_o(mini_imme),
		//addr
		.D_dstE_o(),
		.D_csr_addr_o()
	);
	wire op_branch = mini_epcode[`op_branch];
	wire op_jal = mini_epcode[`op_jal];
	
	assign mini_jmp_sel_o = op_branch | op_jal;
	assign mini_jmp_o = mini_imme + F_PC_i;
endmodule