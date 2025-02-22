`include "define.v"
module hazard_control(
	input wire [`OP_WIDTH - 1:0]    D_epcode_i,
	input wire [`OP_WIDTH - 1:0]	DD_epcode_i,
	input wire [4:0]		D_rs1_i,
	input wire [4:0]		D_rs2_i,
	input wire [4:0]        DD_dstE_i,
	input wire				DD_need_dstE_i,
	input wire 				E_jmp_sel_o,

	output wire				PC_stall_o,
	output wire				F_stall_o,
	output wire				F_bubble_o,
	output wire				D_bubble_o
);
	wire op_load = DD_epcode_i[`op_load];
	wire op_branch = DD_epcode_i[`op_branch];

	assign PC_stall_o = (op_load) & (D_rs1_i == DD_dstE_i | D_rs2_i == DD_dstE_i) &	DD_need_dstE_i;
	assign F_stall_o = (op_load) & (D_rs1_i == DD_dstE_i | D_rs2_i == DD_dstE_i) &	DD_need_dstE_i;
	assign F_bubble_o = (op_branch) & (E_jmp_sel_o);
	assign D_bubble_o = ((op_branch) & (E_jmp_sel_o)) | ((op_load) & (D_rs1_i == DD_dstE_i | D_rs2_i == DD_dstE_i) & DD_need_dstE_i);
endmodule