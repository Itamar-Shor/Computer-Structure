		out $imm, $zero, $zero, 1		# cycles 0-1, enable $irq0enable
		add $t0, $imm, $zero, 6 		# cycles 2-3, $t0 = &irqhandler
		out $imm, $t0, $zero, WRITE_LED	# cycles 4-5, $irqhandler = WRITE_LED
		add $a0, $zero, $zero, 0		# cycle 6, $a0 = 0
		
		add $t0, $imm, $zero, 13 		# cycles 7-8, $t0 = &timermax
		out $imm, $t0, $zero, 1024		# cycles 9-10, $timermax = 1024
			
		add $t0, $imm, $zero, 11 		# cycles 11-12, $t0 = &timerenable
		out $imm, $t0, $zero, 1			# cycles 13-14, enable timer
		
WAIT: 
		beq $imm, $zero, $zero, WAIT

WRITE_LED:
		sll $a0, $a0, $imm, 1			# $a0 = $a0 << 1
		add $a0, $a0, $imm, 1			# $a0 += 1
		add $t0 , $zero, $imm, 9 		# $t0 = &leds
		out $a0, $t0, $zero, 1			# turn next led
		add $t0, $imm, $zero, 3 		# $t0 = &irq0status
		out $zero, $t0, $zero, 1		# reset irq0
		add $t0, $imm, $zero, 0xFFFFFFFF# $t0 = 0xFFFFFFFF
		beq $imm, $t0, $a0, DONE		
		reti $zero, $zero, $zero, 0		# return from interrupt    
DONE:
	halt $zero, $zero, $zero, 0	# halt