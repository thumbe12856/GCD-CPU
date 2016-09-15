`timescale 1ns / 1ps
`include "CPU.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:43:21 10/12/2014 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module top(
	 //input clk,
	 //input rst,
	 input i0,
	 input i1,
	 input i2,
	 input i3,
	 input i4,
	 input i5,
	 input i6,
	 input i7,

	
    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g,
	 output h,
	 output bbsy
    );

/*debug*/
`define CYCLE_TIME 10
`define INSTRUCTION_NUMBERS 10000
reg clk, rst, rst2;
reg [31:0] cycles, i;

initial clk = 1'b1;
always #(`CYCLE_TIME/2) clk = ~clk;
//Rst signal
initial begin
	cycles = 32'b0;
	rst = 1'b1;
	rst2 = 1'b1;
	#12 rst = 1'b0;
end

always @(posedge CLK_1M) begin
	rst2 <= 1'b0;
end

/*debug*/
wire [31:0] gcd_answer;
	
	
reg [2:0] count_div8;
reg [31:0] count;
wire [31:0] dout;
wire [31:0] data;

//wire [31:0] datain;
wire [31:0] data1in;
wire [31:0] data2in;

assign bbsy=bsy;
//assign datain={{24'b0},i7,i6,i5,i4,i3,i2,i1,i0}; //把input存入data memory
/*debug*/
//assign datain={{24'b0},8'd9}; //把input存入data memory
assign data1in={{24'b0},8'd15}; //把input1存入data memory
assign data2in={{24'b0},8'd85}; //把input2存入data memory
/*debug*/
assign CLK_1M = count_div8[2];
assign start_run = (count == 32'd3 && !rst) ? 1'b1 : 1'b0;
assign {h,g,f,e,d,c,b,a}=dout[7:0];//LED
assign wen = (count==32'd0);

CPU cpu (
  .clk(CLK_1M),
  //.rst(rst),
  /*degub*/
  
  .rst(rst2),
  //input
  .hdin1(data1in),
  .hdin2(data2in),
  .gcd_answer(gcd_answer),
  
  /*degub*/
  .wen(wen),
  .start(start_run),
  .haddr(count),
  //.hdin(datain),
  .bsy(bsy),
  .dout(dout)
);

always@(posedge clk)
begin
	if(rst)
		count_div8 <= 3'b000;
	else if (count_div8 == 3'b111)
		count_div8 <= 3'b000;
	else
		count_div8 <= count_div8 + 3'b001;
	
	//debug
	cycles <= cycles + 1;
	if (cycles == `INSTRUCTION_NUMBERS || cpu.MEM.DM.data[2]) 
	begin
		$display("cycles: %d, gcd_answer:%d", cycles, gcd_answer);
		$display("  R00-R07: %d %d %d %d %d %d %d %d", cpu.ID.REG[0], cpu.ID.REG[1], cpu.ID.REG[2], cpu.ID.REG[3],cpu.ID.REG[4], cpu.ID.REG[5], cpu.ID.REG[6], cpu.ID.REG[7]);
		$display("  R08-R15: %d %d %d %d %d %d %d %d", cpu.ID.REG[8], cpu.ID.REG[9], cpu.ID.REG[10], cpu.ID.REG[11],cpu.ID.REG[12], cpu.ID.REG[13], cpu.ID.REG[14], cpu.ID.REG[15]);
		$display("  R16-R23: %d %d %d %d %d %d %d %d", cpu.ID.REG[16], cpu.ID.REG[17], cpu.ID.REG[18], cpu.ID.REG[19],cpu.ID.REG[20], cpu.ID.REG[21], cpu.ID.REG[22], cpu.ID.REG[23]);
		$display("  R24-R31: %d %d %d %d %d %d %d %d", cpu.ID.REG[24], cpu.ID.REG[25], cpu.ID.REG[26], cpu.ID.REG[27],cpu.ID.REG[28], cpu.ID.REG[29], cpu.ID.REG[30], cpu.ID.REG[31]);
		$display("  0x00   : %d %d %d %d %d %d %d %d", cpu.MEM.DM.data[0],cpu.MEM.DM.data[1],cpu.MEM.DM.data[2],cpu.MEM.DM.data[3],cpu.MEM.DM.data[4],cpu.MEM.DM.data[5],cpu.MEM.DM.data[6],cpu.MEM.DM.data[7]);
		$display("  0x08   : %d %d %d %d %d %d %d %d", cpu.MEM.DM.data[8],cpu.MEM.DM.data[9],cpu.MEM.DM.data[10],cpu.MEM.DM.data[11],cpu.MEM.DM.data[12],cpu.MEM.DM.data[13],cpu.MEM.DM.data[14],cpu.MEM.DM.data[15]);
		
		$display("  0x112   : %d %d %d %d %d %d %d %d", cpu.MEM.DM.data[112],cpu.MEM.DM.data[113],cpu.MEM.DM.data[114],cpu.MEM.DM.data[115],cpu.MEM.DM.data[116],cpu.MEM.DM.data[117],cpu.MEM.DM.data[118],cpu.MEM.DM.data[119]);
		$display("  0x120   : %d %d %d %d %d %d %d %d", cpu.MEM.DM.data[120],cpu.MEM.DM.data[121],cpu.MEM.DM.data[122],cpu.MEM.DM.data[123],cpu.MEM.DM.data[124],cpu.MEM.DM.data[125],cpu.MEM.DM.data[126],cpu.MEM.DM.data[127]);
		$display("");
		$finish;
	end
	//$display("---Top: rst:%d, count_div8:%d, bsy:%d", rst, count_div8, bsy);
end

always@(posedge CLK_1M )	
begin
	if(rst)
			count <= 32'd0;
	else
	begin
	if(count < 32'd8388608 && !bsy)//b01001
			count <= count + 32'd1;
	else if ( count < 32'd8388608 && bsy)
			count <= count;
	else
			count <= 32'b0;
	end
	
	/*debug*/
	/*$display("  R00-R07: %d %d %d %d %d %d %d %d", cpu.ID.REG[0], cpu.ID.REG[1], cpu.ID.REG[2], cpu.ID.REG[3],cpu.ID.REG[4], cpu.ID.REG[5], cpu.ID.REG[6], cpu.ID.REG[7]);
	$display("  R08-R15: %d %d %d %d %d %d %d %d", cpu.ID.REG[8], cpu.ID.REG[9], cpu.ID.REG[10], cpu.ID.REG[11],cpu.ID.REG[12], cpu.ID.REG[13], cpu.ID.REG[14], cpu.ID.REG[15]);
	$display("  R16-R23: %d %d %d %d %d %d %d %d", cpu.ID.REG[16], cpu.ID.REG[17], cpu.ID.REG[18], cpu.ID.REG[19],cpu.ID.REG[20], cpu.ID.REG[21], cpu.ID.REG[22], cpu.ID.REG[23]);
	$display("  R24-R31: %d %d %d %d %d %d %d %d", cpu.ID.REG[24], cpu.ID.REG[25], cpu.ID.REG[26], cpu.ID.REG[27],cpu.ID.REG[28], cpu.ID.REG[29], cpu.ID.REG[30], cpu.ID.REG[31]);
	$display("  0x00   : %d %d %d %d %d %d %d %d", cpu.MEM.DM.data[0],cpu.MEM.DM.data[1],cpu.MEM.DM.data[2],cpu.MEM.DM.data[3],cpu.MEM.DM.data[4],cpu.MEM.DM.data[5],cpu.MEM.DM.data[6],cpu.MEM.DM.data[7]);
	$display("  0x08   : %d %d %d %d %d %d %d %d", cpu.MEM.DM.data[8],cpu.MEM.DM.data[9],cpu.MEM.DM.data[10],cpu.MEM.DM.data[11],cpu.MEM.DM.data[12],cpu.MEM.DM.data[13],cpu.MEM.DM.data[14],cpu.MEM.DM.data[15]);
	
	$display("  0x112   : %d %d %d %d %d %d %d %d", cpu.MEM.DM.data[112],cpu.MEM.DM.data[113],cpu.MEM.DM.data[114],cpu.MEM.DM.data[115],cpu.MEM.DM.data[116],cpu.MEM.DM.data[117],cpu.MEM.DM.data[118],cpu.MEM.DM.data[119]);
	$display("  0x120   : %d %d %d %d %d %d %d %d", cpu.MEM.DM.data[120],cpu.MEM.DM.data[121],cpu.MEM.DM.data[122],cpu.MEM.DM.data[123],cpu.MEM.DM.data[124],cpu.MEM.DM.data[125],cpu.MEM.DM.data[126],cpu.MEM.DM.data[127]);
	$display("");*/
	/*debug*/
end

initial
begin
	/*cpu.MEM.DM.data[0] = 32'd9;
	cpu.MEM.DM.data[1] = 32'd3;
	for (i=2; i<128; i=i+1) cpu.MEM.DM.data[i] = 32'b0;

	cpu.ID.REG[0] = 32'd0;
	cpu.ID.REG[1] = 32'd1;
	cpu.ID.REG[2] = 32'd4;
	for (i=3; i<32; i=i+1) cpu.ID.REG[i] = 32'b0;
	cpu.ID.REG[29] = 32'd508;
	*/
end

endmodule
