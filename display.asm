# MAV120
# Mathew Varughese

# MMIO Registers
.eqv DISPLAY_CTRL 0xFFFF0000
.eqv DISPLAY_KEYS 0xFFFF0004
.eqv DISPLAY_BASE 0xFFFF0008

# Display stuff
.eqv DISPLAY_W       64
.eqv DISPLAY_H       64
.eqv DISPLAY_W_SHIFT 6

# LED Colors
.eqv COLOR_BLACK   0
.eqv COLOR_RED     1
.eqv COLOR_ORANGE  2
.eqv COLOR_YELLOW  3
.eqv COLOR_GREEN   4
.eqv COLOR_BLUE    5
.eqv COLOR_MAGENTA 6
.eqv COLOR_WHITE   7
.eqv COLOR_NONE    0xFF

# Input key flags
.eqv KEY_NONE 0x00
.eqv KEY_U    0x01
.eqv KEY_D    0x02
.eqv KEY_L    0x04
.eqv KEY_R    0x08
.eqv KEY_B    0x10

.data
# each character is a 5x5 pixel block, stored row-by-row.
# have a look at the comments on the right to see what each character is.
pat_bang:   .byte 0 0 7 0 0  0 0 7 0 0  0 0 7 0 0  0 0 0 0 0  0 0 7 0 0 # !
pat_quote:  .byte 0 7 0 7 0  0 7 0 7 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0 # "
pat_pound:  .byte 0 7 0 7 0  7 7 7 7 7  0 7 0 7 0  7 7 7 7 7  0 7 0 7 0 # #
pat_dollar: .byte 0 7 7 7 0  7 0 7 0 0  0 7 7 7 0  0 0 7 0 7  0 7 7 7 0 # $
pat_percent:.byte 7 0 0 0 7  0 0 0 7 0  0 0 7 0 0  0 7 0 0 0  7 0 0 0 7 # %
pat_and:    .byte 0 7 0 0 0  7 0 7 0 0  0 7 0 0 0  7 0 7 0 7  0 7 0 7 0 # &
pat_apos:   .byte 0 0 7 0 0  0 0 7 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0 # '
pat_lpar:   .byte 0 0 0 7 0  0 0 7 0 0  0 0 7 0 0  0 0 7 0 0  0 0 0 7 0 # (
pat_rpar:   .byte 0 7 0 0 0  0 0 7 0 0  0 0 7 0 0  0 0 7 0 0  0 7 0 0 0 # )
pat_star:   .byte 0 0 7 0 0  7 0 7 0 7  0 7 7 7 0  0 7 0 7 0  7 0 0 0 7 # *
pat_plus:   .byte 0 0 0 0 0  0 0 7 0 0  0 7 7 7 0  0 0 7 0 0  0 0 0 0 0 # +
pat_comma:  .byte 0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 7 0 0 0  7 0 0 0 0 # ,
pat_dash:   .byte 0 0 0 0 0  0 0 0 0 0  0 7 7 7 0  0 0 0 0 0  0 0 0 0 0 # -
pat_dot:    .byte 0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  7 0 0 0 0 # .
pat_fsl:    .byte 0 0 0 0 7  0 0 0 7 0  0 0 7 0 0  0 7 0 0 0  7 0 0 0 0 # /
pat_colon:  .byte 0 0 0 0 0  0 7 0 0 0  0 0 0 0 0  0 7 0 0 0  0 0 0 0 0 # :
pat_semi:   .byte 0 0 0 0 0  0 7 0 0 0  0 0 0 0 0  0 7 0 0 0  7 0 0 0 0 # ;
pat_lt:     .byte 0 0 0 7 7  0 7 7 0 0  7 0 0 0 0  0 7 7 0 0  0 0 0 7 7 # <
pat_eq:     .byte 0 0 0 0 0  0 7 7 7 0  0 0 0 0 0  0 7 7 7 0  0 0 0 0 0 # =
pat_gt:     .byte 7 7 0 0 0  0 0 7 7 0  0 0 0 0 7  0 0 7 7 0  7 7 0 0 0 # >
pat_ques:   .byte 0 7 7 7 0  7 0 0 0 7  0 0 0 7 0  0 0 0 0 0  0 0 0 7 0 # ?
pat_lsq:    .byte 0 7 7 7 0  0 7 0 0 0  0 7 0 0 0  0 7 0 0 0  0 7 7 7 0 # [
pat_bsl:    .byte 7 0 0 0 0  0 7 0 0 0  0 0 7 0 0  0 0 0 7 0  0 0 0 0 7 # \
pat_rsq:    .byte 0 7 7 7 0  0 0 0 7 0  0 0 0 7 0  0 0 0 7 0  0 7 7 7 0 # ]
pat_caret:  .byte 0 0 7 0 0  0 7 0 7 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0 # ^
pat_under:  .byte 0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0  7 7 7 7 7 # _
pat_lbra:   .byte 0 0 7 7 0  0 0 7 0 0  0 7 0 0 0  0 0 7 0 0  0 0 7 7 0 # {
pat_or:     .byte 0 0 7 0 0  0 0 7 0 0  0 0 7 0 0  0 0 7 0 0  0 0 7 0 0 # |
pat_rbra:   .byte 0 7 7 0 0  0 0 7 0 0  0 0 0 7 0  0 0 7 0 0  0 7 7 0 0 # }
pat_tilde:  .byte 0 7 0 7 0  7 0 7 0 0  0 0 0 0 0  0 0 0 0 0  0 0 0 0 0 # ~
pat_at:     .byte 0 7 7 7 0  7 0 0 0 7  7 0 7 7 7  7 0 0 0 0  0 7 7 7 0 # @
pat_back:   .byte 0 7 0 0 0  0 0 7 0 0  0 0 0 7 0  0 0 0 0 0  0 0 0 0 0 # `
pat_A:      .byte 0 7 7 7 0  7 0 0 0 7  7 7 7 7 7  7 0 0 0 7  7 0 0 0 7
pat_B:      .byte 7 7 7 7 0  7 0 0 0 7  7 7 7 7 0  7 0 0 0 7  7 7 7 7 0
pat_C:      .byte 0 7 7 7 0  7 0 0 0 0  7 0 0 0 0  7 0 0 0 0  0 7 7 7 0
pat_D:      .byte 7 7 7 7 0  7 0 0 0 7  7 0 0 0 7  7 0 0 0 7  7 7 7 7 0
pat_E:      .byte 7 7 7 7 7  7 0 0 0 0  7 7 7 0 0  7 0 0 0 0  7 7 7 7 7
pat_F:      .byte 7 7 7 7 7  7 0 0 0 0  7 7 7 0 0  7 0 0 0 0  7 0 0 0 0
pat_G:      .byte 0 7 7 7 0  7 0 0 0 0  7 0 0 7 7  7 0 0 0 7  0 7 7 7 0
pat_H:      .byte 7 0 0 0 7  7 0 0 0 7  7 7 7 7 7  7 0 0 0 7  7 0 0 0 7
pat_I:      .byte 0 7 7 7 0  0 0 7 0 0  0 0 7 0 0  0 0 7 0 0  0 7 7 7 0
pat_J:      .byte 0 7 7 7 0  0 0 7 0 0  0 0 7 0 0  7 0 7 0 0  0 7 0 0 0
pat_K:      .byte 7 0 0 7 0  7 0 7 0 0  7 7 0 0 0  7 0 7 0 0  7 0 0 7 0
pat_L:      .byte 7 0 0 0 0  7 0 0 0 0  7 0 0 0 0  7 0 0 0 0  7 7 7 7 7
pat_M:      .byte 7 0 0 0 7  7 7 0 7 7  7 0 7 0 7  7 0 0 0 7  7 0 0 0 7
pat_N:      .byte 7 0 0 0 7  7 7 0 0 7  7 0 7 0 7  7 0 0 7 7  7 0 0 0 7
pat_O:      .byte 0 7 7 7 0  7 0 0 0 7  7 0 0 0 7  7 0 0 0 7  0 7 7 7 0
pat_P:      .byte 7 7 7 7 0  7 0 0 0 7  7 7 7 7 7  7 0 0 0 0  7 0 0 0 0
pat_Q:      .byte 0 7 7 7 0  7 0 0 0 7  7 0 7 0 7  7 0 0 7 7  0 7 7 7 7
pat_R:      .byte 7 7 7 7 0  7 0 0 0 7  7 7 7 7 7  7 0 0 7 0  7 0 0 0 7
pat_S:      .byte 7 7 7 7 7  7 0 0 0 0  7 7 7 7 7  0 0 0 0 7  7 7 7 7 7
pat_T:      .byte 7 7 7 7 7  0 0 7 0 0  0 0 7 0 0  0 0 7 0 0  0 0 7 0 0
pat_U:      .byte 7 0 0 0 7  7 0 0 0 7  7 0 0 0 7  7 0 0 0 7  0 7 7 7 0
pat_V:      .byte 7 0 0 0 7  7 0 0 0 7  0 7 0 7 0  0 7 0 7 0  0 0 7 0 0
pat_W:      .byte 7 0 0 0 7  7 0 0 0 7  7 0 7 0 7  7 7 0 7 7  7 0 0 0 7
pat_X:      .byte 7 0 0 0 7  0 7 0 7 0  0 0 7 0 0  0 7 0 7 0  7 0 0 0 7
pat_Y:      .byte 7 0 0 0 7  0 7 0 7 0  0 0 7 0 0  0 0 7 0 0  0 0 7 0 0
pat_Z:      .byte 7 7 7 7 7  0 0 0 7 0  0 0 7 0 0  0 7 0 0 0  7 7 7 7 7
pat_0:      .byte 0 7 7 7 0  7 0 0 7 7  7 0 7 0 7  7 7 0 0 7  0 7 7 7 0
pat_1:      .byte 0 0 7 0 0  0 7 7 0 0  0 0 7 0 0  0 0 7 0 0  0 7 7 7 0
pat_2:      .byte 7 7 7 7 7  0 0 0 0 7  7 7 7 7 7  7 0 0 0 0  7 7 7 7 7
pat_3:      .byte 7 7 7 7 0  0 0 0 0 7  0 0 7 7 0  0 0 0 0 7  7 7 7 7 0
pat_4:      .byte 7 0 0 0 7  7 0 0 0 7  7 7 7 7 7  0 0 0 0 7  0 0 0 0 7
pat_5:      .byte 7 7 7 7 7  7 0 0 0 0  7 7 7 7 0  0 0 0 0 7  7 7 7 7 0
pat_6:      .byte 0 7 7 7 0  7 0 0 0 0  7 7 7 7 0  7 0 0 0 7  0 7 7 7 0
pat_7:      .byte 7 7 7 7 7  0 0 0 0 7  0 0 0 7 0  0 0 7 0 0  0 7 0 0 0
pat_8:      .byte 0 7 7 7 0  7 0 0 0 7  0 7 7 7 0  7 0 0 0 7  0 7 7 7 0
pat_9:      .byte 0 7 7 7 0  7 0 0 0 7  0 7 7 7 7  0 0 0 0 7  0 7 7 7 0

