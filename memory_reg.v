`include "define.v"
module memory_reg(
	//input
	input wire						clk_i,
	input wire 					   	M_bubble_i,
	input wire					   	M_stall_i,
	input wire					   	ED_sel_reg_i,
	input wire [`XLEN - 1:0]		ED_valE_i,
	input wire [`XLEN - 1:0]		M_valM_i,
	input wire                      ED_need_dstE_i,
	input wire [4:0]                ED_dstE_i,
	//output
	output reg					   		MD_sel_reg_o,
	output reg [`XLEN - 1:0]			MD_valM_o,
	output reg [`XLEN - 1:0]			MD_valE_o,
	output reg                      	MD_need_dstE_o,
	output reg [4:0]                	MD_dstE_o
);
	initial begin
		MD_sel_reg_o 	<= 0;
		MD_valM_o		<= 0;
		MD_valE_o		<= 0;
		MD_need_dstE_o	<= 0;
		MD_dstE_o		<= 0;
	end
	always @(posedge clk_i) begin
		if(M_bubble_i)begin
			MD_sel_reg_o 	<= 0;
			MD_valM_o		<= 0;
			MD_valE_o		<= 0;
			MD_need_dstE_o	<= 0;
			MD_dstE_o		<= 0;
		end
		else if(~M_stall_i)begin
			MD_sel_reg_o 	<= ED_sel_reg_i;
			MD_valM_o		<= M_valM_i;
			MD_valE_o		<= ED_valE_i;
			MD_need_dstE_o	<= ED_need_dstE_i;
			MD_dstE_o		<= ED_dstE_i;
		end
	end
endmodule