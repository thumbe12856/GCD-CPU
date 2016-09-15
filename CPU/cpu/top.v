`timescale 1ns / 1ps
`include "code/CPU.v"

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
	 input clk,
	 input rst,
	 //switch
	 input i0,
	 input i1,
	 input i2,
	 input i3,
	 input i4,
	 input i5,
	 input i6,
	 input i7,
	 input i8,
	 input i9,
	 input i10,
	 input i11,
	 input i12,
	 input i13,
	 input i14,
	 input i15,

	
    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g,
	 output h,
	 output bbsy,
	 
	 //cih				
	output  ca,
	output  cb,
	output  cc,
	output  cd,
	output  ce,
	output  cf,
	output  cg,
	//output  dp,


	output an0,
	output an1,
	output an2,
	output an3,
	output an4,
	output an5,
	output an6,
	output an7
    );
/*cih*/
wire [31:0] gcd_answer;
reg [4:0] count_print_div;
reg [31:0] print_count;
reg Product_Valid_input_1;
reg Product_Valid_input_2;
reg Product_Valid_answer;
reg [6:0] seg [0:9];
reg [7:0] answer ;
reg [7:0] an ;
assign {cg,cf,ce,cd,cc,cb,ca} = answer ;
assign {an7,an6,an5,an4,an3,an2,an1,an0} = an;
always@ (posedge CLK_1M)begin
	seg[0] = 7'b1000000;//h40;//8'hc0;
	seg[1] = 7'b1111001;//h79;//8'hf9;
	seg[2] = 7'b0100100;//h24;//8'ha4;
	seg[3] = 7'b0110000;//h30;//8'hb0;
	seg[4] = 7'b0011001;//h19;//8'h99;
	seg[5] = 7'b0010010;//h12;//8'h92;
	seg[6] = 7'b0000010;//h02;//8'h82;
	seg[7] = 7'b1111000;//h78;//8'hf8;
	seg[8] = 7'b0000000;//h00;//8'h80;
	seg[9] = 7'b0010000;//h10;//8'h90;	
end 
reg [31:0] cycles, i;

reg [2:0] count_div8;
reg [31:0] count;
wire [31:0] dout;
wire [31:0] data;