# start at ASCII 32 since anything below that is unprintable
# a 0 means NULL i.e. unprintable character
ASCII_patterns: .word
	0	 pat_bang pat_quote pat_pound pat_dollar pat_percent pat_and   pat_apos
	pat_lpar pat_rpar pat_star  pat_plus  pat_comma  pat_dash    pat_dot   pat_fsl
# overlapping arrays!
Digit_patterns:  .word
	pat_0    pat_1    pat_2     pat_3     pat_4      pat_5       pat_6     pat_7
	pat_8    pat_9    pat_colon pat_semi  pat_lt     pat_eq      pat_gt    pat_ques
	pat_at   pat_A    pat_B     pat_C     pat_D      pat_E       pat_F     pat_G
	pat_H    pat_I    pat_J     pat_K     pat_L      pat_M       pat_N     pat_O
	pat_P    pat_Q    pat_R     pat_S     pat_T      pat_U       pat_V     pat_W
	pat_X    pat_Y    pat_Z     pat_lsq   pat_bsl    pat_rsq     pat_caret pat_under
	pat_back pat_A    pat_B     pat_C     pat_D      pat_E       pat_F     pat_G
	pat_H    pat_I    pat_J     pat_K     pat_L      pat_M       pat_N     pat_O
	pat_P    pat_Q    pat_R     pat_S     pat_T      pat_U       pat_V     pat_W
	pat_X    pat_Y    pat_Z     pat_lbra  pat_or     pat_rbra    pat_tilde 0

