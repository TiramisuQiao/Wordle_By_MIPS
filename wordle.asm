# StuName:Junqiao Wang
# StuId: 2022141520188

.data
seg_str:.asciiz "====================================\n"
Welcome_str: .asciiz "Welcome to Wordle, let's play a game\n"
select_str: .asciiz "What do you want to do?\n (1) Play\n (2) Quit\n"
invalid_str: .asciiz "Invalid number. Try again.\n"
make_guess_str: .asciiz "Make your guess:"
ground_true_str: .asciiz "smart"
fail_game_str:.asciiz "Whoops, it seems you could not guess :(\n"
prompt_true_str:.asciiz " The word was:"
entry_str:.asciiz "\n"
input_str:.asciiz "\0\0\0\0\0\0"
win_game_str:.asciiz "Yay :)\n"
win_game_prompt_str:.asciiz "The word is indeed:"

small_input_str:.asciiz "There must be FIVE letters! Please input again!\n"
wrong_input_str:.asciiz "The input must be five LOWERCASE LETTERS! Please input again!\n"

puzzlue_dict: .ascii,"pixel","alige","smart","spell","hello"
truth_str:.asciiz "     "

debug_mode: .byte 0 # 1 enable the debug mode, 0 is close the debug mode.
debug_str: .asciiz "Now it is debug mode! The really word is:\n"



.globl main
.text


main:
	
	# Print out the welcome message
	li $v0, 4
	la $a0, seg_str
	syscall
	la $a0, Welcome_str
	syscall
	la $a0, seg_str
	syscall
	la $a0, select_str
	syscall 
	# Read the user input
	li $v0, 5
	syscall 
	# input is 1, play the game
	beq , $v0 , 1, play_game
	# input is 2. quit the game
	beq , $v0 , 2, quit_game
	# input is invalid, go  again
	li $v0, 4
	la $a0, invalid_str
	syscall 
	j main
quit_game:
	li $v0, 10
	syscall
play_game:
	# $s1: stores for the time user left.
	
	# random a word
	li $v0, 42
	li $a0, 0
	li $a1, 5
	syscall
	
	mul $a0, $a0, 5
	la $s0, puzzlue_dict
	add $s0,$s0,$a0
	
	
	la $s7,truth_str
	li $t8, 0
	_loop_read_truth:
		beq $t8,5,carry_on_truth
		lb  $t9,($s0)
		sb  $t9,($s7)
		
		addi $s0,$s0,1
		addi $s7,$s7,1
		addi $t8,$t8,1
		j _loop_read_truth
	carry_on_truth:
	li $t8,0
	li $t7,0
	la $s7,truth_str
	#Debug Mode Entry
	lb $t1,debug_mode
	beq $t1,0,No_debug
	
	li $v0,4
	la $a0,debug_str
	syscall
	
	li $v0,4
	la $a0,truth_str
	syscall
	
	li $v0,4
	la $a0,entry_str
	syscall
	
No_debug:
	li  $s1,5
	
_loop_play: 
	beq $s1,0,_fail_game
	# reduce 1 chance!
	# subi $s1,$s1,1
	# this time is hard!
	li $v0, 4
	la $a0, make_guess_str
	syscall
	
	# Input the string!
	la $a0,input_str
	li $a1,20
	li $v0,8
	syscall


	
	la $s6, input_str
	
	jal valid_input_check
	
	subi $s1,$s1,1
	# Check if it is totally right!
	jal check_result
	# Judge the string!
	jal judge_result
	
	
	
_fail_game:
	li $v0, 4
	la $a0, fail_game_str
	syscall
	
	li $v0, 4
	la $a0, prompt_true_str
	syscall
	
	jal print_true
	
	li $v0,11
	li $a0,'\n'
	syscall
	syscall
	
	# wait for 5s
	li $v0,32
	li $a0,5000
	syscall
	
	j main

	
