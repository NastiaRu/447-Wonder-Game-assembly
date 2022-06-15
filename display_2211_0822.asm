# Keypad and LED Display Simulator driver/API file.
# All the public functions in this file are marked .globl.

.include "constants.asm"
.include "macros.asm"

.data
.eqv CHAR_PATTERN_SIZE 5

# each character is a 5x5 pixel block, stored row-by-row.
# have a look at the comments on the right to see what each character is.
ASCII_patterns:
	.byte 0b00100 0b00100 0b00100 0b00000 0b00100 # !
	.byte 0b01010 0b01010 0b00000 0b00000 0b00000 # "
	.byte 0b01010 0b11111 0b01010 0b11111 0b01010 # #
	.byte 0b01110 0b10100 0b01110 0b00101 0b01110 # $
	.byte 0b10001 0b00010 0b00100 0b01000 0b10001 # %
	.byte 0b01000 0b10100 0b01000 0b10101 0b01010 # &
	.byte 0b00100 0b00100 0b00000 0b00000 0b00000 # '
	.byte 0b00010 0b00100 0b00100 0b00100 0b00010 # (
	.byte 0b01000 0b00100 0b00100 0b00100 0b01000 # )
	.byte 0b00100 0b10101 0b01110 0b01010 0b10001 # *
	.byte 0b00000 0b00100 0b01110 0b00100 0b00000 # +
	.byte 0b00000 0b00000 0b00000 0b01000 0b10000 # ,
pat_dash:
	.byte 0b00000 0b00000 0b01110 0b00000 0b00000 # -
	.byte 0b00000 0b00000 0b00000 0b00000 0b10000 # .
	.byte 0b00001 0b00010 0b00100 0b01000 0b10000 # /
Digit_patterns:
	.byte 0b01110 0b10011 0b10101 0b11001 0b01110 # 0
	.byte 0b00100 0b01100 0b00100 0b00100 0b01110 # 1
	.byte 0b11111 0b00001 0b11111 0b10000 0b11111 # 2
	.byte 0b11110 0b00001 0b00110 0b00001 0b11110 # 3
	.byte 0b10001 0b10001 0b11111 0b00001 0b00001 # 4
	.byte 0b11111 0b10000 0b11110 0b00001 0b11110 # 5
	.byte 0b01110 0b10000 0b11110 0b10001 0b01110 # 6
	.byte 0b11111 0b00001 0b00010 0b00100 0b01000 # 7
	.byte 0b01110 0b10001 0b01110 0b10001 0b01110 # 8
	.byte 0b01110 0b10001 0b01111 0b00001 0b01110 # 9
	.byte 0b00000 0b01000 0b00000 0b01000 0b00000 # :
	.byte 0b00000 0b01000 0b00000 0b01000 0b10000 # ;
	.byte 0b00011 0b01100 0b10000 0b01100 0b00011 # <
	.byte 0b00000 0b01110 0b00000 0b01110 0b00000 # =
	.byte 0b11000 0b00110 0b00001 0b00110 0b11000 # >
	.byte 0b01110 0b10001 0b00010 0b00000 0b00010 # ?
	.byte 0b01110 0b10001 0b10111 0b10000 0b01110 # @
