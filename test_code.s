.data
	stuff:	.word	1,2,3,4,5
	size:	.word	5
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
	nop
	nop
	
loop:
	sll $t1,$t0,2
	nop
	nop
	nop
	nop
	add $t1,$a1,$t1
	nop
	nop
	nop
	nop
	lw $t1,0($t1)
	nop
	nop
	nop
	nop
	add $s0,$s0,$t1
	addi $t0,$t0,1
	nop
	nop
	nop
	nop
	slt $t1,$t0,$s1
	nop
	nop
	nop
	nop
	bne $t1,$zero,loop
	nop
	nop
	nop
	nop
	
	move $v1,$s0

	jr $ra