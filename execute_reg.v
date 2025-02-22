`include "define.v"
module execute_reg(
	input wire							clk_i,
	input wire 					   		E_bubble_i,
	input wire					   		E_stall_i,
	input wire [`STORE_WIDTH - 1:0]  	DD_store_op_i,
	input wire [`LOAD_WIDTH - 1:0]   	DD_load_op_i,
	input wire					   		DD_sel_reg_i,
	input wire [`XLEN - 1:0]			DD_rs2_data_i,
	input wire                       	DD_need_dstE_i,
	input wire [4:0]                 	DD_dstE_i,
	input wire [`XLEN - 1:0]			E_valE_i,
	input wire [`PC_WIDTH - 1:0]    	E_jmp_i,
	input wire							E_jmp_sel_i,
	
	output reg [`STORE_WIDTH - 1:0]  	ED_store_op_o,
	output reg [`LOAD_WIDTH - 1:0]   	ED_load_op_o,
	output reg					   		ED_sel_reg_o,
	output reg [`XLEN - 1:0]			ED_rs2_data_o,
	output reg [`XLEN - 1:0]			ED_valE_o,
	output reg                       	ED_need_dstE_o,
	output reg [`PC_WIDTH - 1:0]    	ED_jmp_o,
	output reg							ED_jmp_sel_o,
	output reg [4:0]                 	ED_dstE_o
);
	initial begin
			ED_store_op_o 	<= 0;
			ED_load_op_o 	<= 0;
			ED_sel_reg_o	<= 0;
			ED_rs2_data_o	<= 0;
			ED_valE_o		<= 0;
			ED_need_dstE_o 	<= 0;
			ED_dstE_o		<= 0;
			ED_jmp_o		<= 0;
			ED_jmp_sel_o	<= 0;
	end
	always @(posedge clk_i) begin
		if(E_bubble_i) begin
			ED_store_op_o 	<= 0;
			ED_load_op_o 	<= 0;
			ED_sel_reg_o	<= 0;
			ED_rs2_data_o	<= 0;
			ED_valE_o		<= 0;
			ED_need_dstE_o 	<= 0;
			ED_dstE_o		<= 0;
			ED_jmp_o		<= 0;
			ED_jmp_sel_o	<= 0;
		end
		else begin
			ED_store_op_o 	<= DD_store_op_i;
			ED_load_op_o 	<= DD_load_op_i;
			ED_sel_reg_o	<= DD_sel_reg_i;
			ED_rs2_data_o	<= DD_rs2_data_i;
			ED_valE_o		<= E_valE_i;
			ED_need_dstE_o	<= DD_need_dstE_i;
			ED_dstE_o		<= DD_dstE_i;
			ED_jmp_o		<= E_jmp_i;
			ED_jmp_sel_o	<= E_jmp_sel_i;
		end
	end
endmodule