.text
# --------------------------------------------------------------------------------------------------
# returns a bitwise OR of the above key constants, indicating which keys are being held down.
input_get_keys:
	lw	v0, DISPLAY_KEYS
	jr	ra

# --------------------------------------------------------------------------------------------------
# copies the color data from display RAM onto the screen.
display_update:
	sw	zero, DISPLAY_CTRL
	jr	ra

# --------------------------------------------------------------------------------------------------
# copies the color data from display RAM onto the screen, and then clears display RAM.
# does not clear the display, only the RAM so you can draw a new frame from scratch!
display_update_and_clear:
	li	t0, 1
	sw	t0, DISPLAY_CTRL
	jr	ra

# --------------------------------------------------------------------------------------------------
# sets 1 pixel to a given color.
# (0, 0) is in the top LEFT, and Y increases DOWNWARDS!
# arguments:
#	a0 = x
#	a1 = y
#	a2 = color (use one of the constants above)
display_set_pixel:
	sll	t0, a1, DISPLAY_W_SHIFT
	add	t0, t0, a0
	add	t0, t0, DISPLAY_BASE
	sb	a2, (t0)
	jr	ra

# --------------------------------------------------------------------------------------------------
# fills a rectangle of pixels with a given color.
# there are FIVE arguments, and I was naughty and used 'v1' as a "fifth argument register."
# this is technically bad practice. sue me.
# arguments:
#	a0 = top-left corner x
#	a1 = top-left corner y
#	a2 = width
#	a3 = height
#	v1 = color (use one of the constants above)
display_fill_rect:
	# turn w/h into x2/y2
	add	a2, a2, a0
	add	a3, a3, a1

	# turn y1/y2 into addresses
	li	t0, DISPLAY_BASE
	sll	a1, a1, DISPLAY_W_SHIFT
	add	a1, a1, t0
	add	a1, a1, a0
	sll	a3, a3, DISPLAY_W_SHIFT
	add	a3, a3, t0

	move	t0, a1
