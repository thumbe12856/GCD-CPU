`timescale 1ns/1ps

module INSTRUCTION_FETCH(
	clk,
	rst,
	
	J_control2,
	J_address,
	temp_PC,
	ALUout,
	
	PC,
	IR
);

output reg [31:0]temp_PC;
//input [1:0]J_control3;
input [1:0]J_control2;
input [31:0]J_address;
input [31:0]ALUout;

input clk, rst;
output reg 	[31:0] PC, IR;

//instruction memory
reg [31:0] instruction [127:0];

//output instruction
always @(posedge clk or posedge rst)
begin
	if(rst)
		IR <= 32'd0;
	else
		begin
			IR <= instruction[PC[10:2]];	//since pc+=4
			//$display("--------IF, IR:%b, PC:%b, J_control3:%d",IR, PC[10:0], J_control3);
		end
end

// output program counter
always @(posedge clk or posedge rst)
begin
	if(rst)
		begin
			PC <= 32'd0;
		end
	else//add new PC address here, ex: branch, jump...
		begin
			//$display("-----------IF, IR:%b, PC:%d",IR, PC[10:0]);
			case(IR[31:26])
				6'd2://j
					begin
						//$display("--------------IF,jump, IR:%b, PC:%b IR[25:0]:%d",IR, PC[10:0], IR[25:0]);
						PC <= {PC[31:28], (IR[25:0])<<2};
					end
				6'd4://beq
					begin
						temp_PC <= PC;
						PC 	<= PC+4;
					end
				default:
					begin
						if(J_control2==0)
						begin
							PC 	<= PC+4;
							//$display("********************IF, normal PC");
						end
						else if(J_control2==1 && ALUout==0)
							begin
								//$display("********************IF, J_address:%d, NOT normal PC", J_address);
								PC 	<= J_address;
							end
					end
			endcase
		end
end

endmodule