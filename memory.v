`include "define.v"
module memory(
	//input
	input clk_i,
	input wire [`STORE_WIDTH - 1:0]  F_store_op_i,
	input wire [`LOAD_WIDTH - 1:0]	 F_load_op_i,
	input wire [`XLEN - 1:0]         addr_i,
	input wire [`XLEN - 1:0]		 data_i,
	//output
	output wire [`XLEN - 1:0]        data_o
);
	reg[7:0] data_mem[1023:0];
	initial begin
	end
	//load OP
	wire load_lb = F_load_op_i[`load_lb];
	wire load_lh = F_load_op_i[`load_lh];
	wire load_lw = F_load_op_i[`load_lw];
	wire load_ld = F_load_op_i[`load_ld];
	wire load_lbu = F_load_op_i[`load_lbu];
	wire load_lhu = F_load_op_i[`load_lhu];
	wire load_lwu = F_load_op_i[`load_lwu];
	//store
	wire store_sb = F_store_op_i[`store_sb];
	wire store_sh = F_store_op_i[`store_sh];
	wire store_sw = F_store_op_i[`store_sw];
	wire store_sd = F_store_op_i[`store_sd];
	
	//load / store
	wire op_load = load_lb | load_lh | load_lw | load_ld | load_lbu | load_lhu | load_lwu;
	wire op_store = store_sb | store_sh | store_sw | store_sd;
	
	//data store
	wire [`XLEN - 1:0]data_sb = {{56{1'b1}}, {8{1'b0}}};
	wire [`XLEN - 1:0]data_sh = {{48{1'b1}}, {16{1'b0}}};
	wire [`XLEN - 1:0]data_sw = {{32{1'b1}}, {32{1'b0}}};
	wire [`XLEN - 1:0]data_sd = {64{1'b0}};

	wire [`XLEN - 1:0] mask = 		({`XLEN{store_sb}} & data_sb) |
									({`XLEN{store_sh}} & data_sh) |
									({`XLEN{store_sw}} & data_sw) |
									({`XLEN{store_sd}} & data_sd);
	//读出数据
	wire [`XLEN - 1:0] data = {	data_mem[addr_i + 7],data_mem[addr_i + 6],data_mem[addr_i + 5],data_mem[addr_i + 4],
								data_mem[addr_i + 3],data_mem[addr_i + 2],data_mem[addr_i + 1],data_mem[addr_i + 0]};
	wire [`XLEN - 1:0] write_data = (mask & data) | (~mask & data_i);
	//读入数据
	always@(posedge clk_i) begin
		if(op_store) begin
			{data_mem[addr_i + 7],data_mem[addr_i + 6],data_mem[addr_i + 5],data_mem[addr_i + 4],
			data_mem[addr_i + 3],data_mem[addr_i + 2],data_mem[addr_i + 1],data_mem[addr_i + 0]} <= write_data;
		end
	end
	
	//data load
	wire [`XLEN - 1:0]data_lb = {{56{data[7]}},data[7:0]};
	wire [`XLEN - 1:0]data_lh = {{48{data[15]}},data[15:0]};
	wire [`XLEN - 1:0]data_lw = {{32{data[31]}},data[31:0]};
	wire [`XLEN - 1:0]data_ld = data;
	wire [`XLEN - 1:0]data_lbu = {{56{1'b0}},data[7:0]};
	wire [`XLEN - 1:0]data_lhu = {{48{1'b0}},data[15:0]};
	wire [`XLEN - 1:0]data_lwu = {{32{1'b0}},data[31:0]};
	assign data_o = 	({`XLEN{load_lb}} & data_lb) |
						({`XLEN{load_lh}} & data_lh) |
						({`XLEN{load_lw}} & data_lw) |
						({`XLEN{load_ld}} & data_ld) |
						({`XLEN{load_lbu}} & data_lbu) |
						({`XLEN{load_lhu}} & data_lhu) |
						({`XLEN{load_lwu}} & data_lwu);
						
endmodule