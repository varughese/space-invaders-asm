# MAV120
# Mathew Varughese

.include "convenience.asm"
.include "display.asm"

.eqv GAME_TICK_MS      16

# 2 ≤ X ≤ 57
# 46 ≤ Y ≤ 52
.eqv PLAYER_X_LBOUND	2
.eqv PLAYER_X_UBOUND	57
.eqv PLAYER_Y_LBOUND	46
.eqv PLAYER_Y_UBOUND	52

.data
# don't get rid of these, they're used by wait_for_next_frame.
last_frame_time:  .word 0
frame_counter:    .word 0

# PLAYER
player_image: .byte
	0	0	4	0	0
	0	4	7	4	0
	4	7	7	7	4
	4	4	4	4	4
	4	0	2	0	4
player_x: .word 30
player_y: .word 49



.text

# --------------------------------------------------------------------------------------------------

.globl main
main:
	# set up anything you need to here,
	# and wait for the user to press a key to start.

_main_loop:
	# check for input,
	jal check_input
	# update everything,
	jal draw_player
	# then draw everything.
	jal display_update_and_clear
	jal	wait_for_next_frame
	b	_main_loop

_game_over:
	exit

# --------------------------------------------------------------------------------------------------
# call once per main loop to keep the game running at 60FPS.
# if your code is too slow (longer than 16ms per frame), the framerate will drop.
# otherwise, this will account for different lengths of processing per frame.

wait_for_next_frame:
enter	s0
	lw	s0, last_frame_time
_wait_next_frame_loop:
	# while (sys_time() - last_frame_time) < GAME_TICK_MS {}
	li	v0, 30
	syscall # why does this return a value in a0 instead of v0????????????
	sub	t1, a0, s0
	bltu	t1, GAME_TICK_MS, _wait_next_frame_loop

	# save the time
	sw	a0, last_frame_time

	# frame_counter++
	lw	t0, frame_counter
	inc	t0
	sw	t0, frame_counter
leave	s0

# --------------------------------------------------------------------------------------------------

# .....and here's where all the rest of your code goes :D


check_input:
enter
	jal input_get_keys

	and t0, v0, KEY_L # t0 = keys & KEY_L
	and t1, v0, KEY_R # t1 = keys & KEY_R
	and t2, v0, KEY_U # t2 = keys & KEY_U
	and t3, v0, KEY_D # t3 = keys & KEY_D

	_check_key_l_pressed:
	bne t0, KEY_L, _check_key_r_pressed
	jal move_player_left
	_check_key_r_pressed:
	bne t1, KEY_R, _check_key_u_pressed
	jal move_player_right
	_check_key_u_pressed:
	bne t2, KEY_U, _check_key_d_pressed
	jal move_player_up
	_check_key_d_pressed:
	bne t3, KEY_D, _finish_check
	jal move_player_down

	_finish_check:

	jal check_player_in_bounds
leave

move_player_left:
enter
	lw t0, player_x
	dec t0
	sw t0, player_x
leave

move_player_right:
enter
	lw t0, player_x
	inc t0
	sw t0, player_x
leave

move_player_down:
enter
	lw t0, player_y
	inc t0
	sw t0, player_y
leave

move_player_up:
enter
	lw t0, player_y
	dec t0
	sw t0, player_y
leave

check_player_in_bounds:
enter
	lw t0, player_x
	lw t1, player_y

	li t2, PLAYER_X_LBOUND
	li t3, PLAYER_X_UBOUND
	li t4, PLAYER_Y_LBOUND
	li t5, PLAYER_Y_UBOUND

	_check_x_l_bound:
	bgt t0, PLAYER_X_LBOUND, _check_x_u_bound
	sw t2, player_x
	b _check_y_l_bound
	_check_x_u_bound:
	blt t0 PLAYER_X_UBOUND _check_y_l_bound
	sw t3, player_x

	_check_y_l_bound:
	bgt t1, PLAYER_Y_LBOUND, _check_y_u_bound
	sw t4, player_y
	_check_y_u_bound:
	blt t1, PLAYER_Y_UBOUND, _finish
	sw t5, player_y

	_finish:
leave

draw_player:
enter
	lw a0, player_x
	lw a1, player_y
	la a2, player_image
	jal display_blit_5x5
leave
