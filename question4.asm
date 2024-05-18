.data

#memory - in strings
	enter: .asciiz "Enter N:" #input from the user
	errormessage: .asciiz "Whoopsie, cannot compute because non-positive number!" #prints error message
	resultn: .asciiz "Result for naive:" #result for naive
	resulti: .asciiz "Result for interesting:" #result for interesting
	
.text
.globl main

main:
	#print enter statement
	li $v0, 4
	la $a0, enter
	syscall
	
	#take input for N from user
	li $v0, 5
	syscall
	move $t0, $v0
	
	#move to error message if it is non-positive
	sgt $t1, $t0, $zero
	beqz $t1, error
	
	#initialize $a0 to the user input and move to naive
	move $a0, $t0
	jal naive
	
	#print the character in $v0
	li $v0, 11
	#stop executing
	li $a0, 10
	syscall
	
	move $a0, $t0
	jal interesting	
	
	j exit
naive:
	#copy value of N to $t0
	move $t0, $a0
	
	#print statement resultn
	li $v0, 4
	la $a0, resultn
	syscall
	
	#initialize for loop
	li $t1, 1
	li $t2, 0

loop:
	#take a square of the value $t1
	mul $t3, $t1, $t1
	#keeping track of sum of squares
	add $t2, $t3, $t2
	#updating the value of loop
	addi $t1, $t1, 1
	#condition to terminate loop
	sle $t4, $t1, $t0
	bnez $t4, loop
	
	#print integer
	li $v0, 1
	move $a0, $t2
	syscall
	
	#jump back to main
	jr $ra
	
interesting:
	#copy value of N to $t0
	move $t0, $a0
	
	#print statement resultn
	li $v0, 4
	la $a0, resulti
	syscall
	
	#calculate n+1
	addi $t1, $t0, 1
	
	#calculate 2n+1
	li $t2, 2
	mul $t2, $t0, $t2
	addi $t2, $t2, 1
	#multiply (n+1)*(2n+1)
	mul $t2, $t2, $t1
	
	#multiply (n+1)*(2n+1) with n
	mul $t2, $t2, $t0
	
	#divide n(n+1)*(2n+1) by 6
	li $t3, 6
	div $t2, $t2, $t3
	
	#print integer
	li $v0, 1
	move $a0, $t2
	syscall
	
	jr $ra

error:
	#to display the error
	li $v0, 4
	la $a0, errormessage
	syscall
	j exit

exit:
	#exit the program
	li $v0, 10
	syscall
