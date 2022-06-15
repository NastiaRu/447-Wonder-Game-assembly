
# puts a string literal into the .data segment and loads its address
# into a register. use like:
#   lstr a0, "hello, world"
.macro lstr %rd, %str
	.data
	lstr_message: .asciiz %str
	.text
	la %rd, lstr_message
.end_macro

# print a string to the console. PRESERVES A0 AND V0.
.macro print_str %str
	push a0
	push v0
	lstr a0, %str
	syscall_print_string
	pop v0
	pop a0
.end_macro

# print a newline to the console. PRESERVES A0 AND V0.
.macro newline
	push a0
	push v0
	li a0, '\n'
	syscall_print_char
	pop v0
	pop a0
.end_macro

# print a string to the console, followed by a newline. PRESERVES A0 AND V0.
.macro println_str %str
	print_str %str
	newline
.end_macro

# increment the value in a register by 1.
.macro inc %reg
	addi %reg, %reg, 1
.end_macro

# decrement the value in a register by 1.
.macro dec %reg
	addi %reg, %reg, -1
.end_macro

# set rd to the minimum of register rs and register rt.
.macro min %rd, %rs, %rt
	move %rd, %rs
	blt  %rs, %rt, _end
	move %rd, %rt
_end:
.end_macro

# set rd to the minimum of register rs and immediate imm.
.macro mini %rd, %rs, %imm
	move %rd, %rs
	blt  %rs, %imm, _end
	li   %rd, %imm
_end:
.end_macro

# set rd to the maximum of register rs and register rt.
.macro max %rd, %rs, %rt
	move %rd, %rs
	bgt  %rs, %rt, _end
	move %rd, %rt
_end:
.end_macro

# set rd to the maximum of register rs and immediate imm.
.macro maxi %rd, %rs, %imm
	move %rd, %rs
	bgt  %rs, %imm, _end
	li   %rd, %imm
_end:
.end_macro

# these let you do the syscall on a single line.
# these all trash v0.
.macro syscall_print_int
	li v0, 1
	syscall
.end_macro
.macro syscall_print_float
	li v0, 2
	syscall
.end_macro
.macro syscall_print_double
	li v0, 3
	syscall
.end_macro
.macro syscall_print_string
	li v0, 4
	syscall
.end_macro
.macro syscall_read_int
	li v0, 5
	syscall
.end_macro
.macro syscall_read_float
	li v0, 6
	syscall
.end_macro
.macro syscall_read_double
	li v0, 7
	syscall
.end_macro
.macro syscall_read_string
	li v0, 8
	syscall
.end_macro
.macro syscall_exit
	li v0, 10
	syscall
.end_macro
.macro syscall_print_char
	li v0, 11
	syscall
.end_macro
.macro syscall_read_char
	li v0, 12
	syscall
.end_macro
.macro syscall_time
	li v0, 30
	syscall
.end_macro
.macro syscall_midi_out
	li v0, 31
	syscall
.end_macro
.macro syscall_sleep
	li v0, 32
	syscall
.end_macro
.macro syscall_midi_out_sync
	li v0, 33
	syscall
.end_macro
.macro syscall_print_hex
	li v0, 34
	syscall
.end_macro
.macro syscall_print_bin
	li v0, 35
	syscall
.end_macro
.macro syscall_print_uint
	li v0, 36
	syscall
.end_macro
.macro syscall_seed_rand
	li v0, 40
	syscall
.end_macro
.macro syscall_rand_int
	li v0, 41
	syscall
.end_macro
.macro syscall_rand_range
	li v0, 42
	syscall
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