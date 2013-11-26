	.data
NumberPrompt:	.asciiz	"Please enter a positive integer: "
AnswerPrompt1:	.asciiz "The sum of all positive integers from 1 to "
AnswerPrompt2:	.asciiz " is "
Welcome1: .asciiz "Cows and Bulls\n"
Welcome2: .asciiz "For CS3340 from Scott and John\n\n"
Menu0: .asciiz "\nPlease choose from one of the following menu options:\n"
Menu1: .asciiz "[1] Start new game\n"
Menu2: .asciiz "[2] View Instructions\n"
Menu3: .asciiz "[3] Exit Game\n"
Menu4: .asciiz "[4] View Credits\n"
MenuPrompt: .asciiz "Please enter your choice [1-4]:"
Guess0: .asciiz "Please enter a four-digit hexadecimal number with no repeated numerals:\n"
Guess1: .asciiz "Valid numerals are 0-9 and A-F\n"
GuessError1: .asciiz "That was not a four-digit number."
GuessError2: .asciiz "There were one or more numerals repeated."
GuessError3: .asciiz "You already guessed this number."
UserGuess: .space 64
BaseString: .asciiz "0123456789ABCDEF"
PReturn: .asciiz "\n"
Answer: .space 64
MenuChoice: .space 64
Instruct1: .asciiz "\nGuess numbers.  More to come.\n"
Credits1: .asciiz "\nScott programmed some stuff, and so did John, more to come.\n"
MenuError1: .asciiz "\nThat did not appear to be a valid menu selection.\n"
DupeError: .asciiz "\nYou may not repeat any character in your guess.\n"
InputRangeError: .asciiz "\nIt appears an invalid character was used.\n"
ScoreOut1: .asciiz "\nYour guess has "
ScoreOut2: .asciiz " has "
ScoreBull: .asciiz " Bull and "
ScoreBulls: .asciiz " Bulls and "
ScoreCow: .asciiz " Cow\n"
ScoreCows: .asciiz " Cows\n"
YouWin: .asciiz "\nYOU WIN!\n"

	.text
main:
	la $t0, Welcome1	#Loading address of prompt to display
	la $t9, PReturn		#Loading this in $t9 for quick carriage return printing
	li $v0, 4		#Syscall value for print string
	add $a0, $t0, $zero	#loading address of $t0 to $a0
	syscall			#Syscall to print spring
	la $t0, Welcome2	#Second welcome/start message
	add $a0, $t0, $zero	#loading it into $a0
	syscall			#still on 4: print string
	jal GenNum
	jal ShowMenu		#Show the menu options
	
GameLoop:
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
	li $v0, 4		#print string's "before" look
	add $a0, $t0, $zero
	syscall
	
	#error checking
	la $t0, UserGuess
	
	lb $t1, ($t0)		#setting 0th bit to s1
	lb $t2, 1($t0)		#setting 1st bit to s2
	lb $t3, 2($t0)		#setting 2nd bit to s3
	lb $t4, 3($t0)		#setting 3rd bit to s4
	
	#Ok, have to check two things, whether [0-9A-F] and if any dupes.  Can strtoupper during the checks.
	# 0 is 48, 9 is 57, A is 65, F is 70, a is 97, f is 102
	# if ((a>=48)&&(a<=57)) || ((a>=65)&&(a<=70)) || ((a>=97)&&(a<=102))
	addi $t5, $zero, 48
	blt $t1, $t5, UserInputError
	addi $t5, $zero, 57
	ble $t1, $t5, SecondCheck
	addi $t5, $zero, 65
	blt $t1, $t5, UserInputError
	addi $t5, $zero, 70
	ble $t1, $t5, SecondCheck
	addi $t5, $zero, 97
	blt $t1, $t5, UserInputError
	addi $t5, $zero, 102
	ble $t1, $t5, FirstFix
	j UserInputError
FirstFix:
	sub $t1, $t1, 32
SecondCheck:
	
	addi $t5, $zero, 48
	blt $t2, $t5, UserInputError
	addi $t5, $zero, 57
	ble $t2, $t5, ThirdCheck
	addi $t5, $zero, 65
	blt $t2, $t5, UserInputError
	addi $t5, $zero, 70
	ble $t2, $t5, ThirdCheck
	addi $t5, $zero, 97
	blt $t2, $t5, UserInputError
	addi $t5, $zero, 102
	ble $t2, $t5, SecondFix
	j UserInputError
