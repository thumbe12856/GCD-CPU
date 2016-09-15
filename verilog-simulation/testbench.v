/************************readme*********************
 *                                                 *
 * Editor: 402410052 cih                           *
 * MEM:											   *
 *   0: value 1									   *
 *   1: value 2									   *
 *   2: final answer                               *
 *                                                 *
 * Reg:                                            *
 *   0: 0                                          *
 *   1: 1                                          *
 *   8: $t0                                        *
 *   9: $t1                                        *
 *   10: $t2                                       *
 *                                                 *
 ****************************************************/
 

`define CYCLE_TIME 10
`define INSTRUCTION_NUMBERS 100000
`timescale 1ns/1ps
`include "CPU.v"

module testbench;
reg Clk, Rst;
reg [31:0] cycles, i;

// Instruction DM initialilation
initial
begin

	cpu.IF.instruction[0] = 32'b100011_00000_01001_00000_00000_000000;	//lw $9, 0($0) , first num

	cpu.IF.instruction[1] = 32'b100011_00000_01010_00000_00000_000100;	//lw $10, 4($0) , second num
	cpu.IF.instruction[2] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)
	cpu.IF.instruction[3] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[4] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)

	//j setting_max:26
	cpu.IF.instruction[5] = 32'b000010_00000_00000_00000_00000_011010; //j 26
	cpu.IF.instruction[6] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)

	//GCD_is_one:
	//sw $1, 2($0)
	cpu.IF.instruction[7] = 32'b101011_00000_00001_00000_00000_001000; //sw $1, 2($0)
	cpu.IF.instruction[8] = 32'b000000_00000_00000_00000_00000_100010; //NOP(sub $0, $0, $0)
	cpu.IF.instruction[9] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)
	cpu.IF.instruction[10] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)
	cpu.IF.instruction[11] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)

	//j finall
	cpu.IF.instruction[12] = 32'b000010_00000_00000_00000_00010_000000; //j 128
	cpu.IF.instruction[13] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)

	//GCD_is_t1:
	//sw $t1, 2($0)
	cpu.IF.instruction[14] = 32'b101011_00000_01001_00000_00000_001000; //sw $9, 2($0)
	cpu.IF.instruction[15] = 32'b000000_00000_00000_00000_00000_100010; //NOP(sub $0, $0, $0)
	cpu.IF.instruction[16] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)
	cpu.IF.instruction[17] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)

	//j finall
	cpu.IF.instruction[18] = 32'b000010_00000_00000_00000_00010_000000; //j 128
	cpu.IF.instruction[19] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)					

	//GCD_is_t2:
	//sw $t2, 2($0)
	cpu.IF.instruction[20] = 32'b101011_00000_01010_00000_00000_001000; //sw $10, 2($0) 
	cpu.IF.instruction[21] = 32'b000000_00000_00000_00000_00000_100010; //NOP(sub $0, $0, $0)
	cpu.IF.instruction[22] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)
	cpu.IF.instruction[23] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)

	//j finall
	cpu.IF.instruction[24] = 32'b000010_00000_00000_00000_00010_000000; //j 128
	cpu.IF.instruction[25] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)


	//setting_max:
	//beq $t1, $t2, GCD_is_t1:14
	cpu.IF.instruction[26] = 32'b000100_01001_01010_11111_11111_110011;	//beq $t2 $0 -13, but must have 3 bubbole after
	cpu.IF.instruction[27] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)
	cpu.IF.instruction[28] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)
	cpu.IF.instruction[29] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	
	//beq $t1, $1, GCD_is_one:7
	cpu.IF.instruction[30] = 32'b000100_01001_00001_11111_11111_101000;	//beq $t1 $1 -24, but must have 3 bubbole after
	cpu.IF.instruction[31] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)
	cpu.IF.instruction[32] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[33] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)

	//beq $t2, $1, GCD_is_one:7
	cpu.IF.instruction[34] = 32'b000100_01010_00001_11111_11111_100100;	//beq $t2 $1 -28, but must have 3 bubbole after
	cpu.IF.instruction[35] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)
	cpu.IF.instruction[36] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[37] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)

	//normal_ans:
	//slt $t0, $t1, $t2	# t1 < t2 ? 1 : 0
	cpu.IF.instruction[38] = 32'b000000_01001_01010_01000_00000_101010;	//slt $8, $9, $10 :  $8 = $9 < $10 ? 1 : 0
	cpu.IF.instruction[39] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)
	cpu.IF.instruction[40] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)
	cpu.IF.instruction[41] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[42] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)

	//beq $t0, $zero, max_t1:53
	cpu.IF.instruction[43] = 32'b000100_01000_00000_00000_00000_001001;	//beq $8 $0 9, but must have 3 bubbole after
	cpu.IF.instruction[44] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)
	cpu.IF.instruction[45] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[46] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)

	//max_t2:
	//sub $t2, $t2, $t1
	cpu.IF.instruction[47] = 32'b000000_01010_01001_01010_00000_100010;	//sub $10, $10, $9
	cpu.IF.instruction[48] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[49] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[50] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)

	//j setting_max:26
	cpu.IF.instruction[51] = 32'b000010_00000_00000_00000_00000_011010; //j 26
	cpu.IF.instruction[52] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)					

	//max_t1:
	//sub $t1, $t1, $t2
	cpu.IF.instruction[53] = 32'b000000_01001_01010_01001_00000_100010;	//sub $9, $9, $10
	cpu.IF.instruction[54] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[55] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[56] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)

	//j setting_max:26
	cpu.IF.instruction[57] = 32'b000010_00000_00000_00000_00000_011010; //j 26
	cpu.IF.instruction[58] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)

	//finall:
	
	/*
	
	cpu.IF.instruction[ ] = 32'b000000_00001_00010_00110_00000_101010;	//slt OK $6, $2, $1 :  $6 = $1 < $2 ? 1 : 0
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	
	cpu.IF.instruction[ ] = 32'b000000_00011_00010_00011_00000_100000; //add $3, $3, $2
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100010; //NOP(sub $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)
	
	cpu.IF.instruction[ ] = 32'b000010_00000_00000_00000_00000_001000; //j 8 temp OK
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100010; //NOP(sub $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)
	
	cpu.IF.instruction[ ] = 32'b101011_00000_00011_00000_00000_000111; //sw $3, 7($0) OK
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100010; //NOP(sub $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000; //NOP(add $0, $0, $0)
	
	cpu.IF.instruction[ ] = 32'b100011_00000_00101_00000_00000_000111;	//lw $5, 7($0) OK
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	
	cpu.IF.instruction[ ] = 32'b000100_00000_00000_00000_00000_001000;	//beq $0 $0 8 OK, but must have 3 bubbole after
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100010;	//NOP(sub $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	cpu.IF.instruction[ ] = 32'b000000_00000_00000_00000_00000_100000;	//NOP(add $0, $0, $0)
	
	*/
	
	cpu.IF.PC = 0;
