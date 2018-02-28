# MAV120
# Mathew Varughese

.include "convenience.asm"
.include "display.asm"
.include "images.asm"
.include "movement.asm"

.eqv GAME_TICK_MS      16

.eqv MAX_BULLETS 10
.eqv BULLET_RATE 10 # in frames

.eqv PLAYER_FIRE_RATE 2

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

bullet_x: 		.byte 0:MAX_BULLETS
bullet_y: 		.byte 0:MAX_BULLETS
bullet_active: 	.byte 0:MAX_BULLETS

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
	# move bullets
	jal move_bullets
	# draw everything,
	jal draw_player
	jal draw_player_lives
	jal draw_bullets_lefts
	jal draw_bullets
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
	# They clicked the B key:

	# t0 = frames since last fire
	lw t0, player_bullet_last_fired
	lw t1, frame_counter
	sub t0 t1 t0

	# attempt to fire bullet if frames since last fire is more than BULLET_RATE
	blt t0, BULLET_RATE, _finish_check_if_firing
	sw t1, player_bullet_last_fired

	jal fire_bullet

	_finish_check_if_firing:
leave


fire_bullet:
enter s0
	jal find_active_bullet
	move s0 v0

	bge s0 MAX_BULLETS _end_firebullet

	lw t0 player_x
	lw t1 player_y

	la t2 bullet_x
	add t2, t2, s0

	add t0, t0, 2 # to make it shoot from the center
	sb t0, (t2)

	la t2 bullet_y
	add t2, t2, s0
	sb t1, (t2)

	li t0 1
	la t1 bullet_active
	add t1, t1, s0
	sb t0 (t1)

	# Decrement bullets left and exit game if none left
	lw t1 player_bullets_left
	dec t1
	blt t1, 0, _game_over
	sw t1 player_bullets_left

	_end_firebullet:
leave s0

find_active_bullet:
enter
	li t0 0
	_main_loop_findactivebullet:
		bgt t0, MAX_BULLETS _end_findactivebullet
	_loop_findactivebullet:
		# bullet_active [i]
		la t1, bullet_active
		add t1, t1, t0
		lbu t2, (t1)

		beq t2, 0, _end_findactivebullet

		inc t0
		b _main_loop_findactivebullet
	_end_findactivebullet:
		move v0, t0
leave

move_bullets:
enter s0
	li s0 0
	_main_loop_movebullets:
		bgt s0, MAX_BULLETS _end_movebullets
	_loop_movebullets:
		lb t0 bullet_active(s0)

		bne t0 0, _move_bullet_up
		inc s0
		b _main_loop_movebullets

		_move_bullet_up:
		lbu t1 bullet_y(s0)
		dec t1

		blt t1 0 _delete_bullet
		sb t1 bullet_y(s0)
		b _do_not_delete_bullet
		
		_delete_bullet:
		sb zero bullet_active(s0)

		_do_not_delete_bullet:
		inc s0
		b _main_loop_movebullets


	_end_movebullets:
leave s0

####### END BULLETS

#


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

draw_bullets:
enter s0, s1
	li s0, 0
	jal find_active_bullet
	move s1 v0
	_draw_bullets_loop:
		bge s0 s1 _finish_draw_bullets_loop

		lbu	a0, bullet_x(s0)
		lbu	a1, bullet_y(s0)
		li	a2, COLOR_WHITE
		jal	display_set_pixel

		inc s0
		b _draw_bullets_loop
	_finish_draw_bullets_loop:
leave s0, s1