# Check part
check_result:
	move $t0,$s6
	move $t1,$s7
	li $t7,0
	_loop_check:
		lb $t2, ($t0)
		lb $t3, ($t1)
		beq  $t7, 5, _loop_go
		bne  $t2, $t3,judge_result
		addi $t7, $t7,1
		addi $t0, $t0,1
		addi $t1, $t1,1
		j _loop_check
	_loop_go:
		bne $t7, 5, judge_result
		beq $t7, 5, _win_game
		
judge_result:
	# t0 stores for the input string
	# t1 stores for the truth string
	# t2 stores for the [char] in input to check
	# t3 stores for the [char] in truth to check
	# t4 is the index of the input
	# t5 is the index of the truth
	move $t0, $s6
	li $t4, 0
	_loop_judge:
	beq $t4,5,go_print
		total_right:
			move $t1, $s7
			move $t5, $t4
			_move_index:
				beq $t5, 0, check_total
				addi $t1, $t1,1
				subi $t5, $t5,1
				j _move_index
			check_total:
				lb $t2, ($t0)
				lb $t3, ($t1)
				beq $t2, $t3, print_total_right
				bne $t2, $t3, part_right
		part_right:
			move $t1, $s7
			lb $t3, ($t1)
			li $t5,0
			_loop_part_check:
				beq $t2,$t3,print_part_right
				addi $t1,$t1,1
				addi $t5,$t5,1
				lb $t3, ($t1)
				beq $t5,5,not_in_word
				j _loop_part_check
			not_in_word:
				j print_not_right
				
				
		print_total_right:
			li $v0, 11
			li $a0, '['
			syscall
			
			li $v0, 11
			move $a0, $t2
			syscall
			
			li $v0, 11
			li $a0, ']'
			syscall	
			
			li $v0, 11
			li $a0, ' '
			syscall	
			
			addi $t0,$t0,1
			addi $t4,$t4,1
			j _loop_judge
			
		print_part_right:
			li $v0, 11
			li $a0, '('
			syscall
			
			li $v0, 11
			move $a0, $t2
			syscall
			
			li $v0, 11
			li $a0, ')'
			syscall	
			
			li $v0, 11
			li $a0, ' '
			syscall	
			
			addi $t0,$t0,1
			addi $t4,$t4,1
			j _loop_judge
		
		print_not_right:
			li $v0, 11
			li $a0, ' '
			syscall
			
			li $v0, 11
			move $a0, $t2
			syscall
			
			li $v0, 11
			li $a0, ' '
			syscall	
			
			li $v0, 11
			li $a0, ' '
			syscall	
			
			addi $t0,$t0,1
			addi $t4,$t4,1
			j _loop_judge		
				
					
	go_print:		
		li $v0, 11
		li $a0, '\n'
		syscall			
		j _loop_play
	

_win_game:
	li $v0, 4
	la $a0, win_game_str
	syscall
	
	li $v0, 4
	la $a0, win_game_prompt_str
	syscall
	
	jal print_true
	
	
	li $v0,11
	li $a0,'\n'
	syscall
	syscall
	
	# wait for 5s
	li $v0,32
	li $a0,5000
	syscall
	
	j main
	
print_true:
	li $v0,4
	la $a0, truth_str
	syscall
	
	jr $ra
	
valid_input_check:
	# s6 stand for input
	move $t0,$s6
	li $t2,0
	loop_check_valid:
		lb $t1,($t0)
		beq $t1,$zero,small_input
		addi $t0,$t0,1
		addi $t2,$t2,1
		beq $t2,6,lowercase_check
		bne $t2,6,loop_check_valid
	lowercase_check:
	move $t0,$s6
	li $t2,0
		loop_check_lowercase:
			lb $t1,($t0)
			blt $t1,97,wrong_input
			bgt $t1,122,wrong_input
			addi $t0,$t0,1
			addi $t2,$t2,1
			beq $t2,5,go_back_play
			bne $t2,5,loop_check_lowercase
	go_back_play:
		jr $ra
	small_input:
		li $v0, 4
		la $a0, small_input_str
		syscall
		j _loop_play
	wrong_input:
		li $v0, 4
		la $a0, wrong_input_str
		syscall
		j _loop_play
		
	