_fill_loop_y:
	move	t1, t0
	move	t2, a0
_fill_loop_x:
	sb	v1, (t1)
	addi	t1, t1, 1
	addi	t2, t2, 1
	blt	t2, a2, _fill_loop_x

	addi	t0, t0, DISPLAY_W
	blt	t0, a3, _fill_loop_y

	jr	ra

# --------------------------------------------------------------------------------------------------
# exactly the same as display_fill_rect, but works faster for rectangles whose width and X coord
# are a multiple of 4.
# IF X IS NOT A MULTIPLE OF 4, IT WILL CRASH.
# IF WIDTH IS NOT A MULTIPLE OF 4, IT WILL DO WEIRD THINGS.
# arguments:
#	same as display_fill_rect.
display_fill_rect_fast:
	# duplicate color across v1
	and	v1, v1, 0xFF
	mul	v1, v1, 0x01010101

	# a2 = x2
	add	a2, a2, a0

	# a3 = y2
	add	a3, a3, a1

	# t0 = display base address
	li	t0, DISPLAY_BASE

	# a1 = start address
	sll	a1, a1, DISPLAY_W_SHIFT
	add	a1, a1, t0
	add	a1, a1, a0

	# a3 = end address
	sll	a3, a3, DISPLAY_W_SHIFT
	add	a3, a3, t0

	# t0 = current row's start address
	move	t0, a1
_fast_fill_loop_y:
	move	t1, t0 # t1 = current address
	move	t2, a0 # t2 = current x
_fast_fill_loop_x:
	sw	v1, (t1)
	addi	t1, t1, 4
	addi	t2, t2, 4
	blt	t2, a2, _fast_fill_loop_x

	addi	t0, t0, DISPLAY_W
	blt	t0, a3, _fast_fill_loop_y

	jr	ra

# --------------------------------------------------------------------------------------------------
# draws a string of text (using the font data at the top of the file)
#	a0 = top-left x
#	a1 = top-left y
#	a2 = pointer to string to print

display_draw_text:
	sub	sp, sp, 16
	sw	ra, 0(sp)
	sw	s0, 4(sp)
	sw	s1, 8(sp)
	sw	s2, 12(sp)
	move	s0, a0
	move	s1, a1
	move	s2, a2

_draw_text_loop:
	lbu	t0, (s2)
	beqz	t0, _draw_text_exit
	ble	t0, 32, _draw_text_next
	bge	t0, 127, _draw_text_next
	sub	t0, t0, 32

	la	t1, ASCII_patterns
	sll	t0, t0, 2
	add	t0, t0, t1
	lw	a2, (t0)
	beqz	a2, _draw_text_next

	move	a0, s0
	move	a1, s1
	jal	display_blit_5x5

