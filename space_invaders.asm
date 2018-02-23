# MAV120
# Mathew Varughese

.include "convenience.asm"
.include "display.asm"
.include "images.asm"

.eqv GAME_TICK_MS      16

# 2 ≤ X ≤ 57
# 46 ≤ Y ≤ 52
.eqv PLAYER_X_LBOUND	2
.eqv PLAYER_X_UBOUND	57
.eqv PLAYER_Y_LBOUND	46
.eqv PLAYER_Y_UBOUND	52

.eqv MAX_BULLETS 10
.eqv BULLET_RATE 10 # in frames

.data
# don't get rid of these, they're used by wait_for_next_frame.
last_frame_time:  .word 0
frame_counter:    .word 0

# PLAYER
player_x: .word 30
player_y: .word 49
player_lives: .word 3
player_bullets_left: .word 50
player_bullet_last_fired: .word 0


.text

# --------------------------------------------------------------------------------------------------

.globl main
main:
	# set up anything you need to here,
	# and wait for the user to press a key to start.

_main_loop:
	# check for input,
	jal move_player
	jal check_if_firing
	# update everything,
	jal draw_player
	jal draw_player_lives
	jal draw_bullets_lefts
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

####### BULLETS
check_if_firing:
enter
	jal input_get_keys
	and t0, v0, KEY_B # t0 = keys & KEY_B

	bne t0, KEY_B, _finish_check_if_firing
	# they clicked the B key

	lw t0, player_bullet_last_fired
	lw t1, frame_counter
	sub t0 t1 t0
	# t0 = frames since last fire
	blt t0, BULLET_RATE, _finish_check_if_firing
	sw t1, player_bullet_last_fired

	lw t1 player_bullets_left
	dec t1
	sw t1 player_bullets_left
	_finish_check_if_firing:
leave
####### END BULLETS


####### MOVEMENT

move_player:
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
	bne t3, KEY_D, _finish_check_move_player
	jal move_player_down

	_finish_check_move_player:

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
	# add t0, t0, 5
	blt t0 PLAYER_X_UBOUND _check_y_l_bound
	sw t3, player_x

	_check_y_l_bound:
	# add t2, t1, 5
	bgt t1, PLAYER_Y_LBOUND, _check_y_u_bound
	sw t4, player_y
	b _finish
	_check_y_u_bound:
	blt t1, PLAYER_Y_UBOUND, _finish
	sw t5, player_y

	_finish:
leave

############## END MOVEMENT

############## DRAWING

draw_player:
enter
	lw a0, player_x
	lw a1, player_y
	la a2, player_image
	jal display_blit_5x5
leave

draw_player_lives:
enter s0, s1, s2, s3
	lw s0, player_lives
	li s1, 0 # incrementer, i=0
	li s2, 57 # rightmost x pos of heart
	li s3, 58 # y pos of heart
	_draw_lives_loop:
		mul t0, s1, 7
		sub t0, s2, t0

		move a0, t0
		move a1, s3
		la a2 player_life_image
		jal display_blit_5x5

		# i++
		inc s1
		bge s1 s0 _finish_draw_lives_loop
		b _draw_lives_loop
	_finish_draw_lives_loop:
leave s0, s1, s2, s3

draw_bullets_lefts:
enter
	# TODO: move these and 0, 57, 58 into constants
	li a0 2
	li a1 58
	lw a2 player_bullets_left
	jal display_draw_int
leave