wire [31:0] data1in;
wire [31:0] data2in;
assign bbsy=bsy;
assign data1in={{24'b0},i7,i6,i5,i4,i3,i2,i1,i0}; //把input1存入data memory
assign data2in={{24'b0},i15,i14,i13,i12,i11,i10,i9,i8}; //把input2存入data memory
assign CLK_1M = count_div8[2];
assign start_run = (count == 32'd3 && !rst) ? 1'b1 : 1'b0;	 
//assign start_run = 1'b1;	 
assign {h,g,f,e,d,c,b,a}=dout[7:0];
assign wen = (count==32'd0);

CPU cpu (
  .clk(CLK_1M),
  .rst(rst),
  .wen(wen),
  .start(start_run),
  .haddr(count),
  
  //input
  .hdin1(data1in),
  .hdin2(data2in),
  //output
  .gcd_answer(gcd_answer),
  
  .bsy(bsy),
  .dout(dout)
);

always@(posedge clk)
begin
	if(rst) begin
		count_div8 <= 3'b000;
	end
	else if (count_div8 == 3'b111)
		count_div8 <= 3'b000;
	else
		count_div8 <= count_div8 + 3'b001;
end

always@(posedge CLK_1M )	
begin
	if(rst) begin
			count <= 32'd0;
			print_count <= 32'd0;
	end
	
	//cih
	else
	begin
		if(count < 32'd8388608 && !bsy)//b01001
				count <= count + 32'd1;
		else if ( count < 32'd8388608 && bsy)
				count <= count;
		else
				count <= 32'b0;
				
		if(print_count < 32'd10000000)//b01001
				print_count <= print_count + 5'd1;
		else
				print_count <= 5'd0;
	end
end

//cih
always@(posedge CLK_1M or posedge rst)	
begin
	if(rst)
	begin
		count_print_div <= 5'd0;
	end
	else begin
		if(print_count == 32'd10000000)begin
			if(count_print_div <= 15)
				count_print_div <= count_print_div + 5'd1;
			else 
				count_print_div <= 5'd0;	
		end 
		
		else count_print_div <= count_print_div;
	end
end

always@(posedge CLK_1M or posedge rst)
begin
	if(rst)begin
		Product_Valid_input_1 <= 1'b0;
		Product_Valid_input_2 <= 1'b0;
		Product_Valid_answer <= 1'b0;
	end
	
	else if(5'd0<=count_print_div && count_print_div<=5'd3)
	begin
			Product_Valid_input_1 <= 1'b1;
			Product_Valid_input_2 <= 1'b0;
			Product_Valid_answer <= 1'b0;
	end
		
	else if(5'd6<=count_print_div && count_print_div<=5'd9)
	begin
			Product_Valid_input_1 <= 1'b0;
			Product_Valid_input_2 <= 1'b1;
			Product_Valid_answer <= 1'b0;
	end
	
	else if(5'd11<=count_print_div && count_print_div<=5'd14)
	begin
			Product_Valid_input_1 <= 1'b0;
			Product_Valid_input_2 <= 1'b0;
			Product_Valid_answer <= 1'b1;
	end
		
	else begin
			count_print_div <= count_print_div;
			Product_Valid_input_1 <= 1'b0;
			Product_Valid_input_2 <= 1'b0;
			Product_Valid_answer <= 1'b0;
	end
end

//cih
always@(posedge CLK_1M )	
begin
	if(Product_Valid_input_1 == 1'b1 )
	begin
		if(print_count[15:14] == 2'd0 )begin
			answer <= seg[{i7,i6,i5,i4,i3,i2,i1,i0} % 10] ; 			 //fisrt
			an <=8'b11111110;
		end else if(print_count[15:14] == 2'd1 )begin
			answer <= seg[({i7,i6,i5,i4,i3,i2,i1,i0}%100)/10] ;   		// second 7 segment
			an <=8'b11111101;
		end else if(print_count[15:14] == 2'd2)begin
			answer <= seg[{i7,i6,i5,i4,i3,i2,i1,i0}/100] ;			 // third 7 segment
			an <=8'b11111011;
		end else begin
			answer <= 7'b1111111;
			an <=8'b11110111;
		end
	end
	
	else if(Product_Valid_input_2 == 1'b1 )
	begin
		if(print_count[15:14] == 2'd0 )
		begin
			answer <= seg[{i15,i14,i13,i12,i11,i10,i9,i8} % 10] ; 			 //fisrt
			an <=8'b11111110;
		end
		
		else if(print_count[15:14] == 2'd1 )
		begin
			answer <= seg[({i15,i14,i13,i12,i11,i10,i9,i8}%100)/10] ;   		// second 7 segment
			an <=8'b11111101;
		end
		
		else if(print_count[15:14] == 2'd2)
		begin
			answer <= seg[{i15,i14,i13,i12,i11,i10,i9,i8}/100] ;			 // third 7 segment
			an <=8'b11111011;
		end
		
		else begin
			answer <= 7'b1111111;
			an <=8'b11110111;
		end
	end
	
	else if(Product_Valid_answer == 1'b1 )
	begin
		if(print_count[15:14] == 2'd0 )
		begin
			answer <= seg[gcd_answer % 10] ; 			 //fisrt
			//answer <= seg[3% 10] ; 			 //fisrt
			an <=8'b11111110;
		end
		
		else if(print_count[15:14] == 2'd1 )
		begin
			answer <= seg[(gcd_answer %100)/10] ;   		// second 7 segment
			an <=8'b11111101;
		end
		
		else if(print_count[15:14] == 2'd2)
		begin
			answer <= seg[gcd_answer /100] ;			 // third 7 segment
			an <=8'b11111011;
		end
		
		else begin
			answer <= 7'b1111111;
			an <=8'b11110111;
		end
	end
	else			answer <= 7'b1111111;
end

/*initial
begin
	cpu.MEM.DM.data[0] = 32'd0;
	cpu.MEM.DM.data[1] = 32'd0;
	for (i=2; i<128; i=i+1) cpu.MEM.DM.data[i] = 32'b0;


	cpu.ID.REG[0] = 32'd0;
	cpu.ID.REG[1] = 32'd1;
	cpu.ID.REG[2] = 32'd4;
	for (i=3; i<32; i=i+1) cpu.ID.REG[i] = 32'b0;
	cpu.ID.REG[29] = 32'd508;
	//cpu.ID.REG[31] = 32'd7;
	
end*/

endmodule
