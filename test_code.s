.data
	stuff:	.word	1,2,3,4,5,6,7,8,9,10
	size:	.word	10
.text
main:
	nop
	li $a0,0
	li $a1,4
	#la $a0,size
	#la $a1,stuff
	
	li $t0,0 # counter
	li $s0,0 # sum
	lw $s1,0($a0) # size
	
loop:
	sll $t1,$t0,2
	add $t1,$a1,$t1
	lw $t1,0($t1)
	add $s0,$s0,$t1
	addi $t0,$t0,1
	slt $t1,$t0,$s1
	bne $t1,$zero,loop
	
	move $v1,$s0

	jr $ra