end

// Data Memory & Register Files initialilation
initial
begin
	cpu.MEM.DM[0] = 32'd9;
	cpu.MEM.DM[1] = 32'd3;
	for (i=2; i<128; i=i+1) cpu.MEM.DM[i] = 32'b0;
	
	cpu.ID.REG[0] = 32'd0;
	cpu.ID.REG[1] = 32'd1;
	cpu.ID.REG[2] = 32'd0;
	for (i=3; i<32; i=i+1) cpu.ID.REG[i] = 32'b0;

end

//clock cycle time is 20ns, inverse Clk value per 10ns
initial Clk = 1'b1;
always #(`CYCLE_TIME/2) Clk = ~Clk;

//Rst signal
initial begin
	cycles = 32'b0;
	Rst = 1'b1;
	#12 Rst = 1'b0;
end

CPU cpu(
	.clk(Clk),
	.rst(Rst)
);

//display all Register value and Data memory content
always @(posedge Clk) begin
	cycles <= cycles + 1;
	if (cycles == `INSTRUCTION_NUMBERS || cpu.MEM.DM[2]!=0)
	begin
		$display("");
		/*$display("  R00-R07: %d %d %d %d %d %d %d %d", cpu.ID.REG[0], cpu.ID.REG[1], cpu.ID.REG[2], cpu.ID.REG[3],cpu.ID.REG[4], cpu.ID.REG[5], cpu.ID.REG[6], cpu.ID.REG[7]);
		$display("  R08-R15: %d %d %d %d %d %d %d %d", cpu.ID.REG[8], cpu.ID.REG[9], cpu.ID.REG[10], cpu.ID.REG[11],cpu.ID.REG[12], cpu.ID.REG[13], cpu.ID.REG[14], cpu.ID.REG[15]);
		$display("  R16-R23: %d %d %d %d %d %d %d %d", cpu.ID.REG[16], cpu.ID.REG[17], cpu.ID.REG[18], cpu.ID.REG[19],cpu.ID.REG[20], cpu.ID.REG[21], cpu.ID.REG[22], cpu.ID.REG[23]);
		$display("  R24-R31: %d %d %d %d %d %d %d %d", cpu.ID.REG[24], cpu.ID.REG[25], cpu.ID.REG[26], cpu.ID.REG[27],cpu.ID.REG[28], cpu.ID.REG[29], cpu.ID.REG[30], cpu.ID.REG[31]);
		$display("  0x00   : %d %d %d %d %d %d %d %d", cpu.MEM.DM[0],cpu.MEM.DM[1],cpu.MEM.DM[2],cpu.MEM.DM[3],cpu.MEM.DM[4],cpu.MEM.DM[5],cpu.MEM.DM[6],cpu.MEM.DM[7]);
		$display("  0x08   : %d %d %d %d %d %d %d %d", cpu.MEM.DM[8],cpu.MEM.DM[9],cpu.MEM.DM[10],cpu.MEM.DM[11],cpu.MEM.DM[12],cpu.MEM.DM[13],cpu.MEM.DM[14],cpu.MEM.DM[15]);*/
		
		if(cpu.MEM.DM[0]==0 || cpu.MEM.DM[1]==0) $display("input error!");
		else 
			begin
				$display("cycles: %d", cycles);
				$display("G.C.D. = (%1d, %1d) = %1d", cpu.MEM.DM[0], cpu.MEM.DM[1], cpu.MEM.DM[2]);
			end
		$finish; // Finish when excute the 24-th instruction (End label).
	end
end

//generate wave file, it can use gtkwave to display
initial begin
	/*	$dumpfile("cpu_hw.vcd");
	$dumpvars;*/
end
endmodule


