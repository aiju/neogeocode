.section .text

.global udivmod
udivmod:
	movem.l %d2-%d3, -(%sp)
	moveq #0, %d0
	move.l 16(%sp), %d1
	move.l 20(%sp), %d2
	move.l #31, %d3
1:	lsl.l #1, %d1
	roxl.l #1, %d0
	bcs 2f
	sub.l %d2, %d0
	bra 3f
2:	add.l %d2, %d0
3:	bmi 2f
	addq #1, %d1
2:	dbra %d3, 1b
	tst.l %d0
	bpl 2f
	add.l %d2, %d0
2:	move.l 12(%sp), %a0
	move.l %d0, (%a0)
	move.l %d1, %d0
	movem.l (%sp)+, %d2-%d3
	rts

