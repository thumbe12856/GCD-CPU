`define DM_MAX 128
`define DMSIZE 8
`timescale 1ns/1ps

module DATA_MEMORY(
	clk,
	wea,
	addr,
	din,
	dout,
	
	//input
	hdin1,
	hdin2,
	//output
	gcd_answer
);

input clk, wea;

input [`DMSIZE-1:0] addr;
input [31:0] din;
//input
input [31:0] hdin1;
input [31:0] hdin2;
//output
output [31:0] gcd_answer;

output [31:0] dout;

reg [`DMSIZE-1:0] addr_reg;

// DM_MAX = how many memory space can use
reg [31:0] data [0:`DM_MAX-1];

assign gcd_answer = data[2];
assign dout = data[addr_reg];

always @(posedge clk) begin
    addr_reg <= addr[`DMSIZE-1:0];
    if(wea)
        data[addr[`DMSIZE-1:0]] <= din;
		  
	data[0] <= hdin1;
	data[1] <= hdin2;
	
	
end

initial
begin
	//for (i=0; i<128; i=i+1) data[i] = 32'b0;
	data[0] = 32'd0;
	data[1] = 32'd0;
	data[2] = 32'b0;
	data[3] = 32'b0;
	data[4] = 32'b0;
	data[5] = 32'd5;
	data[6] = 32'b0;
	data[7] = 32'b0;
	data[8] = 32'b0;
	data[9] = 32'b0;
	data[10] = 32'b0;
	data[11] = 32'b0;
	data[12] = 32'b0;
	data[13] = 32'b0;
	data[14] = 32'b0;
	data[15] = 32'b0;
	data[16] = 32'b0;
	data[17] = 32'b0;
	data[18] = 32'b0;
	data[19] = 32'b0;
	data[20] = 32'b0;
	data[21] = 32'b0;
	data[22] = 32'b0;
	data[23] = 32'b0;
	data[24] = 32'b0;
	data[25] = 32'b0;
	data[26] = 32'b0;
	data[27] = 32'b0;
	data[28] = 32'b0;
	data[29] = 32'b0;
	data[30] = 32'b0;
	data[31] = 32'b0;
	data[32] = 32'b0;
	data[33] = 32'b0;
	data[34] = 32'b0;
	data[35] = 32'b0;
	data[36] = 32'b0;
	data[37] = 32'b0;
	data[38] = 32'b0;
	data[39] = 32'b0;
	data[40] = 32'b0;
	data[41] = 32'b0;
	data[42] = 32'b0;
	data[43] = 32'b0;
	data[44] = 32'b0;
	data[45] = 32'b0;
	data[46] = 32'b0;
	data[47] = 32'b0;
	data[48] = 32'b0;
	data[49] = 32'b0;
	data[50] = 32'b0;
	data[51] = 32'b0;
	data[52] = 32'b0;
	data[53] = 32'b0;
	data[54] = 32'b0;
	data[55] = 32'b0;
	data[56] = 32'b0;
	data[57] = 32'b0;
	data[58] = 32'b0;
	data[59] = 32'b0;
	data[60] = 32'b0;
	data[61] = 32'b0;
	data[62] = 32'b0;
	data[63] = 32'b0;
	data[64] = 32'b0;
	data[65] = 32'b0;
	data[66] = 32'b0;
	data[67] = 32'b0;
	data[68] = 32'b0;
	data[69] = 32'b0;
	data[70] = 32'b0;
	data[71] = 32'b0;
	data[72] = 32'b0;
	data[73] = 32'b0;
	data[74] = 32'b0;
	data[75] = 32'b0;
	data[76] = 32'b0;
	data[77] = 32'b0;
	data[78] = 32'b0;
	data[79] = 32'b0;
	data[80] = 32'b0;
	data[81] = 32'b0;
	data[82] = 32'b0;
	data[83] = 32'b0;
	data[84] = 32'b0;
	data[85] = 32'b0;
	data[86] = 32'b0;
	data[87] = 32'b0;
	data[88] = 32'b0;
	data[89] = 32'b0;
	data[90] = 32'b0;
	data[91] = 32'b0;
	data[92] = 32'b0;
	data[93] = 32'b0;
	data[94] = 32'b0;
	data[95] = 32'b0;
	data[96] = 32'b0;
	data[97] = 32'b0;
	data[98] = 32'b0;
	data[99] = 32'b0;
	data[100] = 32'b0;
	data[101] = 32'b0;
	data[102] = 32'b0;
	data[103] = 32'b0;
	data[104] = 32'b0;
	data[105] = 32'b0;
	data[106] = 32'b0;
	data[107] = 32'b0;
	data[108] = 32'b0;
	data[109] = 32'b0;
	data[110] = 32'b0;
	data[111] = 32'b0;
	data[112] = 32'b0;
	data[113] = 32'b0;
	data[114] = 32'b0;
	data[115] = 32'b0;
	data[116] = 32'b0;
	data[117] = 32'b0;
	data[118] = 32'b0;
	data[119] = 32'b0;
	data[120] = 32'b0;
	data[121] = 32'b0;
	data[122] = 32'b0;
	data[123] = 32'b0;
	data[124] = 32'b0;
	data[125] = 32'b0;
	data[126] = 32'b0;
	data[127] = 32'b0;
end


endmodule

