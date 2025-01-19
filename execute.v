`include "define.v"
module execute(
	//input
	input wire [`XLEN - 1:0] 		 D_rs1_data_i,
	input wire [`XLEN - 1:0] 		 D_rs2_data_i,
	input wire [`OP_WIDTH - 1:0]     F_epcode_i,
	input wire [`BRANCH_WIDTH - 1:0] F_branch_op_i,
	input wire [`XLEN - 1:0]         F_imme_i,
	input wire [`ALU_WIDTH - 1:0]    F_ALU_op_i,
	input wire [`PC_WIDTH - 1:0]     F_PC_i,
	input wire [`CSR_WIDTH - 1:0]	 F_csr_op_i,
	input wire [`XLEN - 1:0]		 D_csr_data_i,
	//output
	//结果
	output wire [`XLEN - 1:0]		 E_valE_o,
	//写入内存的地址
	//跳转的地址
	output wire [`XLEN - 1:0]		 E_jmp_o,
	output wire E_jmp_sel_o,
	//csr_data
	output wire [`XLEN - 1:0]		 E_csr_data_o
);
	//opcode OP
	wire op_branch = F_epcode_i[`op_branch];
	wire op_jal = F_epcode_i[`op_jal];
	wire op_jalr = F_epcode_i[`op_jalr];
	wire op_store = F_epcode_i[`op_store];
	wire op_load = F_epcode_i[`op_load];
	wire op_alur = F_epcode_i[`op_alur];
	wire op_alurw = F_epcode_i[`op_alurw];
	wire op_alui = F_epcode_i[`op_alui];
	wire op_aluiw = F_epcode_i[`op_aluiw];
	wire op_lui = F_epcode_i[`op_lui];
	wire op_auipc = F_epcode_i[`op_auipc];
	wire op_system = F_epcode_i[`op_system];
	//ALU OP
	wire alu_add = F_ALU_op_i[`alu_add];
	wire alu_sub = F_ALU_op_i[`alu_sub];
	wire alu_sll = F_ALU_op_i[`alu_sll];
	wire alu_slt = F_ALU_op_i[`alu_slt];
	wire alu_sltu = F_ALU_op_i[`alu_sltu];
	wire alu_xor = F_ALU_op_i[`alu_xor];
	wire alu_srl = F_ALU_op_i[`alu_srl];
	wire alu_sra = F_ALU_op_i[`alu_sra];
	wire alu_or = F_ALU_op_i[`alu_or];
	wire alu_and = F_ALU_op_i[`alu_and];
	//BRANCH OP
	wire branch_eq = F_branch_op_i[`branch_eq];
	wire branch_ne = F_branch_op_i[`branch_ne];
	wire branch_lt = F_branch_op_i[`branch_lt];
	wire branch_ge = F_branch_op_i[`branch_ge];
	wire branch_ltu = F_branch_op_i[`branch_ltu];
	wire branch_geu = F_branch_op_i[`branch_geu];
	//CSR OP
	wire csr_rw = F_csr_op_i[`csr_rw];
	wire csr_rs = F_csr_op_i[`csr_rs];
	wire csr_rc = F_csr_op_i[`csr_rc];
	wire csr_wi = F_csr_op_i[`csr_wi];
	wire csr_si = F_csr_op_i[`csr_si];
	wire csr_ci = F_csr_op_i[`csr_ci];
	//ALU计算
	//操作数的选择
	//OP1 : jal/jalr/auipc:F_PC_i
	//		lui:0
	//		wi/si/ci:F_imme_i
	//		D_rs1_data_i
	//OP2 : jal/jalr:4
	//		store/load/lui/auipc/alui/aluiw: F_imme_i
	//		op_system: D_csr_data_i
	//      D_rs2_data_i
	//ADD/SUB
	wire [`XLEN - 1:0] OP1 =  	(op_jal | op_jalr | op_auipc) ? F_PC_i :
								(csr_wi | csr_si | csr_ci) ? F_imme_i :
								(op_lui) ? 0 : D_rs1_data_i;
								
	wire [`XLEN - 1:0] OP2 = 	(op_jal | op_jalr) ? 4 :
								(op_system) ? D_csr_data_i : 
								(op_store | op_load | op_lui | op_alui | op_aluiw | op_auipc) ? F_imme_i : D_rs2_data_i;
	//ALU sel
	wire use_sub = alu_sub | alu_slt | alu_sltu | op_branch;
	wire sel_add = alu_add | op_lui | op_auipc | op_store | op_load | op_jal | op_jalr;
	wire sel_sub = alu_sub;
	wire sel_sll = alu_sll;
	wire sel_slt = alu_slt;
	wire sel_sltu = alu_sltu;
	wire sel_xor = alu_xor;
	wire sel_srl = alu_srl;
	wire sel_sra = alu_sra;
	wire sel_or = alu_or;
	wire sel_and = alu_and;
	wire sel_crs = op_system;
	//res
	wire [`XLEN - 1:0] res_add_sub;
	wire [`XLEN - 1:0] res_sll;
	wire [`XLEN - 1:0] res_slt;
	wire [`XLEN - 1:0] res_sltu;
	wire [`XLEN - 1:0] res_xor;
	wire [`XLEN - 1:0] res_srl;
	wire [`XLEN - 1:0] res_sra;
	wire [`XLEN - 1:0] res_or;
	wire [`XLEN - 1:0] res_and;
	wire [`XLEN - 1:0] res_OP1;
	wire [`XLEN - 1:0] res_csr;
	//sub and ADD
	wire cin = use_sub;
	wire cout;
	wire [`XLEN - 1:0] adder_OP1 = OP1;
	wire [`XLEN - 1:0] adder_OP2 = {`XLEN{use_sub}} ^ OP2;
	assign {cout, res_add_sub} = adder_OP1 + adder_OP2 + cin;
	
	//slt and sltu
	wire lt, ltu;
	assign res_slt = {63'b0, lt};
	assign res_sltu = {63'b0, ltu};
	//移位
	wire [4:0] shift_OP2 = (op_alurw | op_aluiw) ? {1'b0,OP2[3:0]} : OP2[4:0];
	//sll
	assign res_sll =  OP1 << shift_OP2;
	//srl
	assign res_srl = OP1 >> shift_OP2;
	//sra
	assign res_sra = $signed(OP1) >>> shift_OP2;
	//xor
	assign res_xor = OP1 ^ OP2;
	//and
	assign res_and = OP1 & OP2;
	//or
	assign res_or = OP1 | OP2;
	//csr
	assign res_csr = OP2;
	wire [`XLEN - 1:0] res = 
									({`XLEN{sel_slt}} & res_slt ) | 
									({`XLEN{sel_sltu}} & res_sltu ) |
									({`XLEN{sel_add | sel_sub}} & res_add_sub ) |
									({`XLEN{sel_sll}} & res_sll ) | 
									({`XLEN{sel_xor}} & res_xor ) |
									({`XLEN{sel_srl}} & res_srl ) | 
									({`XLEN{sel_sra}} & res_sra ) | 
									({`XLEN{sel_or}} & res_or ) | 
									({`XLEN{sel_and}} & res_and ) |
									({`XLEN{sel_crs}} &  res_csr);

	wire [`XLEN - 1:0]resw = {{32{res[31]}}, res[31:0]};
	assign E_valE_o = (op_alurw | op_aluiw) ? resw : res;
	
	//lt ltu ge geu eq ne
	// <
	// op1?+ op2?-
	//???? 
	assign lt = (OP1[`XLEN - 1] & ~OP2[`XLEN - 1]) | ((~(OP2[`XLEN - 1] ^ OP1[`XLEN - 1])) & res_add_sub[`XLEN - 1]);
	assign ltu = ~cout;
	wire ne = (|res_add_sub);
	wire ge = ~lt;
	wire geu = ~ltu;
	wire eq = ~ne;
	//跳转的的下一个位置
	wire [`PC_WIDTH - 1 : 0] PC_op1 = (op_jalr) ? D_rs1_data_i : F_PC_i;
	wire [`PC_WIDTH - 1 : 0] PC_op2 = (op_branch) ? 4 : F_imme_i;
	assign E_jmp_o = PC_op1 + PC_op2;
	assign E_jmp_sel_o = 	(branch_eq & ~eq) |
							(branch_ne & ~ne) | 
							(branch_lt & ~lt) |
							(branch_ge & ~ge) | 
							(branch_ltu & ~ltu) |
							(branch_geu & ~geu) | op_jalr;
	//csr op
	wire [`XLEN - 1:0] w = OP1;
	wire [`XLEN - 1:0] s = OP1 | OP2;
	wire [`XLEN - 1:0] c = (~OP1 & OP2);
	//csr sel
	wire sel_w = csr_rw | csr_wi;
	wire sel_s = csr_rs | csr_si;
	wire sel_c = csr_rc | csr_ci;
	assign E_csr_data_o = 
									({`XLEN{sel_w}} & w ) | 
									({`XLEN{sel_s}} & s ) |
									({`XLEN{sel_c}} & c );
endmodule