Uppercase_patterns:
	.byte 0b01110 0b10001 0b11111 0b10001 0b10001 # A
	.byte 0b11110 0b10001 0b11110 0b10001 0b11110 # B
	.byte 0b01111 0b10000 0b10000 0b10000 0b01111 # C
	.byte 0b11110 0b10001 0b10001 0b10001 0b11110 # D
	.byte 0b11111 0b10000 0b11100 0b10000 0b11111 # E
	.byte 0b11111 0b10000 0b11100 0b10000 0b10000 # F
	.byte 0b01110 0b10000 0b10011 0b10001 0b01110 # G
	.byte 0b10001 0b10001 0b11111 0b10001 0b10001 # H
	.byte 0b01110 0b00100 0b00100 0b00100 0b01110 # I
	.byte 0b01110 0b00100 0b00100 0b10100 0b01000 # J
	.byte 0b10010 0b10100 0b11000 0b10100 0b10010 # K
	.byte 0b10000 0b10000 0b10000 0b10000 0b11111 # L
	.byte 0b10001 0b11011 0b10101 0b10001 0b10001 # M
	.byte 0b10001 0b11001 0b10101 0b10011 0b10001 # N
	.byte 0b01110 0b10001 0b10001 0b10001 0b01110 # O
	.byte 0b11110 0b10001 0b11111 0b10000 0b10000 # P
	.byte 0b01110 0b10001 0b10101 0b10011 0b01111 # Q
	.byte 0b11110 0b10001 0b11111 0b10010 0b10001 # R
	.byte 0b11111 0b10000 0b11111 0b00001 0b11111 # S
	.byte 0b11111 0b00100 0b00100 0b00100 0b00100 # T
	.byte 0b10001 0b10001 0b10001 0b10001 0b01110 # U
	.byte 0b10001 0b10001 0b01010 0b01010 0b00100 # V
	.byte 0b10001 0b10001 0b10101 0b11011 0b10001 # W
	.byte 0b10001 0b01010 0b00100 0b01010 0b10001 # X
	.byte 0b10001 0b01010 0b00100 0b00100 0b00100 # Y
	.byte 0b11111 0b00010 0b00100 0b01000 0b11111 # Z
	.byte 0b01110 0b01000 0b01000 0b01000 0b01110 # [
	.byte 0b10000 0b01000 0b00100 0b00010 0b00001 # \
	.byte 0b01110 0b00010 0b00010 0b00010 0b01110 # ]
	.byte 0b00100 0b01010 0b00000 0b00000 0b00000 # ^
	.byte 0b00000 0b00000 0b00000 0b00000 0b11111 # _
	.byte 0b01000 0b00100 0b00010 0b00000 0b00000 # `
	.byte 0b01110 0b10001 0b11111 0b10001 0b10001 # a (no actual lowercase tho)
	.byte 0b11110 0b10001 0b11110 0b10001 0b11110 # b
	.byte 0b01111 0b10000 0b10000 0b10000 0b01111 # c
	.byte 0b11110 0b10001 0b10001 0b10001 0b11110 # d
	.byte 0b11111 0b10000 0b11100 0b10000 0b11111 # e
	.byte 0b11111 0b10000 0b11100 0b10000 0b10000 # f
	.byte 0b01110 0b10000 0b10011 0b10001 0b01110 # g
	.byte 0b10001 0b10001 0b11111 0b10001 0b10001 # h
	.byte 0b01110 0b00100 0b00100 0b00100 0b01110 # i
	.byte 0b01110 0b00100 0b00100 0b10100 0b01000 # j
	.byte 0b10010 0b10100 0b11000 0b10100 0b10010 # k
	.byte 0b10000 0b10000 0b10000 0b10000 0b11111 # l
	.byte 0b10001 0b11011 0b10101 0b10001 0b10001 # m
	.byte 0b10001 0b11001 0b10101 0b10011 0b10001 # n
	.byte 0b01110 0b10001 0b10001 0b10001 0b01110 # o
	.byte 0b11110 0b10001 0b11111 0b10000 0b10000 # p
	.byte 0b01110 0b10001 0b10101 0b10011 0b01111 # q
	.byte 0b11110 0b10001 0b11111 0b10010 0b10001 # r
	.byte 0b11111 0b10000 0b11111 0b00001 0b11111 # s
	.byte 0b11111 0b00100 0b00100 0b00100 0b00100 # t
	.byte 0b10001 0b10001 0b10001 0b10001 0b01110 # u
	.byte 0b10001 0b10001 0b01010 0b01010 0b00100 # v
	.byte 0b10001 0b10001 0b10101 0b11011 0b10001 # w
	.byte 0b10001 0b01010 0b00100 0b01010 0b10001 # x
	.byte 0b10001 0b01010 0b00100 0b00100 0b00100 # y
	.byte 0b11111 0b00010 0b00100 0b01000 0b11111 # z
	.byte 0b00110 0b00100 0b01000 0b00100 0b00110 # {
	.byte 0b00100 0b00100 0b00100 0b00100 0b00100 # |
	.byte 0b01100 0b00100 0b00010 0b00100 0b01100 # }
	.byte 0b01010 0b10100 0b00000 0b00000 0b00000 # ~

