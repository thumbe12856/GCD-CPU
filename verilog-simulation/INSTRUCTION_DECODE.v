`timescale 1ns/1ps

module INSTRUCTION_DECODE(
	clk,
	rst,
	IR,
	PC,
	MW_RD,
	MW_ALUout,

	slt_control1,//control
	ALU_Load_MEM_swit,//control
	ALU_XM_MemWrite_swit,//control
	SW_value,
	J_control1,//control
	imm,
	
	A,
	B,
	RD,
	ALUctr
);

output reg [1:0] slt_control1;
output reg [1:0] J_control1;
output reg [1:0] ALU_XM_MemWrite_swit;
output reg [1:0] ALU_Load_MEM_swit;
output reg [31:0] imm;
output reg [31:0] SW_value;

input clk,rst;
input [31:0]IR, PC, MW_ALUout;
input [4:0] MW_RD;

output reg [31:0] A, B;
output reg [4:0] RD;
output reg [2:0] ALUctr;

//register file
reg [31:0] REG [0:31];

//Write back
always @(posedge clk)//add new Dst REG source here
begin
	//$display("-----------ID, IR:%b, MW_RD:%d, MW_ALUout:%d", IR, MW_RD, MW_ALUout);
	if(MW_RD)
	  REG[MW_RD] <= MW_ALUout;
	else
	  REG[MW_RD] <= REG[MW_RD];//keep REG[0] always equal zero
	  
end

//set A, and other register content(j/beq flag and address)	
always @(posedge clk or posedge rst)
begin
	if(rst) 
	  begin
	    A 	<=32'b0;
	  end 
	else 
	  begin
	    A 	<=REG[IR[25:21]];
	  end
end

//set control signal, choose Dst REG, and set B	
always @(posedge clk or posedge rst)
begin
	if(rst) 
	  begin
		B 		<=32'b0;
		RD 		<=5'b0;
		ALUctr 	<=3'b0;
	  end 
	else 
	  //$display("--------ID, IR:%b",IR);
	  begin
	  slt_control1 <= 1'b0;
	  ALU_XM_MemWrite_swit <= 1'b0;
	  ALU_Load_MEM_swit <= 1'b0;
	  J_control1 <= 1'b0;
	    case(IR[31:26])
		  6'd0://R-Type
		    begin
			  case(IR[5:0])//funct & setting ALUctr
			    6'd32://add
				  begin
		            B	<=REG[IR[20:16]];//rt
		            RD	<=IR[15:11];//rd
					ALUctr <=3'b010;
				  end
				6'd34://sub
				  begin
					//define sub behavior here
					B	<=REG[IR[20:16]];//rt
		            RD	<=IR[15:11];//rd
					ALUctr <=3'b110;
				  end
				6'd42://slt
				  begin
					//define slt behavior here
					slt_control1 <= 1'b1;
					B	<=REG[IR[20:16]];//rt
		            RD	<=IR[15:11];//rd
					ALUctr <=3'b110;
				  end
			  endcase
			end
	      6'd35://lw
			begin
			  ALU_Load_MEM_swit <= 1'b1;
			  B	<=  {{16{IR[15]}}, IR[15:0]};//rt
			  RD <= IR[20:16];//rd
			  ALUctr <=3'b010;
			end
	      6'd43://sw
			begin
			  //define sw behavior here
			  ALU_XM_MemWrite_swit <= 1'b1;
			  B	<=  {{16{IR[15]}}, IR[15:0]};//rt
			  RD <= IR[20:16];//rd
			  SW_value <= REG[IR[20:16]];//rd
			  ALUctr <=3'b010;
			end
	      6'd4://beq
			begin
			  //define beq behavior here
			  J_control1 <= 1'b1;
			  B	<=REG[IR[20:16]];//rt
			 
			  
			  if(IR[15]==1)
				begin
					imm[31] <= 1;
					imm[30] <= 0;
					imm[29] <= 0;
					imm[28] <= 0;
					imm[27] <= 0;
					imm[26] <= 0;
					imm[25] <= 0;
					imm[24] <= 0;
					imm[23] <= 0;
					imm[22] <= 0;
					imm[21] <= 0;
					imm[20] <= 0;
					imm[19] <= 0;
					imm[18] <= 0;
					imm[17] <= 0;
					imm[16] <= 0;
					imm[15] <= 0;
					imm[14] <= 0;
					imm[13] <= 0;
					imm[12] <= 0;
					imm[11] <= 0;
					imm[10] <= 0;
					imm[9] <= !IR[9];
					imm[8] <= !IR[8];
					imm[7] <= !IR[7];
					imm[6] <= !IR[6];
					imm[5] <= !IR[5];
					imm[4] <= !IR[4];
					imm[3] <= !IR[3];
					imm[2] <= !IR[2];
					imm[1] <= !IR[1];
					imm[0] <= !IR[0];
				end
			  else imm <= {{16{IR[15]}}, IR[15:0]};//rt
			  
			  //$display("+++++++++beq+++++++++++, imm:%b", {{16{IR[15]}}, IR[15:0]});
			  ALUctr <=3'b110;
			end
	      6'd2://j
			begin
			  //define j behavior here
			  //PC <= {4'b0, IR[25:0]<<2};
			  ALUctr <=3'b000;
			end
		endcase
	  end
end
endmodule
