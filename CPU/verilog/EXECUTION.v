`timescale 1ns/1ps

module EXECUTION(
	clk,
	rst,
	DX_MemtoReg,
	DX_RegWrite,
	DX_MemRead,
	DX_MemWrite,
	DX_branch,
	ALUctr,
	NPC,
	A,
	B,
	imm,
	DX_RD,
	DX_MD,

	XM_MemtoReg,
	XM_RegWrite,
	XM_MemRead,
	XM_MemWrite,
	XM_branch,
	ALUout,
	XM_RD,
	XM_MD,
	XM_BT
);
input clk, rst, DX_MemtoReg, DX_RegWrite, DX_MemRead, DX_MemWrite, DX_branch;
input [2:0] ALUctr;
input [31:0] NPC, A, B, DX_MD;
input [15:0]imm;
input [4:0] DX_RD;

output reg XM_MemtoReg, XM_RegWrite, XM_MemRead, XM_MemWrite, XM_branch;
output reg [31:0]ALUout, XM_BT, XM_MD;
output reg [4:0] XM_RD;

always @(posedge clk)
begin
	if(rst) begin
		XM_MemtoReg	<= 1'b0;
		XM_RegWrite	<= 1'b0;
		XM_MemRead 	<= 1'b0;
		XM_MemWrite	<= 1'b0;
		XM_branch	<= 1'b0;
	end else begin
		XM_MemtoReg	<= DX_MemtoReg;
		XM_RegWrite	<= DX_RegWrite;
		XM_MemRead 	<= DX_MemRead;
		XM_MemWrite	<= DX_MemWrite;
		XM_RD 	  	<= DX_RD;
		XM_MD 	  	<= DX_MD;
		XM_branch	<= ((ALUctr==6) && (A == B) && DX_branch);	//TA fail
		XM_BT		<= NPC-4+{ { 14{imm[15]}}, imm, 2'b0};	//-4, because it has more than 1 cycle
	end
end

always @(posedge clk)
begin
	//$display("---EXE: ALUctr:%d, NPC:%d", ALUctr, NPC);
	/*if(((ALUctr==6) && (A == B) && DX_branch))
		$display("------EXE: NPC:%d, imm:%b", NPC, imm);*/
	case(ALUctr)
		3'd2: //and
	    	ALUout <= A & B;
	  	3'd0: //add //lw
	     	ALUout <= A + B;
	  	3'd1: //sub
	    	ALUout <= A - B;
	  	3'd3: //or
	     	ALUout <= A | B;
	  	3'd4: //slt
	     	ALUout <= (A > B) ? 32'b0 : 32'b1;
	  	3'd5: //mul
	     	ALUout <= A * B;
	  	3'd6: //branch
	     	ALUout <= 32'b0;
		default: begin
	 		ALUout <= 32'b0;
	    	$display("ERROR instruction!!");
	    end
	endcase
end


endmodule