.globl frame_counter
frame_counter:    .word 0
last_frame_time:  .word 0
last_frame_keys:  .word 0
this_frame_keys:  .word 0

.text
# -------------------------------------------------------------------------------------------------
# returns a bitwise OR of the key constants, indicating which keys are being held down.
# you MUST call wait_for_next_frame for this to work properly.
.globl input_get_keys_held
input_get_keys_held:
	lw v0, this_frame_keys
	jr ra

# -------------------------------------------------------------------------------------------------
# returns a bitwise OR of the key constants, indicating which keys were pressed on this frame.
# you MUST call wait_for_next_frame for this to work properly.
.globl input_get_keys_pressed
input_get_keys_pressed:
	lw  t0, last_frame_keys
	not t0, t0
	lw  v0, this_frame_keys
	and v0, v0, t0
	jr ra

# -------------------------------------------------------------------------------------------------
# returns a bitwise OR of the key constants, indicating which keys were released on this frame.
# you MUST call wait_for_next_frame for this to work properly.
.globl input_get_keys_released
input_get_keys_released:
	lw  t0, this_frame_keys
	not t0, t0
	lw  v0, last_frame_keys
	and v0, v0, t0
	jr ra

# -------------------------------------------------------------------------------------------------
# call once per main loop to keep the game running at a given FPS.
# also increments frame_counter once per call.
.globl wait_for_next_frame
wait_for_next_frame:
enter s0
	lw s0, last_frame_time
	_loop:
		# while (sys_time() - last_frame_time) < MS_PER_FRAME {}
		syscall_time
		sub  t1, v0, s0
	bltu t1, MS_PER_FRAME, _loop

	# save the time
	sw v0, last_frame_time

	# frame_counter++
	lw  t0, frame_counter
	inc t0
	sw  t0, frame_counter

	# last_frame_keys = this_frame_keys
	lw t0, this_frame_keys
	sw t0, last_frame_keys

	# this_frame_keys = DISPLAY_KEYS
	lw t0, DISPLAY_KEYS
	sw t0, this_frame_keys
leave s0

# -------------------------------------------------------------------------------------------------
# copies the color data from display RAM onto the screen.
.globl display_update
display_update:
	sw zero, DISPLAY_CTRL
	jr ra

# -------------------------------------------------------------------------------------------------
# copies the color data from display RAM onto the screen, and then clears display RAM.
# does not clear the display, only the RAM so you can draw a new frame from scratch!
.globl display_update_and_clear
display_update_and_clear:
	li t0, 1
	sw t0, DISPLAY_CTRL
	jr ra

# -------------------------------------------------------------------------------------------------
# sets 1 pixel to a given color.
# (0, 0) is in the top LEFT, and Y increases DOWNWARDS!
# arguments:
#	a0 = x
#	a1 = y
#	a2 = color (use one of the constants above)
.globl display_set_pixel
display_set_pixel:
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64

	sll t0, a1, DISPLAY_W_SHIFT
	add t0, t0, a0
	add t0, t0, DISPLAY_BASE
	sb  a2, (t0)
	jr  ra

# -------------------------------------------------------------------------------------------------
# draws a horizontal line starting at (x, y) and going to (x + width - 1, y).
# (0, 0) is in the top LEFT of the screen.
# arguments:
#	a0 = x
#	a1 = y
#	a2 = width
#	a3 = color (use one of the constants above)
.globl display_draw_hline
display_draw_hline:
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64

	sll t0, a1, DISPLAY_W_SHIFT
	add t0, t0, a0
	add t0, t0, DISPLAY_BASE

	_loop:
		sb   a3, (t0)
		inc  t0
	dec  a2
	bnez a2, _loop

	jr       ra

# -------------------------------------------------------------------------------------------------
# draws a vertical line starting at (x, y) and going to (x, y + height - 1).
# (0, 0) is in the top LEFT, and Y increases DOWNWARDS!
# arguments:
#	a0 = x
#	a1 = y
#	a2 = height
#	a3 = color (use one of the constants above)
.globl display_draw_vline
display_draw_vline:
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64

	sll t0, a1, DISPLAY_W_SHIFT
	add t0, t0, a0
	add t0, t0, DISPLAY_BASE

	_loop:
		sb  a3, (t0)
		add t0, t0, DISPLAY_W
	dec  a2
	bnez a2, _loop

	jr       ra

