`include "define.v"
module write_back(
	//input
	input wire               F_sel_reg_i,
	input wire[`XLEN - 1:0]  E_data_i,
	input wire [`XLEN - 1:0] M_data_i,
	//output
	output wire[`XLEN - 1:0] W_data_o
);
	assign W_data_o = (F_sel_reg_i) ? E_data_i : M_data_i;
endmodule