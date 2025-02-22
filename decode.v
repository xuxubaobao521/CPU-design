`include "define.v"
module decode(
	//input
	input                     clk_i,
	input wire [4:0]		  D_rs1_i,
	input wire [4:0]		  D_rs2_i,
	input wire                MD_need_dstE_i,
	input wire [4:0]          MD_dstE_i,
	input wire [`XLEN - 1:0]  data_i,
	//output
	output wire [`XLEN - 1:0] D_rs1_data_o,
	output wire [`XLEN - 1:0] D_rs2_data_o
);
	reg[`XLEN - 1:0] reg_file[`XLEN - 1:0];
	initial begin
		reg_file[0] = 0;
	end
	always @(posedge clk_i) begin
		if(MD_need_dstE_i) reg_file[MD_dstE_i] <= data_i;
	end
	assign D_rs1_data_o = reg_file[D_rs1_i];
	assign D_rs2_data_o = reg_file[D_rs2_i];
endmodule