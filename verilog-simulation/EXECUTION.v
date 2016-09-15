`timescale 1ns/1ps

module EXECUTION(
	clk,
	rst,
	A,
	B,
	DX_RD,
	ALUctr,

	slt_control1,
	slt_control2,
	ALU_XM_MemWrite_swit,
	XM_MemWrite,
	ALU_Load_MEM_swit,
	Load_MEM,
	J_control1,
	J_control2,
	J_address,
	imm,
	temp_PC,
	
	ALUout,
	XM_RD
);

input [1:0] slt_control1;
output reg [1:0] slt_control2;
input [1:0]ALU_XM_MemWrite_swit;//control
input [1:0]ALU_Load_MEM_swit;//control
output reg [1:0]XM_MemWrite;//control
output reg [1:0]Load_MEM;//control
input [1:0] J_control1;
output reg [1:0] J_control2;
output reg [31:0] J_address;
input [31:0] imm;
reg [31:0] temp_imm;
input [31:0] temp_PC;

input clk,rst,ALUop;
input [31:0] A,B;
input [4:0]DX_RD;
input [2:0] ALUctr;


output reg [31:0]ALUout;
output reg [4:0]XM_RD;



//set pipeline register
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  XM_RD	<= 5'd0;
	end 
  else 
	begin
	  XM_RD <= DX_RD;
	end
end

// calculating ALUout
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  ALUout	<= 32'd0;
	end 
  else
	//$display("--------EXE, ALUctr:%d, J_control1:%d, imm:%b", ALUctr, J_control1, imm);
	temp_imm <= imm;
	begin
	Load_MEM <= 1'b0;
	XM_MemWrite<=1'b0;
	J_control2 <= 1'b0;
	slt_control2 <= 1'b0;
	  case(ALUctr)
	    3'b010: //add //lw //sw
		  begin
			ALUout <=A+B;
			//$display("-----------add, ALUout:%d", ALUout);
		  end
		3'b110: //sub
		  begin
		    //define sub behavior here
			ALUout <=A-B;
			//$display("-----------sub, ALUout:%d", ALUout);
		  end
	  endcase
	  
	  if(slt_control1) slt_control2 <= 1'b1;
	  if(ALU_XM_MemWrite_swit) XM_MemWrite <= 1'b1;
	  if(ALU_Load_MEM_swit) Load_MEM <= 1'b1;
	  
	  if(J_control1)
	  begin
		if(imm[31]==1)
			begin
				J_address <= temp_PC /*+ 32'd4*/ - ((imm - 32'b1000000000000000000000000000000 + 32'b00000000000000000000000000000001)<<2);
				//$display("-----------EXE, temp_imm:%d, temp_PC:%d, J_address:%d", temp_imm, temp_PC, (temp_PC /*+ 32'd4*/ - (temp_imm<<2)));
			end
		else
			begin
				//temp_imm = imm;
				J_address <= temp_PC /*+ 32'd4*/ + (imm<<2);
				//$display("-----------EXE, temp_imm:%d, temp_PC:%d, J_address:%d", temp_imm, temp_PC, (temp_PC /*+ 32'd4*/ + (temp_imm<<2)));
			end
		
		J_control2 <= 1'b1;
	  end
	end
end
endmodule