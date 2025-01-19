`include "define.v"
module fetch_reg(
	//input
	input wire						clk_i,
	input wire						F_bubble_i,
	input wire						F_stall_i,
	input wire[`INSTR_WIDTH - 1:0]	instr_i,
	input wire[`PC_WIDTH - 1:0]		F_PC_i,
	//output
	output reg[`INSTR_WIDTH - 1:0]	FD_instr_o,
	output reg[`PC_WIDTH - 1:0]		FD_PC_o
);
	initial begin
			FD_instr_o	<=0;
			FD_PC_o		<=0;
	end
	always @(posedge clk_i) begin
		if(F_bubble_i) begin
			FD_instr_o	<=0;
			FD_PC_o		<=0;
		end
		else if(~F_stall_i)begin
			FD_instr_o	<=instr_i;
			FD_PC_o		<=F_PC_i;
		end
	end
endmodule