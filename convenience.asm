# MAV120
# Mathew Varughese

# Constants for the syscalls (what you put in v0)
.eqv sys_printInt    1
.eqv sys_printFloat  2
.eqv sys_printDouble 3
.eqv sys_printString 4
.eqv sys_readInt     5
.eqv sys_readFloat   6
.eqv sys_readDouble  7
.eqv sys_readString  8
.eqv sys_sbrk        9
.eqv sys_exit       10
.eqv sys_printChar  11
.eqv sys_readChar   12
.eqv sys_openFile   13
.eqv sys_readFile   14
.eqv sys_writeFile  15
.eqv sys_closeFile  16
.eqv sys_exit2      17
.eqv sys_time       30
.eqv sys_sleep      32
.eqv sys_printHex   34
.eqv sys_printBin   35
.eqv sys_printUInt  36
.eqv sys_seedRand   40
.eqv sys_randInt    41
.eqv sys_randRange  42

# print an int to the console from a register.
# smashes a0 and v0
.macro print_int %reg
	move a0, %reg
	li v0, sys_printInt
	syscall
.end_macro

# print an int to the console from a register in binary.
# smashes a0 and v0
.macro print_int_binary %reg
	move a0, %reg
	li v0, sys_printBin
	syscall
.end_macro

# print an int to the console from a register in hex.
# smashes a0 and v0
.macro print_int_hex %reg
	move a0, %reg
	li v0, sys_printHex
	syscall
.end_macro

# print a string to the console. give it a label to an .asciiz thing in the .data segment
# smashes a0 and v0
.macro print_string %str
	la a0, %str
	li v0, sys_printString
	syscall
.end_macro

# print a single character. give it a character literal, like
# print_char '\n'
# smashes a0 and v0
.macro print_char %c
	li a0, %c
	li v0, sys_printChar
	syscall
.end_macro

# print an char to the console from a register.
# smashes a0 and v0
.macro print_char_reg %reg
	move a0, %reg
	li v0, sys_printChar
	syscall
.end_macro

# input an integer from a user and put it in the given register.
# smashes v0
.macro read_int %reg
	li v0, sys_readInt
	syscall
	move %reg, v0
.end_macro

# exit the program.
.macro exit
	li v0, sys_exit
	syscall
.end_macro

# exit the program with an error code, like "exit 4"
.macro exit %code
	li a0, %code
	li v0, sys_exit2
	syscall
.end_macro

# increment the value in a register
.macro inc %reg
	addi %reg, %reg, 1
.end_macro

# decrement the value in a register
.macro dec %reg
	addi %reg, %reg, -1
.end_macro

# these all push ra as well as any registers you list after them.
# so "enter s0, s1" will save ra, s0, and s1, letting you use those s regs.
.macro enter
	addi sp, sp, -4
	sw ra, 0(sp)
.end_macro

.macro enter %r1
	addi sp, sp, -8
	sw ra, 0(sp)
	sw %r1, 4(sp)
.end_macro

.macro enter %r1, %r2
	addi sp, sp, -12
	sw ra, 0(sp)
	sw %r1, 4(sp)
	sw %r2, 8(sp)
.end_macro

.macro enter %r1, %r2, %r3
	addi sp, sp, -16
	sw ra, 0(sp)
	sw %r1, 4(sp)
	sw %r2, 8(sp)
	sw %r3, 12(sp)
.end_macro

.macro enter %r1, %r2, %r3, %r4
	addi sp, sp, -20
	sw ra, 0(sp)
	sw %r1, 4(sp)
	sw %r2, 8(sp)
	sw %r3, 12(sp)
	sw %r4, 16(sp)
.end_macro

.macro enter %r1, %r2, %r3, %r4, %r5
	addi sp, sp, -24
	sw ra, 0(sp)
	sw %r1, 4(sp)
	sw %r2, 8(sp)
	sw %r3, 12(sp)
	sw %r4, 16(sp)
	sw %r5, 20(sp)
.end_macro

.macro enter %r1, %r2, %r3, %r4, %r5, %r6
	addi sp, sp, -28
	sw ra, 0(sp)
	sw %r1, 4(sp)
	sw %r2, 8(sp)
	sw %r3, 12(sp)
	sw %r4, 16(sp)
	sw %r5, 20(sp)
	sw %r6, 24(sp)
.end_macro

# the counterpart to enter. these pop the registers, and ra, and then return.
.macro leave
	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra
.end_macro

.macro leave %r1
	lw ra, 0(sp)
	lw %r1, 4(sp)
	addi sp, sp, 8
	jr ra
.end_macro

.macro leave %r1, %r2
	lw ra, 0(sp)
	lw %r1, 4(sp)
	lw %r2, 8(sp)
	addi sp, sp, 12
	jr ra
.end_macro

.macro leave %r1, %r2, %r3
	lw ra, 0(sp)
	lw %r1, 4(sp)
	lw %r2, 8(sp)
	lw %r3, 12(sp)
	addi sp, sp, 16
	jr ra
.end_macro

.macro leave %r1, %r2, %r3, %r4
	lw ra, 0(sp)
	lw %r1, 4(sp)
	lw %r2, 8(sp)
	lw %r3, 12(sp)
	lw %r4, 16(sp)
	addi sp, sp, 20
	jr ra
.end_macro

.macro leave %r1, %r2, %r3, %r4, %r5
	lw ra, 0(sp)
	lw %r1, 4(sp)
	lw %r2, 8(sp)
	lw %r3, 12(sp)
	lw %r4, 16(sp)
	lw %r5, 20(sp)
	addi sp, sp, 24
	jr ra
.end_macro

.macro leave %r1, %r2, %r3, %r4, %r5, %r6
	lw ra, 0(sp)
	lw %r1, 4(sp)
	lw %r2, 8(sp)
	lw %r3, 12(sp)
	lw %r4, 16(sp)
	lw %r5, 20(sp)
	lw %r6, 24(sp)
	addi sp, sp, 28
	jr ra
.end_macro
