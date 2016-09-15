	.data
one : .word 1
num : .word 0
val1 : .word 3
val2 : .word 9
space: .asciiz "\n"
first_number : .asciiz "\n input first number : "
second_number : .asciiz "\n input second number : "
GCD_ans : .asciiz "\n G.C.D is :  "

	.text
	.globl main
main : 
	
	addi $t1, $zero, 3
	addi $t2, $zero, 9
	addi $t3, $zero, 1
	
	addi $sp, $sp,-4
	sw $ra, 0($sp) 		# push $ra
	jal GCD
	
	addi $v0, $zero, 4  # print_string syscall
	la $a0, GCD_ans     # load address of the string
	syscall
	
	la $t0, num
	lw $a0, 8($t0)
	li $v0, 1
	syscall				# print ans
	
	lw $ra, 0($sp)
	addi $sp,$sp,4
	jr $ra
	

GCD:	
		addi $sp, $sp,-4
		sw $ra, 0($sp) 		# push $ra
		
		beq $t1, $t2, GCD_is_t1		#t1 == t2
		
		beq $t1, $t3, GCD_is_one	#t1 == 1
		
		beq $t2, $t3, GCD_is_one	#t2 == 1
		
		j Deal_number
		
GCD_is_t1:
		la $t0, num
		sw $t1, 8($t0)
		jr $ra
		
GCD_is_one:	
		la $t0, num
		sw $t3, 8($t0)
		jr $ra

Deal_number:

		slt $t0, $t1, $t2	# t1 < t2 ? 1 : 0
		beq $t0, $t3, t2_is_big
		
t1_is_big:
		sub $t1, $t1, $t2	# t1 = t1 - t2
		jal GCD 			# call GCD(a, b)
		j print_data
		
t2_is_big:
		sub $t2, $t2, $t1	# t2 = t2 - t1
		jal GCD 			# call GCD(a, b)
		
print_data:
		lw $ra, 0($sp)
		addi $sp,$sp,4
		jr $ra

		