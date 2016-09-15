`timescale 1ns/1ps

`include "DATA_MEMORY.v"

module MEMORY(
	clk,
	rst,
	XM_MemtoReg,
	XM_RegWrite,
	XM_MemRead,
	XM_MemWrite,
	ALUout,
	XM_RD,
	XM_MD,

	bsy,
	haddr,
	dm_write,
	//hdin,
	/*cih*/
	hdin1,
	hdin2,
	gcd_answer,
	
	dm_out,

	MW_MemtoReg,
	MW_RegWrite,
	MW_ALUout,
	MDR,
	MW_RD
);
input clk, rst, XM_MemtoReg, XM_RegWrite, XM_MemRead, XM_MemWrite, dm_write;

input bsy;

//cih
output [31:0] gcd_answer;
wire [31:0] temp_gcd_answer;
assign gcd_answer = temp_gcd_answer;
input [31:0] hdin1;
input [31:0] hdin2;

input [31:0] ALUout, XM_MD, haddr;
input [4:0] XM_RD;


output reg MW_MemtoReg, MW_RegWrite;
output reg [31:0]	MW_ALUout;
output reg [4:0]	MW_RD;
output [31:0] MDR, dm_out;
wire write_en;


/*================================ MEMORY_INOUTPUT ===============================*/
wire [7:0] address;
wire [31:0] din;

assign address 	= (haddr == 32'b0) ? 8'd0 :  (bsy) ?  ALUout[9:2]: 8'd0; //¿ï¾Ü¦ì¸m
assign din      = (haddr == 32'b0) ? hdin1:  XM_MD;

assign dm_out = MDR;

assign write_en	= (!XM_MemRead && XM_MemWrite) || dm_write;

DATA_MEMORY DM(
	.clk(clk),
	.wea(write_en),
	.addr(address),
	.din(din),
	.dout(MDR),
	
	.hdin1(hdin1),
	.hdin2(hdin2),
	.gcd_answer(temp_gcd_answer)
);


always @(posedge clk)
if (rst) begin
	MW_MemtoReg 		<= 1'b0;
	MW_RegWrite 		<= 1'b0;
end
else begin
	/*$display("");
	$display("---MEM: bsy:%b, hdin1:%b, haddr:%b, XM_MD:%b, ALUout:%b", bsy, hdin1, haddr, XM_MD, ALUout);
	$display("-----MEM: din:%b, dm_out:%b, address:%b", din, dm_out, ((haddr == 32'b0) ? 8'b00100000 :  (bsy) ?  ALUout[9:2]: 8'b00110000) );*/
	MW_MemtoReg 		<= XM_MemtoReg;
	MW_RegWrite 		<= XM_RegWrite;
	MW_ALUout			<= ALUout;
	MW_RD 				<= XM_RD;
end


endmodule
