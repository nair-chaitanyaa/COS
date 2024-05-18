.data

#memory - in strings
	enterstring: .asciiz "Enter the string:" #input from the user
	error: .asciiz "This input is invalid"
	yes: .asciiz "Yes, the string is a palindrome."
	no: .asciiz "No, the string is not a palindrome."
	buffer: .space 50
	
.text
.globl main

main:
	#print for input string
	li $v0, 4
	la $a0, enterstring
	syscall
	
	#store string
	li $v0, 8
	la $a0, buffer
	la $a1, 50
	syscall
	move $s0, $a0
	li $t0, 0 #initialize to zero
	
	jal checklength
	
	jal pal_check

checklength:
	#checking if length is valid
	lb $t1, 0($s0)
	beq $t1, $zero, checkinput #if u reach null character, just skip to the checkinput part
	addi $t0, $t0, 1
	addi $s0, $s0, 1
	ble $t0,52, checklength
	bgt $t0, 52, errorstatement

checkinput:
	#checking whether input has special characters
	lb $t0, 0($s0)	
	addi $s0, $s0, 1 #increment by 1
	#if it is the null value, jump to next function
	beq $t0, $zero, whitelead
	#check for other valid/invalid input
	beq $t0, 32, checkinput
	blt $t0, 65, errorstatement
	blt $t0, 91, checkinput
	blt $t0, 97, errorstatement
	blt $t0, 122, checkinput
	bgt $t0, 122, errorstatement
	
whitelead:
	#checking for leading space
	lb $t4, 0($s0)
	la $t3, 0($s0)
	addi $s0, $s0, 1 #jump to next character
	addi $t3, $t3, 1 #keeping track of loop
	beq $t4, 32, whitelead
	bne $t4, 32, lastcharacter

lastcharacter:
	lb $t7, 0($s0) #assign $s2 to $t0
	addi $s0, $s0, 1 #increment by 1
	beq $t7, $zero, end
	bne $t7, $zero, lastcharacter #if B*==0, move back two steps

end:
	addi $t7, $t7, -2 #moveback two steps
	j whiteend


whiteend:
	#finding the end of the loop to check for trailing spaces
	lb $t5, 0($t7)
	li $t3, 0
	addi $t7, $t7, -1 #jump to next character
	beq $t5, 32, whiteend
	bne $t5, 32, middlechecker

middlechecker:
	#checking if there are middle spaces
	lb $t6, 0($t3)
	addi $t4, $t4, 1
	
	beq $t6, 32, nostatement
	beq $t6, $zero, removewhite
	bne $t6, 32, middlechecker
	
removewhite:
	#removing all leading and trailing white spaces
	lb $t5, 0($s0) #store the first character into $s1
	addi $s0, $s0, 1 #jump to next character
	beq $t5, 32, removewhite #if the string character is space, jump back to the removewhite
	beq $t5, $zero, converting #if it null character, jump back to where the next routine is
	
	sb $t5, 0($s2) #copying the string to a new string
	addi $s2, $s2, 1 #increment $s2
	
	j removewhite #jump back to loop


converting:
	#converting lower to upper
	lb $t0, 0($s2)
	li $t4, 0
	beq $t0, 0, lastcharacter
	blt $t0, 'a', next
	bgt $t0, 'z', next
	sub $t0, $t0, 32
	sb $t0, 0($s2)
	addi $s2, $s2, 1
	
	jr $ra
	
next:
	sb $t0, 0($s2)
	addi $s2, $s2, 1
	j converting


pal_check:
	#checking for the palindrome
	lb $t1, 0($s2) #load first character while $t0 already contains the value of last character
	lb $t2, 0($t7)
	addi $s2, $s2, 1 #increment by 1
	addi $t7, $t7, -1 #decrement by 1
	bge $t1, $t7, checker #if first character is greater than or equal to last, move to checker
	
	j yesstatement #if all conditions are fulfilled, move to yesstatement

checker:
	bne $t1, $t7,  nostatement #if they are not equal, print no statement
	beq $t1, $t7,  pal_check #if it is, move back to the incrementer

errorstatement:
	li $v0, 4
	la $a0, error
	syscall
		
yesstatement:
	#print it is true
	li $v0, 4
	la $a0, yes
	syscall

nostatement:
	#print it is not true
	li $v0, 4
	la $a0, no
	syscall
	
exit: 
	#exit program
	li $v0, 10
	syscall
