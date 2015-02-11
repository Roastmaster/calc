	.data

Welcome:  .asciiz "Welcome to SPIM Calculator 1.0!\n"
First:  .asciiz "Enter the first number:  "
Second:  .asciiz "Enter the second number:  "
Op:  .asciiz "Enter the operation (+, -, *, /), then press enter key  "
Again: .asciiz "Another Calculation (y, n)?  "
Terminated:  .asciiz "Program Terminated.  \n"

Plus: .byte '+'
Subtract:  .byte '-'
Mult:  .byte '*'
Div:  .byte '/'

	.text
	.globl main

main:
	li $v0, 4
	la $a0, Welcome
	syscall  						#print welcome text

	la $a0, First
	syscall							#prompt user for first int

	li $v0, 5
	syscall

	move $t0, $v0					#retrieve int data from console and store in $t0

	li $v0, 4
	la $a0, Second 					#prompt user for second int
	syscall

	li $v0, 5
	syscall

	move $t1, $v0					#retrieve int data from console and store in $t1

	li $v0, 4
	la $a0, Op
	syscall							#prompt user for operation

	li $v0, 12  					# + is stored in $a0
	syscall

	move $a0, $v0
	move $t4, $a0

	move $a0, $t0					#store the first input and the second input	
	move $a1, $t1

	addition:
		li $t3, '+'
		bne $t4, $t3, multiply
		add $a0, $a0, $a1

	multiply:
		li $t3, '*'
		bne $t4, $t3, subtract
		add $t5, $zero, $zero
		loop:
			beq $a0, $zero, solve
			add $t5, $a1, $t5
			addi $a0, $a0, -1
		 	j loop
		solve:
			move $a0, $t5
			j done

	subtract:
		li $t3, '-'
		bne $t4, $t3, divide
		sub $a0, $a0, $a1

	divide:
		li $t3, '/'
		bne $t4, $t3, done
		add $t5, $zero, $zero
		loopd:
			bgt $a1, $a0, solved
			sub $a0, $a0, $a1
			addi $t5, $t5, 1
			j loopd
		solved:
			move $a1, $t5
			j donediv

	donediv:					# division gets it's own output sequence
		move $t6, $a0  			#remainder
		move $t7, $a1			#divisor

		li $a0, '\n'
		li $v0, 11
		syscall

		move $a0, $t0
		li $v0, 1
		syscall

		move $a0, $t4
		li  $v0, 11
		syscall

		move $a0, $t1
		li $v0, 1
		syscall

		li $a0, '='
		li $v0, 11
		syscall

		move $a0, $t7
		li $v0, 1
		syscall

		li $a0, '('
		li $v0, 11
		syscall

		move $a0, $t6
		li $v0, 1
		syscall

		li $a0, ')'
		li $v0, 11
		syscall

		j GoAgain

	done:
		move $t6, $a0  			#store answer somewhere

		li $a0, '\n'
		li $v0, 11
		syscall

		move $a0, $t0
		li $v0, 1
		syscall

		move $a0, $t4
		li  $v0, 11
		syscall

		move $a0, $t1
		li $v0, 1
		syscall

		li $a0, '='
		li $v0, 11
		syscall

		move $a0, $t6
		li $v0, 1
		syscall

		li $a0, '\n'
		li $v0, 11
		syscall
		syscall

		j GoAgain

	GoAgain:
		li $v0, 4
		la $a0, Again
		syscall  						#Prompt the user if they want to make another calculation

		li $v0, 12
		syscall

		li $a0, '\n'
		li $v0, 11
		syscall

		move $t4, $v0
		li $t3, 'y'
		beq $t4, $t3, main

		li $v0, 4
		la $a0, Terminated
		syscall  

		li $v0, 10
		syscall