# -------------------------------------------------------------------------------------------------
# fills a rectangle of pixels with a given color.
# there are FIVE arguments, and I was naughty and used 'v1' as a "fifth argument register."
# this is technically bad practice. sue me.
# arguments:
#	a0 = top-left corner x
#	a1 = top-left corner y
#	a2 = width
#	a3 = height
#	v1 = color (use one of the constants above)
.globl display_fill_rect
display_fill_rect:
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64

	# turn w/h into x2/y2
	add a2, a2, a0
	add a3, a3, a1

	# turn y1/y2 into addresses
	li  t0, DISPLAY_BASE
	sll a1, a1, DISPLAY_W_SHIFT
	add a1, a1, t0
	add a1, a1, a0
	sll a3, a3, DISPLAY_W_SHIFT
	add a3, a3, t0

	move t0, a1
	_loop_y:
		move t1, t0
		move t2, a0
		_loop_x:
			sb   v1, (t1)
			inc t1
		inc t2
		blt t2, a2, _loop_x
	addi t0, t0, DISPLAY_W
	blt  t0, a3, _loop_y

	jr       ra

# -------------------------------------------------------------------------------------------------
# exactly the same as display_fill_rect, but works faster for rectangles whose width and X coord
# are a multiple of 4.
# IF X IS NOT A MULTIPLE OF 4, IT WILL CRASH.
# IF WIDTH IS NOT A MULTIPLE OF 4, IT WILL DO WEIRD THINGS.
# arguments:
#	same as display_fill_rect.
.globl display_fill_rect_fast
display_fill_rect_fast:
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64

	# duplicate color across v1
	and v1, v1, 0xFF
	mul v1, v1, 0x01010101
	add a2, a2, a0 # a2 = x2
	add a3, a3, a1 # a3 = y2

	# t0 = display base address
	li t0, DISPLAY_BASE

	# a1 = start address
	sll a1, a1, DISPLAY_W_SHIFT
	add a1, a1, t0
	add a1, a1, a0

	# a3 = end address
	sll a3, a3, DISPLAY_W_SHIFT
	add a3, a3, t0

	# t0 = current row's start address
	move t0, a1
	_loop_y:
		move t1, t0 # t1 = current address
		move t2, a0 # t2 = current x
		_loop_x:
			sw   v1, (t1)
			addi t1, t1, 4
		addi t2, t2, 4
		blt  t2, a2, _loop_x
	addi t0, t0, DISPLAY_W
	blt  t0, a3, _loop_y

	jr       ra

# ------------------------------------------------------------------------------
# void display_draw_line(x1, y1, x2, y2, color: v1)
# Bresenham's line algorithm, integer error version adapted from wikipedia
# not SUPER fast, use display_draw_hline/display_draw_vline if you only need those directions
.globl display_draw_line
display_draw_line:
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64

	# dx:t0 =  abs(x2-x1);
	sub t0, a2, a0
	abs t0, t0

	# sx:t1 = x1<x2 ? 1 : -1;
	slt t1, a0, a2 # 1 if true, 0 if not
	add t1, t1, t1 # 2 if true, 0 if not
	sub t1, t1, 1  # 1 if true, -1 if not

	# dy:t2 = -abs(y2-y1);
	sub t2, a3, a1
	abs t2, t2
	neg t2, t2

	# sy:t3 = y1<y2 ? 1 : -1;
	slt t3, a1, a3
	add t3, t3, t3
	sub t3, t3, 1

	# err:t4 = dx+dy;
	add t4, t0, t2

	_loop:
		# plot(x1, y1);
		sll t7, a1, DISPLAY_W_SHIFT
		add t7, t7, a0
		add t7, t7, DISPLAY_BASE
		sb  v1, (t7)

		# if(x1==x2 && y1==y2) break;
		bne a0, a2, _continue
		beq a1, a3, _exit

		_continue:
			add t5, t4, t4 # e2:t5 = 2*err;

			# if(e2 >= dy)
			blt t5, t2, _dx
				add t4, t4, t2 # err += dy;
				add a0, a0, t1 # x1 += sx;

			_dx:
				# if(e2 <= dx)
				bgt t5, t0, _loop
					add t4, t4, t0 # err += dx;
					add a1, a1, t3 # y1 += sy;

	j _loop

