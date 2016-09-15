`timescale 1ns/1ps

`include "INSTRUCTION_FETCH.v"
`include "INSTRUCTION_DECODE.v"
`include "EXECUTION.v"
`include "MEMORY.v"

module CPU(
	clk,
	rst
);
input clk, rst;
/*============================== Wire  ==============================*/
//control
wire [1:0] slt_control1;
wire [1:0] slt_control2;
wire [1:0] XM_MemWrite;
wire [1:0] ALU_XM_MemWrite_swit;
wire [1:0] Load_MEM;
wire [1:0] ALU_Load_MEM_swit;
wire [1:0] J_control1;
wire [1:0] J_control2;
wire [1:0] J_control3;
wire [31:0] imm;
wire [31:0] J_address;
wire [31:0] temp_PC;
wire [31:0] SW_value;

// INSTRUCTION_FETCH wires
wire [31:0] FD_PC, FD_IR;
// INSTRUCTION_DECODE wires
wire [31:0] A, B;
wire [4:0] DX_RD;
wire [2:0] ALUctr;
// EXECUTION wires
wire [31:0] XM_ALUout;
wire [4:0] XM_RD;
// DATA_MEMORY wires
wire [31:0] MW_ALUout;
wire [4:0]	MW_RD;

/*============================== INSTRUCTION_FETCH  ==============================*/

INSTRUCTION_FETCH IF(
	.clk(clk),
	.rst(rst),

	.temp_PC(temp_PC),//output
	.J_control2(J_control2),//input
	.J_address(J_address),//input
	.ALUout(XM_ALUout),//input
	
	.PC(FD_PC),
	.IR(FD_IR)
);

/*============================== INSTRUCTION_DECODE ==============================*/

INSTRUCTION_DECODE ID(
	.clk(clk),
	.rst(rst),
	.PC(FD_PC),
	.IR(FD_IR),
	.MW_RD(MW_RD),
	.MW_ALUout(MW_ALUout),

	.slt_control1(slt_control1),//output
	.ALU_Load_MEM_swit(ALU_Load_MEM_swit),//output
	.ALU_XM_MemWrite_swit(ALU_XM_MemWrite_swit),//output
	.SW_value(SW_value),//ouput
	.J_control1(J_control1),//output
	.imm(imm),//output
	
	.A(A),
	.B(B),
	.RD(DX_RD),
	.ALUctr(ALUctr)
);

/*==============================     EXECUTION  	==============================*/

EXECUTION EXE(
	.clk(clk),
	.rst(rst),
	.A(A),
	.B(B),
	.DX_RD(DX_RD),
	.ALUctr(ALUctr),
	
	.slt_control1(slt_control1),//input
	.slt_control2(slt_control2),//output
	.ALU_Load_MEM_swit(ALU_Load_MEM_swit),//input
	.Load_MEM(Load_MEM),//output
	.ALU_XM_MemWrite_swit(ALU_XM_MemWrite_swit),//input
	.XM_MemWrite(XM_MemWrite),//ouput
	.J_control1(J_control1),//input
	.J_control2(J_control2),
	.J_address(J_address),//output
	.imm(imm),//input
	.temp_PC(temp_PC),//input
	
	.ALUout(XM_ALUout),
	.XM_RD(XM_RD)
);

/*==============================     DATA_MEMORY	==============================*/

MEMORY MEM(
	.clk(clk),
	.rst(rst),
	.ALUout(XM_ALUout),
	.XM_RD(XM_RD),
	
	.slt_control2(slt_control2),//input
	.IR(FD_IR),
	.XM_MemWrite(XM_MemWrite),
	.Load_MEM(Load_MEM),
	.SW_value(SW_value),//input
	.J_control2(J_control2),//input
	.J_control3(J_control3),//output

	.MW_ALUout(MW_ALUout),
	.MW_RD(MW_RD)
);

endmodule
