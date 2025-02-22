`include "define.v"
`timescale 1ns/1ns
module CPU();
	reg clk;
	wire						PC_stall;
	reg							PC_bubble;
	//********************************
	//fetch
	//********************************
	//op
	wire [`OP_WIDTH - 1:0]     F_epcode;
	wire [`STORE_WIDTH - 1:0]  F_store_op;
	wire [`LOAD_WIDTH - 1:0]   F_load_op;
	wire [`CSR_WIDTH - 1:0]	   F_csr_op;
	wire [`BRANCH_WIDTH - 1:0] F_branch_op;
	wire [`ALU_WIDTH - 1:0]    F_ALU_op;
	wire					   F_sel_reg;
	wire [`PC_WIDTH - 1:0]     F_PC;
	//data
	wire [`PC_WIDTH - 1:0]     nPC;
	wire [`INSTR_WIDTH - 1:0]  instr;
	wire [4:0]                 F_rs1;
	wire [4:0]                 F_rs2;
	wire [`XLEN - 1:0]         F_imme;
	//addr
	wire                       F_need_dstE;
	wire [4:0]                 F_dstE;
	wire [11:0]				   F_csr_addr;
	wire [`PC_WIDTH - 1:0]	   F_sel_PC;
	
	wire					   mini_jmp_sel;
	wire [`PC_WIDTH - 1:0]	   mini_jmp;
	//********************************
	//fetch_reg
	//********************************
	//
	wire 					   F_bubble;
	wire					   F_stall;
	//op
	wire [`INSTR_WIDTH - 1:0]	FD_instr;
	wire [`PC_WIDTH - 1:0]     	FD_PC;
	//********************************
	//decode
	//********************************

	wire						D_sel_reg;
	wire [4:0]                 	D_rs1;
	wire [4:0]                 	D_rs2;
	wire [11:0]				  	D_csr_addr;
	wire                       	D_need_dstE;
	wire [4:0]                 	D_dstE;
	wire [`OP_WIDTH - 1:0]     	D_epcode;
	wire [`BRANCH_WIDTH - 1:0] 	D_branch_op;
	wire [`STORE_WIDTH - 1:0]  	D_store_op;
	wire [`LOAD_WIDTH - 1:0]	D_load_op;
	wire [`CSR_WIDTH - 1:0]	  	D_csr_op;
	wire [`XLEN - 1:0]         	D_imme;
	wire [`ALU_WIDTH - 1:0]    	D_ALU_op;
	wire [`XLEN - 1:0] 			D_rs1_data;
	wire [`XLEN - 1:0] 			D_rs2_data;

	wire [`XLEN - 1:0] 			D_csr_data;
	
	wire [`XLEN - 1:0] D_fwdA;
	wire [`XLEN - 1:0] D_fwdB;
	//********************************
	//decode reg
	//********************************
	wire 					   		D_bubble;
	reg					   			D_stall;
	wire [`OP_WIDTH - 1:0]     		DD_epcode;
	wire [`STORE_WIDTH - 1:0]  		DD_store_op;
	wire [`LOAD_WIDTH - 1:0]   		DD_load_op;
	wire [`CSR_WIDTH - 1:0]			DD_csr_op;
	wire [`BRANCH_WIDTH - 1:0] 		DD_branch_op;
	wire [`ALU_WIDTH - 1:0]    		DD_ALU_op;
	wire					   		DD_sel_reg;
	wire [`PC_WIDTH - 1:0]     		DD_PC;
	wire                       		DD_need_dstE;
	wire [4:0]                 		DD_dstE;
	wire [11:0]				   		DD_csr_addr;
	wire [`XLEN - 1:0]				DD_rs1_data;
	wire [`XLEN - 1:0]				DD_rs2_data;
	wire [`XLEN - 1:0] 				DD_csr_data;
	wire [`XLEN - 1:0] 				DD_imme;
	//********************************
	//execute
	//********************************
	wire [`XLEN - 1:0]		E_valE;
	wire [`XLEN - 1:0]		E_jmp;
	wire 					E_jmp_sel;
	wire [`XLEN - 1:0]		E_csr_data;
	
	//********************************
	//execute reg
	//********************************
	reg 						E_bubble;
	reg					   		E_stall;
	wire [`STORE_WIDTH - 1:0]  	ED_store_op;
	wire [`LOAD_WIDTH - 1:0]   	ED_load_op;
	wire					   	ED_sel_reg;
	wire [`XLEN - 1:0]			ED_rs2_data;
	wire [`XLEN - 1:0]			ED_valE;
	wire                       	ED_need_dstE;
	wire [4:0]                 	ED_dstE;
	wire [`PC_WIDTH - 1:0]    	ED_jmp;
	wire						ED_jmp_sel;
	//********************************
	//memory
	//********************************
	wire [`XLEN - 1:0]        M_valM;
	//********************************
	//memory_reg
	//********************************
	reg							M_bubble;
	reg							M_stall;
	wire				   		MD_sel_reg;
	wire [`XLEN - 1:0]			MD_valM;
	wire [`XLEN - 1:0]			MD_valE;
	wire                       	MD_need_dstE;
	wire [4:0]                 	MD_dstE;
	//********************************
	//write_back
	//********************************
	wire [`XLEN - 1:0]        W_data;
	
	initial clk = 0;
	always #20 clk = ~clk;
	//********************************
	//hazard_control
	//********************************
	hazard_control hazard_control(
		.D_epcode_i(D_epcode),
		.DD_epcode_i(DD_epcode),
		.D_rs1_i(D_rs1),
		.D_rs2_i(D_rs2),
		.DD_dstE_i(DD_dstE),
		.DD_need_dstE_i(DD_need_dstE),
		.E_jmp_sel_o(E_jmp_sel),

		.PC_stall_o(PC_stall),
		.F_stall_o(F_stall),
		.F_bubble_o(F_bubble),
		.D_bubble_o(D_bubble)
	);
	//********************************
	//hazard_control
	//********************************
	
	//********************************
	//fetch
	//********************************
	initial begin
		PC_bubble <= 0;
		D_stall <=0;
		E_bubble <=0;
		E_stall <= 0;
		M_bubble <=0;
		M_stall <= 0;
	end
	PC_reg PC(
		//in
		.clk_i(clk),
		.PC_bubble_i(PC_bubble),
		.PC_stall_i(PC_stall),
		.nPC_i(nPC),
		//out
		.F_PC_o(F_PC)
	);
	PC_sel PC_sel(
		//in
		.ED_jmp_sel_i(ED_jmp_sel),
		.ED_jmp_i(ED_jmp),
		//out
		.F_PC_i(F_PC),
		.F_sel_PC_o(F_sel_PC)
	);
	PC_instr PC_instr(
		//in
		.F_PC_i(F_sel_PC),
		//out
		.instr_o(instr),
		.mini_jmp_o(mini_jmp),
		.mini_jmp_sel_o(mini_jmp_sel)
	);
	PC_next PC_next(
		//in
		.F_PC_i(F_sel_PC),
		.mini_jmp_sel_i(mini_jmp_sel),
		.mini_jmp_i(mini_jmp),
		//out
		.nPC_o(nPC)
	);
	fetch_reg fetch_reg(
		//input
		.clk_i(clk),
		.F_stall_i(F_stall),
		.F_bubble_i(F_bubble),
		.instr_i(instr),
		.F_PC_i(F_sel_PC),
		//output
		.FD_PC_o(FD_PC),
		.FD_instr_o(FD_instr)
	);
	//********************************
	//fetch
	//********************************
	
	
	//********************************
	//decode
	//********************************
	id id(
		//input
		.FD_instr_i(FD_instr),
		//output
		//OP
		.D_epcode_o(D_epcode),
		.D_branch_op_o(D_branch_op),
		.D_store_op_o(D_store_op),
		.D_load_op_o(D_load_op),
		.D_csr_op_o(D_csr_op),
		.D_ALU_op_o(D_ALU_op),
		.D_need_dstE_o(D_need_dstE),
		.D_sel_reg_o(D_sel_reg),
		//data
		.D_rs1_o(D_rs1),
		.D_rs2_o(D_rs2),
		.D_imme_o(D_imme),
		//addr
		.D_dstE_o(D_dstE),
		.D_csr_addr_o(D_csr_addr)
	);
	csr csr(
		//input
		.clk_i(clk),
		.F_csr_op_i(D_csr_op),
		.data_i(E_csr_data),
		.addr_i(D_csr_addr),
		//output
		.D_csr_data_o(D_csr_data)
	);
	decode decode(
		//in
		.clk_i(clk),
		.D_rs1_i(D_rs1),
		.D_rs2_i(D_rs2),
		.MD_need_dstE_i(MD_need_dstE),
		.MD_dstE_i(MD_dstE),
		.data_i(W_data),
		//out
		.D_rs1_data_o(D_rs1_data),
		.D_rs2_data_o(D_rs2_data)
	);
	fwd fwd(
		.D_rs1_i(D_rs1),
		.D_rs2_i(D_rs2),
		
		.D_rs1_data_i(D_rs1_data),
		.D_rs2_data_i(D_rs2_data),
			
		.DD_need_dstE_i(DD_need_dstE),
		.DD_dstE_i(DD_dstE),
		.E_valE_i(E_valE),

		.ED_need_dstE_i(ED_need_dstE),
		.ED_dstE_i(ED_dstE),
		.ED_sel_reg_i(ED_sel_reg),
		.ED_valE_i(ED_valE),
		.M_valM_i(M_valM),
	
		.MD_need_dstE_i(MD_need_dstE),
		.MD_dstE_i(MD_dstE),
		.W_data_i(W_data),

		.D_fwdA_o(D_fwdA),
		.D_fwdB_o(D_fwdB)
	);
	decode_reg decode_reg(
		//input
		.clk_i(clk),
		.D_bubble_i(D_bubble),
		.D_stall_i(D_stall),
		.D_epcode_i(D_epcode),
		.D_store_op_i(D_store_op),
		.D_load_op_i(D_load_op),
		.D_csr_op_i(D_csr_op),
		.D_branch_op_i(D_branch_op),
		.D_ALU_op_i(D_ALU_op),
		.D_sel_reg_i(D_sel_reg),
		.D_PC_i(FD_PC),
		.D_need_dstE_i(D_need_dstE),
		.D_dstE_i(D_dstE),
		.D_csr_addr_i(D_csr_addr),
		.D_rs1_data_i(D_fwdA),
		.D_rs2_data_i(D_fwdB),
		.D_csr_data_i(D_csr_data),
		.D_imme_i(D_imme),
	//output
		.DD_epcode_o(DD_epcode),
		.DD_store_op_o(DD_store_op),
		.DD_load_op_o(DD_load_op),
		.DD_csr_op_o(DD_csr_op),
		.DD_branch_op_o(DD_branch_op),
		.DD_ALU_op_o(DD_ALU_op),
		.DD_sel_reg_o(DD_sel_reg),
		.DD_PC_o(DD_PC),
		.DD_need_dstE_o(DD_need_dstE),
		.DD_dstE_o(DD_dstE),
		.DD_csr_addr_o(DD_csr_addr),
		.DD_rs1_data_o(DD_rs1_data),
		.DD_rs2_data_o(DD_rs2_data),
		.DD_csr_data_o(DD_csr_data),
		.DD_imme_o(DD_imme)
	);
	//********************************
	//decode
	//********************************
	
	//********************************
	//execute
	//********************************
	execute execute(
		//in
		.D_csr_data_i(DD_csr_data),
		.F_csr_op_i(DD_csr_op),
		.D_rs1_data_i(DD_rs1_data),
		.D_rs2_data_i(DD_rs2_data),
		.F_epcode_i(DD_epcode),
		.F_branch_op_i(DD_branch_op),
		.F_imme_i(DD_imme),
		.F_ALU_op_i(DD_ALU_op),
		.F_PC_i(DD_PC),
		//out
		.E_valE_o(E_valE),
		.E_jmp_o(E_jmp),
		.E_csr_data_o(E_csr_data),
		.E_jmp_sel_o(E_jmp_sel)
	);
	execute_reg execute_reg(
		//in
		.clk_i(clk),
		.E_bubble_i(E_bubble),
		.E_stall_i(E_stall),
		.DD_dstE_i(DD_dstE),
		.DD_need_dstE_i(DD_need_dstE),
		.DD_store_op_i(DD_store_op),
		.DD_load_op_i(DD_load_op),
		.DD_sel_reg_i(DD_sel_reg),
		.DD_rs2_data_i(DD_rs2_data),
		.E_valE_i(E_valE),
		.E_jmp_i(E_jmp),
		.E_jmp_sel_i(E_jmp_sel),
	
		.ED_store_op_o(ED_store_op),
		.ED_need_dstE_o(ED_need_dstE),
		.ED_dstE_o(ED_dstE),
		.ED_load_op_o(ED_load_op),
		.ED_sel_reg_o(ED_sel_reg),
		.ED_jmp_o(ED_jmp),
		.ED_jmp_sel_o(ED_jmp_sel),
		.ED_rs2_data_o(ED_rs2_data),
		.ED_valE_o(ED_valE)
	);
	//********************************
	//execute
	//********************************
	memory memory(
		//input
		.clk_i(clk),
		.F_store_op_i(ED_store_op),
		.F_load_op_i(ED_load_op),
		.addr_i(ED_valE),
		.data_i(ED_rs2_data),
		//output
		.data_o(M_valM)
	);
	memory_reg memory_reg(
		//input
		.clk_i(clk),
		.M_bubble_i(M_bubble),
		.M_stall_i(M_stall),
		.ED_sel_reg_i(ED_sel_reg),
		.ED_valE_i(ED_valE),
		.M_valM_i(M_valM),
		.ED_need_dstE_i(ED_need_dstE),
		.ED_dstE_i(ED_dstE),
		
		//output
		.MD_need_dstE_o(MD_need_dstE),
		.MD_dstE_o(MD_dstE),
		.MD_sel_reg_o(MD_sel_reg),
		.MD_valM_o(MD_valM),
		.MD_valE_o(MD_valE)
	);
	//********************************
	//write_back
	//********************************
	write_back write_back(
		//input
		.F_sel_reg_i(MD_sel_reg),
		.M_data_i(MD_valM),
		.E_data_i(MD_valE),
		//output
		.W_data_o(W_data)
	);
endmodule