_draw_text_next:
	add	s0, s0, 6
	inc	s2
	b	_draw_text_loop

_draw_text_exit:
	lw	ra, 0(sp)
	lw	s0, 4(sp)
	lw	s1, 8(sp)
	lw	s2, 12(sp)
	add	sp, sp, 16
	jr	ra

# --------------------------------------------------------------------------------------------------
# draws a textual representation of an int.
#	a0 = top-left x,
#	a1 = top-left y
#	a2 = integer to display (can be negative)

display_draw_int:
	sub	sp, sp, 20
	sw	ra, 0(sp)
	sw	s0, 4(sp)  # current x
	sw	s1, 8(sp)  # y
	sw	s2, 12(sp) # remaining digits to draw
	sw	s2, 16(sp) # radix (1, 10, 100 etc)
	move	s0, a0
	move	s1, a1
	move	s2, a2
	li	s3, 1

	bgez	s2, _draw_int_determine_length

	# if it's negative, make it positive and draw a minus sign
	neg	s2, s2
	move	a0, s0
	move	a1, s1
	la	a2, pat_dash
	jal	display_blit_5x5
	add	s0, s0, 6

	# determine the number of digits needed by multiplying radix
	# by 10 until the radix no longer divides into the number
_draw_int_determine_length:
	move	t0, s3
	div	t1, s2, t0
	blt	t1, 10, _draw_int_loop
	mul	s3, s3, 10
	b	_draw_int_determine_length

_draw_int_loop:
	# extract and strip off top digit
	div	s2, s3
	mfhi	s2			# keep lower digits in s2
	mflo	a2			# print top digit

	# get digit pattern address
	la	t0, Digit_patterns
	sll	a2, a2, 2
	add	a2, a2, t0
	lw	a2, (a2)
	move	a0, s0
	move	a1, s1
	jal	display_blit_5x5

	# scoot over, decrease radix until it's 0
	add	s0, s0, 6
	div	s3, s3, 10
	bnez	s3, _draw_int_loop

_draw_int_exit:
	lw	ra, 0(sp)
	lw	s0, 4(sp)
	lw	s1, 8(sp)
	lw	s2, 12(sp)
	lw	s2, 16(sp)
	add	sp, sp, 20
	jr	ra

# --------------------------------------------------------------------------------------------------
# quickly draw a 5x5-pixel pattern to the display. it can have transparent
# pixels; those with COLOR_NONE will not change the display. This way you can
# have "holes" in your images.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = pointer to pattern (an array of 25 bytes stored row-by-row)

display_blit_5x5_trans:
	sll	a1, a1, DISPLAY_W_SHIFT
	add	a1, a1, DISPLAY_BASE
	add	a1, a1, a0

	lb	t0, 0(a2)
	bltz	t0, _blitA
	sb	t0, 0(a1)
_blitA:	lb	t0, 1(a2)
	bltz	t0, _blitB
	sb	t0, 1(a1)
_blitB:	lb	t0, 2(a2)
	bltz	t0, _blitC
	sb	t0, 2(a1)
_blitC:	lb	t0, 3(a2)
	bltz	t0, _blitD
	sb	t0, 3(a1)
_blitD:	lb	t0, 4(a2)
	bltz	t0, _blitE
	sb	t0, 4(a1)

_blitE:	lb	t0, 5(a2)
	bltz	t0, _blitF
	sb	t0, 64(a1)
_blitF:	lb	t0, 6(a2)
	bltz	t0, _blitG
	sb	t0, 65(a1)
_blitG:	lb	t0, 7(a2)
	bltz	t0, _blitH
	sb	t0, 66(a1)
_blitH:	lb	t0, 8(a2)
	bltz	t0, _blitI
	sb	t0, 67(a1)
_blitI:	lb	t0, 9(a2)
	bltz	t0, _blitJ
	sb	t0, 68(a1)

_blitJ:	lb	t0, 10(a2)
	bltz	t0, _blitK
	sb	t0, 128(a1)
_blitK:	lb	t0, 11(a2)
	bltz	t0, _blitL
	sb	t0, 129(a1)
_blitL:	lb	t0, 12(a2)
	bltz	t0, _blitM
	sb	t0, 130(a1)
