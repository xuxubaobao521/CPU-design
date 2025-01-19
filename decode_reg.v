`include "define.v"
module decode_reg(
	//input
	input wire							clk_i,
	input wire 					   		D_bubble_i,
	input wire					   		D_stall_i,
	input wire [`OP_WIDTH - 1:0]     	D_epcode_i,
	input wire [`STORE_WIDTH - 1:0]  	D_store_op_i,
	input wire [`LOAD_WIDTH - 1:0]   	D_load_op_i,
	input wire [`CSR_WIDTH - 1:0]		D_csr_op_i,
	input wire [`BRANCH_WIDTH - 1:0] 	D_branch_op_i,
	input wire [`ALU_WIDTH - 1:0]    	D_ALU_op_i,
	input wire					   		D_sel_reg_i,
	input wire [`PC_WIDTH - 1:0]     	D_PC_i,
	input wire                       	D_need_dstE_i,
	input wire [4:0]                 	D_dstE_i,
	input wire [11:0]				   	D_csr_addr_i,
	input wire [`XLEN - 1:0]			D_rs1_data_i,
	input wire [`XLEN - 1:0]			D_rs2_data_i,
	input wire [`XLEN - 1:0] 			D_csr_data_i,
	input wire [`XLEN - 1:0] 			D_imme_i,
	//output
	
	output reg [`OP_WIDTH - 1:0]     	DD_epcode_o,
	output reg [`STORE_WIDTH - 1:0]  	DD_store_op_o,
	output reg [`LOAD_WIDTH - 1:0]   	DD_load_op_o,
	output reg [`CSR_WIDTH - 1:0]		DD_csr_op_o,
	output reg [`BRANCH_WIDTH - 1:0] 	DD_branch_op_o,
	output reg [`ALU_WIDTH - 1:0]    	DD_ALU_op_o,
	output reg					   		DD_sel_reg_o,
	output reg [`PC_WIDTH - 1:0]     	DD_PC_o,
	output reg                       	DD_need_dstE_o,
	output reg [4:0]                 	DD_dstE_o,
	output reg [11:0]				   	DD_csr_addr_o,
	output reg [`XLEN - 1:0]			DD_rs1_data_o,
	output reg [`XLEN - 1:0]			DD_rs2_data_o,
	output reg [`XLEN - 1:0] 			DD_csr_data_o,
	output reg [`XLEN - 1:0] 			DD_imme_o
);
	initial begin
			DD_epcode_o 	<=0;
			DD_store_op_o	<=0;
			DD_load_op_o	<=0;
			DD_csr_op_o		<=0;
			DD_branch_op_o	<=0;
			DD_ALU_op_o		<=0;
			DD_sel_reg_o	<=0;
			DD_PC_o			<=0;
			DD_need_dstE_o	<=0;
			DD_dstE_o		<=0;
			DD_csr_addr_o	<=0;
			DD_rs1_data_o	<=0;
			DD_rs2_data_o	<=0;
			DD_csr_data_o	<=0;
			DD_imme_o		<=0;
	end
	always @(posedge clk_i) begin
		if(D_bubble_i) begin
			DD_epcode_o 	<=0;
			DD_store_op_o	<=0;
			DD_load_op_o	<=0;
			DD_csr_op_o		<=0;
			DD_branch_op_o	<=0;
			DD_ALU_op_o		<=0;
			DD_sel_reg_o	<=0;
			DD_PC_o			<=0;
			DD_need_dstE_o	<=0;
			DD_dstE_o		<=0;
			DD_csr_addr_o	<=0;
			DD_rs1_data_o	<=0;
			DD_rs2_data_o	<=0;
			DD_csr_data_o	<=0;
			DD_imme_o		<=0;
		end
		else if(~D_stall_i) begin
			DD_epcode_o 	<=D_epcode_i;
			DD_store_op_o	<=D_store_op_i;
			DD_load_op_o	<=D_load_op_i;
			DD_csr_op_o		<=D_csr_op_i;
			DD_branch_op_o	<=D_branch_op_i;
			DD_ALU_op_o		<=D_ALU_op_i;
			DD_sel_reg_o	<=D_sel_reg_i;
			DD_PC_o			<=D_PC_i;
			DD_need_dstE_o	<=D_need_dstE_i;
			DD_dstE_o		<=D_dstE_i;
			DD_csr_addr_o	<=D_csr_addr_i;
			DD_rs1_data_o	<=D_rs1_data_i;
			DD_rs2_data_o	<=D_rs2_data_i;
			DD_csr_data_o	<=D_csr_data_i;
			DD_imme_o		<=D_imme_i;
		end
	end
endmodule