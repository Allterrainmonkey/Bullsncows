	.data
NumberPrompt:	.asciiz	"Please enter a positive integer: "
AnswerPrompt1:	.asciiz "The sum of all positive integers from 1 to "
AnswerPrompt2:	.asciiz " is "
Welcome1: .asciiz "Cows and Bulls\n"
Welcome2: .asciiz "For CS3340 from John, Scott, and Two Other Guys\n\n"
Menu0: .asciiz "Please choose from one of the following menu options:\n"
Menu1: .asciiz "[1] Start new game\n"
Menu2: .asciiz "[2] View Instructions\n"
Menu3: .asciiz "[3] Exit Game\n"
Menu4: .asciiz "View Credits"
Guess0: .asciiz "Please enter a four-digit hexadecimal number with no repeated numerals:\n"
Guess1: .asciiz "Valid numerals are 0-9 and A-F\n"
GuessError1: .asciiz "That was not a four-digit number."
GuessError2: .asciiz "There were one or more numerals repeated."
GuessError3: .asciiz "You already guessed this number."
UserGuess: .space 64
BaseString: .asciiz "0123456789ABCDEF"
PReturn: .asciiz "\n"
Answer: .space 64

	.text
main:
	la $t0, Welcome1	#Loading address of prompt to display
	li $v0, 4		#Syscall value for print string
	add $a0, $t0, $zero	#loading address of $t0 to $a0
	syscall			#Syscall to print spring
	la $t0, Welcome2
	add $a0, $t0, $zero
	syscall
	jal ShowMenu
	li $v0, 4
	la $t0, Guess0
	add $a0, $t0, $zero
	syscall
	la $t0, Guess1
	add $a0, $t0, $zero
	syscall
	li $v0, 8
	la $a0, UserGuess
	li $a1, 64
	syscall			#storing string in UserGuess
	la $t0, UserGuess
	li $v0, 4		#print string
	add $a0, $t0, $zero
	syscall
				#Try 11 "print character"
	lb $a0, 1($t0)		#Loading the second /character in the stored string
	li $v0, 11
	syscall
	
	jal GenNum
	la $t0, Answer
	add $a0, $t0, $zero
	li $v0, 4
	syscall
	li $v0, 10		#exits the program
	syscall
	
ShowMenu:
	li $v0, 4
	la $t0, Menu0
	add $a0, $t0, $zero
	syscall
	la $t0, Menu1
	add $a0, $t0, $zero
	syscall
	la $t0, Menu2
	add $a0, $t0, $zero
	syscall
	la $t0, Menu3
	add $a0, $t0, $zero
	syscall
	jr $ra
	
GenNum:
	la $s0, BaseString	#loads the prepared string
	la $t9, PReturn
	li $t1, 3		#counter for loop, 3-0
Loop1:	li $v0, 1		#print int
	add $a0, $t1, $zero	#load int in $a0 to print it out
	syscall			#printing the counter
	li $v0, 4
	add $a0, $t9, $zero
	syscall
	li $v0, 42		#random int
	li $a1, 15		#upper bound
	syscall			#get random number
	#sw $t3, $a0
	#li $v0, 1
	#syscall			#print random num
	#li $v0, 4
	#add $a0, $t9, $zero
	#syscall
	add $t2, $s0, $a0	#Add random number to counter
	lb $t4, ($t2)
	add $a0, $t4, $zero		#Loading the second /character in the stored string
	li $v0, 11
	syscall
	la $t5, Answer		#get address of answer
	add $t5, $t1, $t5	#add counter offset to address of answer
	sb $t4, ($t5)
	sub $t1, $t1, 1		#decrement counter
	bne $t1, -1, Loop1 	#if $t1 != 0, go back through loop
	jr $ra			#go back to called spot

