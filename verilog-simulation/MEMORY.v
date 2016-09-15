`timescale 1ns/1ps

module MEMORY(
	clk,
	rst,
	ALUout,
	XM_RD,

	slt_control2,
	IR,//control
	XM_MemWrite,//control
	Load_MEM,//control
	J_control2,
	J_control3,
	SW_value,
	
	MW_ALUout,
	MW_RD
);

input [1:0] slt_control2;//control
input [31:0]IR;//control
input [1:0]XM_MemWrite;//control
input [1:0]Load_MEM;//control
reg [31:0]temp;
input [1:0] J_control2;
output reg [1:0] J_control3;
input [31:0] SW_value;

input clk, rst;
input [31:0] ALUout;
input [4:0] XM_RD;

output reg [31:0] MW_ALUout;
output reg [4:0] MW_RD;

//data memory
reg [31:0] DM [0:127];

//always store word to data memory
always @(posedge clk)
begin
  
  if(slt_control2)
  begin
	if(ALUout[31]==1) // a < b
		MW_ALUout	<=	32'b00000000000000000000000000000001;
	else	MW_ALUout	<=	32'b0;
	MW_RD		<=	XM_RD;
  end
  
  if(XM_MemWrite)
  begin
	DM[ALUout[6:0] >> 2] <= SW_value;//XM_MD;
	//$display("-----------MEM, DM[ALUout[6:0]]:%d, ALUout:%d, XM_RD:%d", DM[ALUout[6:0]], ALUout, XM_RD);
  end
  
  if(Load_MEM)
  begin
	MW_ALUout	<=	DM[ALUout[6:0] >> 2];
	MW_RD		<=	XM_RD;
  end
	
end

//send to Dst REG: "load word from data memory" or  "ALUout"
always @(posedge clk or posedge rst)
begin
  if(rst)
    begin
	  MW_ALUout	<=	32'b0;
	  MW_RD		<=	5'b0;
	end
  else
    begin
		if(!slt_control2 && !XM_MemWrite && !Load_MEM)// && ALUout)
		begin
			MW_ALUout	<=	ALUout;
			MW_RD		<=	XM_RD;
			//$display("-----------MEM, IR:%b, MW_ALUout:%d, MW_RD:%d", IR, MW_ALUout, MW_RD);
		end
		
		J_control3 <= 1'b0;
		if(J_control2)
			begin
				if(ALUout==0) J_control3 <= 1'b1;
			end		
	end
end

endmodule
