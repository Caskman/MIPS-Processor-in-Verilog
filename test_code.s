# This program adds up a garbled mess based on the data but outputs 0x9ff6 based on this data set

.data
	size:	.word	10
	data:	.word	0,1,2,3,4,5,6,7,8,9
.text
main:
	nop
	addi $sp,$sp,-4	# extend stack pointer
	sw $ra,0($sp)	# save return address
	
	li $s0,0
	li $s1,1
	la $s0,size
	la $s1,data
	
	li $s2,0		# initialize counter
	lw $s0,0($s0)	# load size
	move $s3,$s1	# move pointer to another register
	li $s4,0		# initialize sum to zero
	
loop:
	lw $s5,0($s3)		# load value
	li $s6,1			# load 1
	sllv $s5,$s6,$s5	# shift value
	sw $s5,0($s3)		# store modified value
	move $a0,$s3		# set pointer argument
	jal modify			# call function
	add $s4,$s4,$v0		# add result to sum
	addiu $s3,$s3,4		# increment pointer
	addi $s2,$s2,1		# increment counter
	bne $s2,$s0,loop	# loop condition
	
done:	
	move $v1,$s4
	lw $ra,0($sp)	# restore return address
	addi $sp,$sp,4	# restore stack pointer
	j $ra
	
	
	
modify:
	lbu $t1,0($a0)
	li $t2,5
	mul $t1,$t1,$t2
	ori $t1,$t1,0xffff
	move $v0,$t1
	jr $ra
	
	
	
	
	
	
	
	