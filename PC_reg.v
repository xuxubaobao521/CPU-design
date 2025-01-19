`include "define.v"
module PC_reg(
	//input
	input wire clk_i,
	input wire PC_bubble_i,
	input wire PC_stall_i,
	input wire [`PC_WIDTH - 1 : 0] nPC_i,
	//output
	output wire [`PC_WIDTH - 1 : 0] F_PC_o
);
	reg [`PC_WIDTH - 1 : 0] PC;
	initial PC = 0;
	always @(posedge clk_i) begin
		if(PC_bubble_i) begin
			PC <= 0;
		end
		else if(~PC_stall_i) begin
			PC <= nPC_i;
		end
	end
	assign F_PC_o = PC;
endmodule