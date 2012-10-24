.text
main:
	addi $t0,$zero,5
	beq $v0,$v0,next
	bgez $t0,next
	bltz $t0,next
	bgtz $t0,next
	addi $t1,$zero,1
next: