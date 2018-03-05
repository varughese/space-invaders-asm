# MAV120
# Mathew Varughese

.include "convenience.asm"
.include "display.asm"
.include "images.asm"
.include "movement.asm"

.eqv GAME_TICK_MS      16

.eqv MAX_BULLETS 10
# The time in frames between shots
.eqv PLAYER_SHOT_WAIT_TIME 10 # in frames
# The number of pixels the bullet moves a frame
.eqv BULLET_MOVEMENT_SPEED 1

.eqv ENEMY_COUNT 20
.eqv ENEMY_PER_ROW 5
.eqv ENEMY_PER_COL 4
.eqv ENEMY_ROW_SPACING 10
.eqv ENEMY_COL_SPACING 7

.eqv ENEMY_MOVEMENT_SPEED 10 # in frames

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

enemy_x:	.word 4
enemy_y:	.word 5
enemy_active: 	.byte 1:ENEMY_COUNT
enemy_direction: .word 1
enemy_last_moved: .word 0

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
	jal draw_enemies
	jal move_enemies
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

	# attempt to fire bullet if frames since last fire is more than PLAYER_SHOT_WAIT_TIME
	blt t0, PLAYER_SHOT_WAIT_TIME, _finish_check_if_firing
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
	ble t1, 0, _game_over
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
		bge s0, MAX_BULLETS _end_movebullets
	_loop_movebullets:
		lb t0 bullet_active(s0)

		bne t0 0, _move_bullet_up
		inc s0
		b _main_loop_movebullets

		_move_bullet_up:
		lbu t1 bullet_y(s0)
		sub t1 t1 BULLET_MOVEMENT_SPEED

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
	_draw_bullets_main_loop:
		bge s0 MAX_BULLETS _finish_draw_bullets_loop
	_draw_bullets_loop:
		lb t0 bullet_active(s0)
		beq t0 0, _skip_draw_bullet

		lbu	a0, bullet_x(s0)
		lbu	a1, bullet_y(s0)
		li	a2, COLOR_WHITE
		jal	display_set_pixel

		_skip_draw_bullet:
		inc s0
		b _draw_bullets_main_loop
	_finish_draw_bullets_loop:
leave s0, s1

draw_enemies:
enter s0 s1 s2 s3
	li s0, 0
	lw s2, enemy_x
	lw s3, enemy_y
	_draw_enemies_row_main_loop:
		bge s0  ENEMY_PER_ROW _finish_draw_enemies_row
	_draw_enemies_row_loop:
		li, s1, 0
		_draw_enemies_col_main_loop:
			bge s1 ENEMY_PER_COL _finish_draw_enemies_col_loop
		_draw_enemies_col_loop:
			lw a0 enemy_x
			lw a1 enemy_y

			mul t0 s0, ENEMY_ROW_SPACING

			mul t1 s1 ENEMY_COL_SPACING

			add a0 a0 t0
			add a1 a1 t1

			la a2 enemy_image
			jal display_blit_5x5
			inc s1
			b _draw_enemies_col_main_loop
		_finish_draw_enemies_col_loop:
		inc s0
		b _draw_enemies_row_main_loop
	_finish_draw_enemies_row:
leave s0 s1 s2 s3

move_enemies:
enter
	# Welcome to probably the most complicated function of the project

	# check frames since last moved
	lw t3 enemy_last_moved
	lw t4 frame_counter
	sub t3 t4 t3 # t3 : time since last moved
	blt t3 ENEMY_MOVEMENT_SPEED, _dont_move_enemies
	sw t4 enemy_last_moved


	lw t0 enemy_x
	# Determine if we must change the direction of the fleet:

	# Rightmost ship's x coordinate will be at
	# enemy_x + 5 + ENEMY_ROW_SPACING(ENEMY_PER_ROW-1)
	# but, have to minus 5 pixels to account for the fact that
	# they will be displayed 5 pixels more, because display_blit_5x5
	# draws top left
	li t1 ENEMY_PER_ROW
	dec t1
	mul t1 t1 ENEMY_ROW_SPACING
	add t1 t1 t0

	lw t2 enemy_direction
	# t1 has the x coordinate of rightmost ship
	# if the ship should change direction, it moves down first and
	# then goes the other way

	bne t2 1 _check_if_enemy_touching_left_side
	bgt t1 PLAYER_X_UBOUND, _move_e_down
	_check_if_enemy_touching_left_side:
	bne t2 -1 _skip_enemy_side_check
	blt t0 PLAYER_X_LBOUND, _move_e_down

	_skip_enemy_side_check:
	# determine the direction to go
	# -1 left, 1 right

	beq t2, 1, _move_e_right
	_move_e_left:
	dec t0
	b _finish_move_e

	_move_e_right:
	inc t0

	_finish_move_e:
	sw t0 enemy_x
	b _dont_move_enemies

	_move_e_down:
	# have to calculate the lower most thing, and only move down
	# if its bounds

	# ENEMY_Y + 5 + ENEMY_COL_SPACING(ENEMY_PER_COL-1)
	# is bottom ship row's pixel

	lw t0 enemy_y
	li t1, ENEMY_PER_ROW
	dec t1
	mul t1 t1 ENEMY_COL_SPACING
	add t1, t1, 5
	add t1 t1 t0

	bgt t1 PLAYER_Y_UBOUND _its_not_okay_to_move_enemy_down

	_its_okay_to_move_enemy_down:
	inc t0
	sw t0 enemy_y
	_its_not_okay_to_move_enemy_down:
	mul t2, t2, -1
	sw t2 enemy_direction

	_dont_move_enemies:
leave