_blitM:	lb	t0, 13(a2)
	bltz	t0, _blitN
	sb	t0, 131(a1)
_blitN:	lb	t0, 14(a2)
	bltz	t0, _blitO
	sb	t0, 132(a1)

_blitO:	lb	t0, 15(a2)
	bltz	t0, _blitP
	sb	t0, 192(a1)
_blitP:	lb	t0, 16(a2)
	bltz	t0, _blitQ
	sb	t0, 193(a1)
_blitQ:	lb	t0, 17(a2)
	bltz	t0, _blitR
	sb	t0, 194(a1)
_blitR:	lb	t0, 18(a2)
	bltz	t0, _blitS
	sb	t0, 195(a1)
_blitS:	lb	t0, 19(a2)
	bltz	t0, _blitT
	sb	t0, 196(a1)

_blitT:	lb	t0, 20(a2)
	bltz	t0, _blitU
	sb	t0, 256(a1)
_blitU:	lb	t0, 21(a2)
	bltz	t0, _blitV
	sb	t0, 257(a1)
_blitV:	lb	t0, 22(a2)
	bltz	t0, _blitW
	sb	t0, 258(a1)
_blitW:	lb	t0, 23(a2)
	bltz	t0, _blitX
	sb	t0, 259(a1)
_blitX:	lb	t0, 24(a2)
	bltz	t0, _blit_exit
	sb	t0, 260(a1)
_blit_exit:
	jr	ra

# --------------------------------------------------------------------------------------------------
# quickly draw a 5x5-pixel pattern to the display without transparency.
# if it has any COLOR_NONE pixels, the result is undefined.
#	a0 = top-left x
#	a1 = top-left y
#	a2 = pointer to pattern (an array of 25 bytes stored row-by-row)

display_blit_5x5:
	sll	a1, a1, DISPLAY_W_SHIFT
	add	a1, a1, DISPLAY_BASE
	add	a1, a1, a0

	lb	t0, 0(a2)
	sb	t0, 0(a1)
	lb	t0, 1(a2)
	sb	t0, 1(a1)
	lb	t0, 2(a2)
	sb	t0, 2(a1)
	lb	t0, 3(a2)
	sb	t0, 3(a1)
	lb	t0, 4(a2)
	sb	t0, 4(a1)

	lb	t0, 5(a2)
	sb	t0, 64(a1)
	lb	t0, 6(a2)
	sb	t0, 65(a1)
	lb	t0, 7(a2)
	sb	t0, 66(a1)
	lb	t0, 8(a2)
	sb	t0, 67(a1)
	lb	t0, 9(a2)
	sb	t0, 68(a1)

	lb	t0, 10(a2)
	sb	t0, 128(a1)
	lb	t0, 11(a2)
	sb	t0, 129(a1)
	lb	t0, 12(a2)
	sb	t0, 130(a1)
	lb	t0, 13(a2)
	sb	t0, 131(a1)
	lb	t0, 14(a2)
	sb	t0, 132(a1)

	lb	t0, 15(a2)
	sb	t0, 192(a1)
	lb	t0, 16(a2)
	sb	t0, 193(a1)
	lb	t0, 17(a2)
	sb	t0, 194(a1)
	lb	t0, 18(a2)
	sb	t0, 195(a1)
	lb	t0, 19(a2)
	sb	t0, 196(a1)

	lb	t0, 20(a2)
	sb	t0, 256(a1)
	lb	t0, 21(a2)
	sb	t0, 257(a1)
	lb	t0, 22(a2)
	sb	t0, 258(a1)
	lb	t0, 23(a2)
	sb	t0, 259(a1)
	lb	t0, 24(a2)
	sb	t0, 260(a1)

	jr	ra

# --------------------------------------------------------------------------------------------------
# draws all printable characters on the display.
# good for having a look at the characters if you want to change them.

display_font_test:
	push	ra
	push	s0

	la	s0, ASCII_patterns
	li	s2, 2

_font_test_row:
	li	s1, 2
_font_test_col:
	move	a0, s1
	move	a1, s2
	lw	a2, (s0)
	add	s0, s0, 4

	beqz	a2, _font_test_skip

	jal	display_blit_5x5

_font_test_skip:
	add	s1, s1, 6
	blt	s1, 60, _font_test_col
	add	s2, s2, 6
	blt	s2, 60, _font_test_row

	pop	s0
	pop	ra
	jr	ra