SecondFix:
	sub $t2, $t2, 32
ThirdCheck:

	addi $t5, $zero, 48
	blt $t3, $t5, UserInputError
	addi $t5, $zero, 57
	ble $t3, $t5, FourthCheck
	addi $t5, $zero, 65
	blt $t3, $t5, UserInputError
	addi $t5, $zero, 70
	ble $t3, $t5, FourthCheck
	addi $t5, $zero, 97
	blt $t3, $t5, UserInputError
	addi $t5, $zero, 102
	ble $t3, $t5, ThirdFix
	j UserInputError
ThirdFix:
	sub $t3, $t3, 32
FourthCheck:

	addi $t5, $zero, 48
	blt $t4, $t5, UserInputError
	addi $t5, $zero, 57
	ble $t4, $t5, AfterCheck
	addi $t5, $zero, 65
	blt $t4, $t5, UserInputError
	addi $t5, $zero, 70
	ble $t4, $t5, AfterCheck
	addi $t5, $zero, 97
	blt $t4, $t5, UserInputError
	addi $t5, $zero, 102
	ble $t4, $t5, FourthFix
	j UserInputError
FourthFix:
	sub $t4, $t4, 32
AfterCheck:
	
	#Six checks to account for all combinations of the four numerals
	#Next check for duplicate entries
	beq $t1, $t2, UserDupe
	beq $t1, $t3, UserDupe
	beq $t1, $t4, UserDupe
	beq $t2, $t3, UserDupe
	beq $t2, $t4, UserDupe
	beq $t3, $t4, UserDupe
	#end error checking
		
	la $t0, UserGuess
	sb $t1, ($t0)		#setting 0th bit to s1
	sb $t2, 1($t0)		#setting 1st bit to s2
	sb $t3, 2($t0)		#setting 2nd bit to s3
	sb $t4, 3($t0)		#setting 3rd bit to s4
	
	li $v0, 4		#print string
	add $a0, $t0, $zero
	syscall
	
	#At this point we have good, validated input.  Time to check to see if there are any matches.
	#$s7 bulls, $s6 cows, $s1-$s4 are answer
	add $s7, $zero, $zero
	add $s6, $zero, $zero
	beq $t1, $s1, Bull1
	beq $t1, $s2, Cow1
	beq $t1, $s3, Cow1
	beq $t1, $s4, Cow1
	j Score2
Bull1:
	addi $s7, $s7, 1
	j Score2
Cow1:
	addi $s6, $s6, 1
	j Score2

Score2:
	beq $t2, $s2, Bull2
	beq $t2, $s1, Cow2
	beq $t2, $s3, Cow2
	beq $t2, $s4, Cow2
	j Score3
Bull2:
	addi $s7, $s7, 1
	j Score3
Cow2:
	addi $s6, $s6, 1
	j Score3

Score3:	
	beq $t3, $s3, Bull3
	beq $t3, $s1, Cow3
	beq $t3, $s2, Cow3
	beq $t3, $s4, Cow3
	j Score4
Bull3:
	addi $s7, $s7, 1
	j Score4
Cow3:
	addi $s6, $s6, 1
	j Score4
Score4:	
	beq $t4, $s4, Bull4
	beq $t4, $s1, Cow4
	beq $t4, $s2, Cow4
	beq $t4, $s3, Cow4
	j FinalScore
Bull4:
	addi $s7, $s7, 1
	j FinalScore
Cow4:
	addi $s6, $s6, 1
	j FinalScore
#
#ScoreOut1: .asciiz "\nYour guess of "
#ScoreOut2: .asciiz " has "
#ScoreBull: .asciiz " Bull and "
#ScoreBulls: .asciiz " Bulls and "
#ScoreCow: .asciiz " Cow\n"
#ScoreCows: .asciiz " Cows\n"
#
FinalScore:
	
	addi $t1, $zero, 1
	li $v0, 4
	la $t0, ScoreOut1
	add $a0, $t0, $zero
	syscall
	#la $t0, UserGuess
	#add $a0, $t0, $zero
	#syscall
	#la $t0, ScoreOut2
	#add $a0, $t0, $zero
	#syscall
	li $v0, 1
	add $a0, $s7, $zero
	syscall
	li $v0, 4
	beq $t1, $s7, ShowBull
	la $t0, ScoreBulls
	j ShowCow1
	