_exit:
	jr ra

# -------------------------------------------------------------------------------------------------
# draws a string of text (using the font data at the top of the file) in white.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = pointer to string to print
.globl display_draw_text
display_draw_text:
	li a3, COLOR_WHITE
	j display_draw_colored_text

# -------------------------------------------------------------------------------------------------
# draws a string of text (using the font data at the top of the file) in whatever color you want.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = pointer to string to print
#   a3 = color
.globl display_draw_colored_text
display_draw_colored_text:
enter s0, s1, s2, s3
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64

	move s0, a0 # s0: x
	move s1, a1 # s1: y
	move s2, a2 # s2: char*
	move s3, a3 # s3: color

	_loop:
		lbu  t0, (s2)                         # t0 = ch
		beqz t0, _exit      # zero terminator?
		ble  t0, 32, _next  # nonprintable?
		bge  t0, 127, _next # nonprintable?

		# pattern = ASCII_patterns[ch - 33]
		sub  t0, t0, 33
		mul  t0, t0, CHAR_PATTERN_SIZE
		la   t1, ASCII_patterns
		add  a2, t0, t1

		# display_show_char(x, y, pattern, color)
		move a0, s0
		move a1, s1
		move a3, s3
		jal  display_show_char

	_next:
	add s0, s0, 6
	inc s2
	j   _loop

_exit:
leave s0, s1, s2, s3

# -------------------------------------------------------------------------------------------------
# draws a single character (using the font data at the top of the file) in white.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = character to print
.globl display_draw_char
display_draw_char:
	li a3, COLOR_WHITE
	j display_draw_colored_char

# -------------------------------------------------------------------------------------------------
# draws a single character (using the font data at the top of the file) in whatever color you want.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = character to print
#   a3 = color
.globl display_draw_colored_char
display_draw_colored_char:
enter
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64

	beqz a2, _exit      # NUL character?
	ble  a2, 32, _exit  # nonprintable?
	bge  a2, 127, _exit # nonprintable?

	# pattern = ASCII_patterns[ch - 33]
	sub  a2, a2, 33
	mul  a2, a2, CHAR_PATTERN_SIZE
	la   t0, ASCII_patterns
	add  a2, a2, t0

	# display_show_char(x, y, pattern, color)
	jal  display_show_char

_exit:
leave

# -------------------------------------------------------------------------------------------------
# draws a textual representation of an int in white.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = integer to display (can be negative, will show a - sign)

.globl display_draw_int
display_draw_int:
	li a3, COLOR_WHITE
	j  display_draw_colored_int

# -------------------------------------------------------------------------------------------------
# draws a textual representation of an int in whatever color you want.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = integer to display (can be negative, will show a - sign)
#   a3 = color

.globl display_draw_colored_int
display_draw_colored_int:
enter s0, s1, s2, s3, s4
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64

	move s0, a0 # current x
	move s1, a1 # y
	move s2, a2 # remaining digits to draw
	li   s3, 1  # radix (1, 10, 100 etc)
	move s4, a3 # color

	# if it's negative...
	bgez s2, _determine_length
		# make it positive
		neg  s2, s2

		# draw a -
		move a0, s0
		move a1, s1
		la   a2, pat_dash
		move a3, s4
		jal  display_show_char

		# move right by 6
		add  s0, s0, 6

	# determine the number of digits needed by multiplying radix
	# by 10 until the radix no longer divides into the number
	_determine_length:
		div  t0, s2, s3
		blt  t0, 10, _loop
		mul  s3, s3, 10
	j _determine_length

	_loop:
		# extract and strip off top digit
		div  s2, s3
		mfhi s2 # keep lower digits in s2
		mflo a2 # print top digit

		# get digit pattern address
		la   t0, Digit_patterns
		mul  a2, a2, CHAR_PATTERN_SIZE
		add  a2, a2, t0
		move a0, s0
		move a1, s1
		move a3, s4
		jal  display_show_char

		# scoot over, decrease radix until it's 0
		add  s0, s0, 6
		div  s3, s3, 10
	bnez s3, _loop
