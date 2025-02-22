`include "define.v"
module csr(
	input wire clk_i,
	input wire [`CSR_WIDTH - 1:0]	F_csr_op_i,
	input wire [`XLEN - 1:0]		data_i,
	input wire [11:0]				addr_i,
	//output
	output wire [`XLEN - 1:0] D_csr_data_o
);
	reg[`XLEN - 1:0] csr_reg[`CSR_NUMBER - 1 : 0];
	initial begin
		csr_reg[0] = 64'hffffffff00000000;
	end
	wire en_csr = |F_csr_op_i;
	always @(posedge clk_i) begin
		if(en_csr) csr_reg[addr_i] <= data_i;
	end
	assign D_csr_data_o = csr_reg[addr_i];
endmodule