ShowBull:
	la $t0, ScoreBull

ShowCow1:
	add $a0, $t0, $zero
	syscall
	li $v0, 1
	add $a0, $s6, $zero
	syscall
	li $v0, 4
	beq $t1, $s6, ShowCow
	la $t0, ScoreCows
	j ShowScore2

ShowCow:
	la $t0, ScoreCow
ShowScore2:
	add $a0, $t0, $zero
	syscall
	add $t1, $zero, 4
	beq $s7, $t1, GameWon
	j GameLoop
	#Not necessary with the menu system, but leaving this here for legacy just in case in order to ensure the program stops.
	li $v0, 10		#exits the program
	syscall
	
GameWon:
	li $v0, 4
	la $t0, YouWin
	add $a0, $t0, $zero
	syscall
	j ShowMenu
	
UserInputError:
	li $v0, 4
	la $t0, InputRangeError
	add $a0, $t0, $zero
	syscall
	j GameLoop

UserDupe:
	li $v0, 4
	la $t0, DupeError
	add $a0, $t0, $zero
	syscall
	j GameLoop

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
	la $t0, Menu4
	add $a0, $t0, $zero
	syscall
	la $t0, MenuPrompt
	add $a0, $t0, $zero
	syscall
	li $v0, 8		#Loading the input as a string to avoid problems
	la $a0, UserGuess
	li $a1, 64
	syscall			#storing string in UserGuess
	lb $t1, ($a0)		#just pulling the first byte
	
	addi $t0, $zero, 49	#putting 1 in $t0 for checking
	beq $t1, $t0, GameLoop  #starting the game
	addi $t0, $zero, 50	#for testing if 2 was pressed
	beq $t1, $t0, ShowIns	#Showing instructions
	addi $t0, $zero, 52	#For looking at the credits
	beq $t1, $t0, ShowCred 	#For showing the credits
	addi $t0, $zero, 51	
	bne $t1, $t0, MenuError	#if they didn't choose any valid menu options print error message and go back to the menu
				
	li $v0, 10		#exits the program
	syscall
	
MenuError:
	li $v0, 4
	la $t0, MenuError1
	add $a0, $t0, $zero
	syscall
	
	j ShowMenu

ShowIns:
	li $v0, 4
	la $t0, Instruct1
	add $a0, $t0, $zero
	syscall
	
	j ShowMenu
	
ShowCred:
	li $v0, 4
	la $t0, Credits1
	add $a0, $t0, $zero
	syscall
	
	j ShowMenu
	
GenNum:
	la $s0, BaseString	#loads the prepared string which is all 16 possible hexadecimal characters
	li $t1, 3		#counter for loop, 3-0
Loop1:	li $v0, 42		#random int syscall
	li $a1, 15		#upper bound for the random int to allow 0-15
	syscall			#get random number
	
	add $t2, $s0, $a0	#Add random number to the address of the base string
	lb $t4, ($t2)		#load the byte at that random part of the string
	la $t5, Answer		#get address of answer
	add $t5, $t1, $t5	#add counter offset to address of answer
	sb $t4, ($t5)		#Store the chosen character at that part of the answer string
	sub $t1, $t1, 1		#decrement counter
	bne $t1, -1, Loop1 	#if $t1 != 0, go back through loop
	
	#error checking
	la $t0, Answer
	lb $s1, ($t0)		#setting 0th bit to s1
	lb $s2, 1($t0)		#setting 1st bit to s2
	lb $s3, 2($t0)		#setting 2nd bit to s3
	lb $s4, 3($t0)		#setting 3rd bit to s4
	
	#Six checks to account for all combinations of the four numerals
	beq $s1, $s2, GenNum
	beq $s1, $s3, GenNum
	beq $s1, $s4, GenNum
	beq $s2, $s3, GenNum
	beq $s2, $s4, GenNum
	beq $s3, $s4, GenNum
	#end error checking
	
	jr $ra			#go back to called spot