leave s0, s1, s2, s3, s4

# -------------------------------------------------------------------------------------------------
# draws a textual representation of an int in hex (WITHOUT leading 0x) in white.
# does not display negatives with a -, just FFF...etc.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = integer to display
#   a3 = digits to display [1..8]

.globl display_draw_int_hex
display_draw_int_hex:
	li v1, COLOR_WHITE
	j  display_draw_colored_int_hex

# -------------------------------------------------------------------------------------------------
# draws a textual representation of an int in hex (WITHOUT leading 0x)in whatever color you want.
# does not display negatives with a -, just FFF...etc.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = integer to display
#   a3 = digits to display [1..8]
#   v1 = color

.globl display_draw_colored_int_hex
display_draw_colored_int_hex:
enter s0, s1, s2, s3, s4
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64
	tlti a3, 1
	tgei a3, 9

	move s0, a0 # current x
	move s1, a1 # y
	move s2, a2 # remaining digits to draw
	sub  s3, a3, 1
	sll  s3, s3, 2 # shift amount (28, 24, 20...)
	move s4, v1 # color

	_loop:
		# extract current digit ((value >> shift_distance) & 0xF)
		srlv a2, s2, s3
		and  a2, a2, 0xF

		la t0, Digit_patterns
		blt a2, 10, _decimal
			sub a2, a2, 10
			la  t0, Uppercase_patterns
		_decimal:

		# get pattern address
		mul  a2, a2, CHAR_PATTERN_SIZE
		add  a2, a2, t0
		move a0, s0
		move a1, s1
		move a3, s4
		jal  display_show_char

		# scoot over, decrease shift amount until it's < 0
		add s0, s0, 6
		sub s3, s3, 4
	bgez s3, _loop
leave s0, s1, s2, s3, s4

# -------------------------------------------------------------------------------------------------
# quickly draw a 5x5-pixel pattern to the display. it can have transparent
# pixels; those with COLOR_NONE will not change the display. This way you can
# have "holes" in your images.
# this function screen-wraps vertically properly. horizontally it just cheats
# and takes advantage of the fact that writing past the end of a row writes to
# the next row, but it's one pixel... cmon...........
#	a0 = top-left x
#	a1 = top-left y
#	a2 = pointer to pattern (an array of 25 bytes stored row-by-row)

.globl display_blit_5x5_trans
display_blit_5x5_trans:
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64

	sll t1, a1, DISPLAY_W_SHIFT
	add t1, t1, DISPLAY_BASE
	add t1, t1, a0

.macro BLIT_TRANS_PIXEL %off1, %off2
	lb   t0, %off1(a2)
	bltz t0, _transparent
	sb   t0, %off2(t1)
_transparent:
.end_macro

.macro NEXT_ROW
	add t1, t1, 64
	blt t1, DISPLAY_END, _nowrap
	sub t1, t1, DISPLAY_SIZE
_nowrap:
.end_macro

	BLIT_TRANS_PIXEL 0, 0
	BLIT_TRANS_PIXEL 1, 1
	BLIT_TRANS_PIXEL 2, 2
	BLIT_TRANS_PIXEL 3, 3
	BLIT_TRANS_PIXEL 4, 4
	NEXT_ROW
	BLIT_TRANS_PIXEL 5, 0
	BLIT_TRANS_PIXEL 6, 1
	BLIT_TRANS_PIXEL 7, 2
	BLIT_TRANS_PIXEL 8, 3
	BLIT_TRANS_PIXEL 9, 4
	NEXT_ROW
	BLIT_TRANS_PIXEL 10, 0
	BLIT_TRANS_PIXEL 11, 1
	BLIT_TRANS_PIXEL 12, 2
	BLIT_TRANS_PIXEL 13, 3
	BLIT_TRANS_PIXEL 14, 4
	NEXT_ROW
	BLIT_TRANS_PIXEL 15, 0
	BLIT_TRANS_PIXEL 16, 1
	BLIT_TRANS_PIXEL 17, 2
	BLIT_TRANS_PIXEL 18, 3
	BLIT_TRANS_PIXEL 19, 4
	NEXT_ROW
	BLIT_TRANS_PIXEL 20, 0
	BLIT_TRANS_PIXEL 21, 1
	BLIT_TRANS_PIXEL 22, 2
	BLIT_TRANS_PIXEL 23, 3
	BLIT_TRANS_PIXEL 24, 4
	jr       ra

