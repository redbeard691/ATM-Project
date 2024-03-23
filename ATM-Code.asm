# Nickolas Sturgeon
# Term Project
#
# Description - This program ask for a user Pin number, then calls three functions
FindCustomer to see if the pin matches an existing customer.
# Returns the customers current balance. Lastly asks if they wish to make a
withdrawal, if yes calls last function to ask how much money they want
# then validates if that amount can be extracted from the account. If yes shows
balance after transaction, else exits program after telling why.
# Constants
.eqv NUM_ROWS 5
.eqv NUM_COLS 6
.eqv ELT_SIZE 4
.eqv PRINT_INT 1
.eqv PRINT_STR 4
.eqv READ_INT 5
.eqv TERMINATE 10
.text
main:
# User enter 4 digit pin
la $a0, InputMSG
li $v0, PRINT_STR
syscall
# Read in integer
li $v0, READ_INT # User enter integer
syscall
# Call FindCustomer
la $a0, head
move $a1, $v0
jal FindCustomer
beq $v0, $0, NO_CUSTOMER # if $v0 = 0 branch to termination.
# Call FindBalance
move $a0, $v0
jal GetBalance
# Print Balance
move $t1, $v0
la $a0, BalanceMSG
li $v0, PRINT_STR
syscall
move $a0, $t1 # Moving to $a0 so number can print.
li $v0, PRINT_INT # printing customer balance
syscall
# Ask if wanting to make a withdrawal
move $a2, $a0 # Moving account balance for function
GetProperRequest:
la $a0, WithdrawalRequestMSG
li $v0, PRINT_STR
syscall
li $v0, READ_INT # User inputs answer
syscall
addi $t2, $t2, 1
beq $v0, $0, ExitProgram # Exit program if customer doesn't want to
withdrawal.
beq $v0, $t2, Make_Withdrawal # Jump to MakeWithdrawal Function.
la $a0, EnterCorrectNumberMSG
li $v0, PRINT_STR
syscall
jal GetProperRequest
Make_Withdrawal:
# Making Withdrawal
la $a0, HowMuchToWithdrawalMSG
li $v0, PRINT_STR
syscall
li $v0, READ_INT # User inputs answer
syscall
move $a3, $v0
jal MakeWithdrawal
bltz $v0, Insuffiecent_Funds # Checks if withdrawal was aproved or not.
move $t1, $v0
la $a0, AfterWithdrawal
li $v0, PRINT_STR
syscall
move $a0, $t1
li $v0, PRINT_INT
syscall
#End of Main
la $v0, TERMINATE
syscall
#############################################################################
NO_CUSTOMER: # Customer ID doesn't exist, terminate program.
la $a0, NoCustomerMSG
li $v0, PRINT_STR
syscall
la $v0, TERMINATE
syscall
#############################################################################
ExitProgram: # Customer didn't want to make a withdrawal
la $a0, NoWithdrawal
li $v0, PRINT_STR
syscall
la $v0, TERMINATE
syscall
#############################################################################
Insuffiecent_Funds:
la $a0, InsufficientFundMSG
li $v0, PRINT_STR
syscall
la $v0, TERMINATE
syscall
######################### Funcion ###########################################
#############################################################################
# FindCustomer
# $a0 - Head address of customer linked list
# $a1 - User Pin Input
#
#############################################################################
FindCustomer:
# Initialize
move $t0, $a0 # move address to temporary register
KeepLooking:
beq $t0, $0, Pin_Not_Found # checking to see if list is null
lw $t1, 0($t0)
beq $t1, $0, Pin_Not_Found # IF $t1 = 0 reach end of list branch to exit
beq $t1, $a1, Found # Found Customer Pin Branch to return customer
address
lw $t0, 8($t0) # Shift to next customer ID
j KeepLooking
Found: # Found Customer
move $v0, $t0
jr $ra
Pin_Not_Found: # Didn't find customer
move $v0, $0
jr $ra
#############################################################################
# GetBalance
# $a0 – address of the customer
#
#############################################################################
GetBalance:
move $t1, $a0
lw $v0, 4($t1)
jr $ra
#############################################################################
# MakeWithdrawal
# $a2 – Balance to be withdrawn
# $a3 – Available balance
#
#############################################################################
MakeWithdrawal:
#initialize
move $t1, $a2 # Money Requested.
move $t2, $a3 # Available Balance.
bgt $t2, $t1, InsufficientFunds # If request is larger than balance, denie
request.
sub $t2, $t1, $t2
move $v0, $t2
jr $ra
InsufficientFunds:
li $v0, -1
jr $ra
############################################## Cutstomer Data
############################################################
.data
.align 2 # Align what follows in a 4-byte boundary
head:
cust0: .word 1234 # PIN
.word 525 # Balance
.word cust1 # Pointer to next customer info
.asciiz "Abel" # Customer name
cust1: .word 2341
.word 43
 .word cust2
.asciiz "Bernard"

cust2: .word 1176
.word 10250
 .word cust3
.asciiz "Charlie"

cust3: .word 3025
.word 10
 .word cust4
.asciiz "Douglas"

cust4: .word 6172
.word 810
 .word cust5
.asciiz "Elvin"

cust5: .word 8890
.word 25
 .word cust6
.asciiz "Frodo"

cust6: .word 4049
.word 75
 .word cust7
.asciiz "George"
cust7: .word 2170
.word 320
 .word cust8
.asciiz "Homer"

cust8: .word 3081
.word 1024
 .word cust9
.asciiz "Ishmael"

cust9: .word 1009
.word 615
 .word cust10
.asciiz "Jess"

cust10: .word 1011
.word 15
 .word custEND
.asciiz "Keith"

custEND: .word 0
CustomerBalance: .space 4
InputMSG: .asciiz "Enter 4 digit pin: "
NoCustomerMSG: .asciiz "\nCustomer ID doesn't exist, Goodbye."
BalanceMSG: .asciiz "\nThe Current balance is $"
WithdrawalRequestMSG: .asciiz "\n\nDo you wish to make a request enter 0 or 1,
0(NO) 1(YES): "
NoWithdrawal: .asciiz "\nExiting Program, GoodBye."
EnterCorrectNumberMSG: .asciiz"\n\nEnter either 1 or 0."
HowMuchToWithdrawalMSG: .asciiz"\n\nHow much do you wish to withdrawal from
account: "
InsufficientFundMSG: .asciiz"\n\nInsufficient funds to finish withdrawal
request."
AfterWithdrawal: .asciiz"\n\nBalance after withdrawal is: $"