# -------------------------------------------------------------------------------------------------
# quickly draw a 5x5-pixel pattern to the display without transparency.
# if it has any COLOR_NONE pixels, the result is undefined.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = pointer to pattern (an array of 25 bytes stored row-by-row)

.globl display_blit_5x5
display_blit_5x5:
	tlti a0, 0
	tgei a0, 64
	tlti a1, 0
	tgei a1, 64

	sll a1, a1, DISPLAY_W_SHIFT
	add a1, a1, DISPLAY_BASE
	add a1, a1, a0

.macro BLIT_PIXEL %off1, %off2
	lb t0, %off1(a2)
	sb t0, %off2(a1)
.end_macro

	BLIT_PIXEL 0, 0
	BLIT_PIXEL 1, 1
	BLIT_PIXEL 2, 2
	BLIT_PIXEL 3, 3
	BLIT_PIXEL 4, 4

	BLIT_PIXEL 5, 64
	BLIT_PIXEL 6, 65
	BLIT_PIXEL 7, 66
	BLIT_PIXEL 8, 67
	BLIT_PIXEL 9, 68

	BLIT_PIXEL 10, 128
	BLIT_PIXEL 11, 129
	BLIT_PIXEL 12, 130
	BLIT_PIXEL 13, 131
	BLIT_PIXEL 14, 132

	BLIT_PIXEL 15, 192
	BLIT_PIXEL 16, 193
	BLIT_PIXEL 17, 194
	BLIT_PIXEL 18, 195
	BLIT_PIXEL 19, 196

	BLIT_PIXEL 20, 256
	BLIT_PIXEL 21, 257
	BLIT_PIXEL 22, 258
	BLIT_PIXEL 23, 259
	BLIT_PIXEL 24, 260
	jr       ra

# -------------------------------------------------------------------------------------------------
# draw a character pattern to the display. unlike graphical patterns, these are bitmasks:
# 1 to draw a pixel and 0 for transparency. the drawn pixels' color is given by a3.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = pointer to pattern (an array of 5 bytes stored row-by-row)
#   a3 = text color

# NOT globl, internal to this file
display_show_char:
	# t1: display pointer
	sll t1, a1, DISPLAY_W_SHIFT
	add t1, t1, DISPLAY_BASE
	add t1, t1, a0

.macro CHAR_PIXEL %mask, %off2
	and  t0, t2, %mask
	beqz t0, _transparent
	sb   a3, %off2(t1)
_transparent:
.end_macro

	# t2: pixel mask
	lb  t2, 0(a2)
	CHAR_PIXEL 0x10, 0
	CHAR_PIXEL 0x08, 1
	CHAR_PIXEL 0x04, 2
	CHAR_PIXEL 0x02, 3
	CHAR_PIXEL 0x01, 4

	lb  t2, 1(a2)
	CHAR_PIXEL 0x10, 64
	CHAR_PIXEL 0x08, 65
	CHAR_PIXEL 0x04, 66
	CHAR_PIXEL 0x02, 67
	CHAR_PIXEL 0x01, 68

	lb  t2, 2(a2)
	CHAR_PIXEL 0x10, 128
	CHAR_PIXEL 0x08, 129
	CHAR_PIXEL 0x04, 130
	CHAR_PIXEL 0x02, 131
	CHAR_PIXEL 0x01, 132

	lb  t2, 3(a2)
	CHAR_PIXEL 0x10, 192
	CHAR_PIXEL 0x08, 193
	CHAR_PIXEL 0x04, 194
	CHAR_PIXEL 0x02, 195
	CHAR_PIXEL 0x01, 196

	lb  t2, 4(a2)
	CHAR_PIXEL 0x10, 256
	CHAR_PIXEL 0x08, 257
	CHAR_PIXEL 0x04, 258
	CHAR_PIXEL 0x02, 259
	CHAR_PIXEL 0x01, 260

	jr ra