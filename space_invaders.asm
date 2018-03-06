# MAV120
# Mathew Varughese

.include "convenience.asm"
.include "display.asm"
.include "images.asm"
.include "movement.asm"
.include "bullets.asm"

.eqv GAME_TICK_MS      16

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

.eqv ENEMY_BULLET_COUNT 5
enemy_bullets: .byte 0:ENEMY_BULLET_COUNT
enemy_bullets_active: .byte 0:ENEMY_BULLET_COUNT
enemy_bullet_x: .byte 0:ENEMY_BULLET_COUNT
enemy_bullet_y: .byte 0:ENEMY_BULLET_COUNT


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

	jal check_if_enemy_firing

	# move bullets
	jal move_bullets
	jal move_enemies

	# draw everything,
	jal draw_player
	jal draw_player_lives
	jal draw_bullets_lefts
	jal draw_bullets
	jal draw_enemies

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

check_if_enemy_firing:
enter
leave

check_if_bullet_hit_enemy:
enter s0, s1, s2, s3
# a0: bullet x
# a1: bullet y
# a3: bullet pos
# kills enemy

	li s0, 0
	li s1, 0
	li s2, 0
	move a3, s3
	_checkbullet_hit_enemies_row_main_loop:
		bge s0  ENEMY_PER_ROW _finish_checkbullet_hit_enemies_row
	_checkbullet_hit_enemies_row_loop:
		li, s1, 0
		_checkbullet_hit_enemies_col_main_loop:
			bge s1 ENEMY_PER_COL _finish_checkbullet_hit_enemies_col_loop
		_checkbullet_hit_enemies_col_loop:
			lb t0 enemy_active(s2)
			beq t0 0 _do_not_kill_enemy_and_bullet

			lw a2 enemy_x
			lw a3 enemy_y

			mul t0 s0, ENEMY_ROW_SPACING
			mul t1 s1 ENEMY_COL_SPACING

			add a2 a2 t0
			add a3 a3 t1

			li v0 0
			jal check_if_bullet_in_hitbox
			beq v0 0 _do_not_kill_enemy_and_bullet
			sb zero enemy_active(s2)
			sb zero bullet_active(s3)
			_do_not_kill_enemy_and_bullet:
			inc s1
			inc s2

			b _checkbullet_hit_enemies_col_main_loop
		_finish_checkbullet_hit_enemies_col_loop:
		inc s0
		b _checkbullet_hit_enemies_row_main_loop
	_finish_checkbullet_hit_enemies_row:
leave s0, s1, s2, s3

check_if_bullet_in_hitbox:
enter
	# (a0, a1, a2, a3)
	# a0 - x of bullet
	# a1 - y of bullet
	# a2 - x of hitbox (assuming 5 x 5)
	# a3 - y of hitbox
	# return 1 if true, 0 if not

	# (a2 <= a0 <= a2 + 5) &&
	# (a3 <= a1 <= a3 + 5)

	add t0 a2 5
	add t1 a3 5

	blt a0 a2 _not_in_hitbox
	blt t0 a0 _not_in_hitbox
	blt a1 a3 _not_in_hitbox
	blt t1 a1 _not_in_hitbox

	li v0 1
	b _finish_check_if_bullet_in_hitbox

	_not_in_hitbox:
	li v0 0
	_finish_check_if_bullet_in_hitbox:
leave

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
	li s2, PLAYER_X_UBOUND # rightmost x pos of heart
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
	li a0 PLAYER_X_LBOUND
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
	li s2, 0
	_draw_enemies_row_main_loop:
		bge s0  ENEMY_PER_ROW _finish_draw_enemies_row
	_draw_enemies_row_loop:
		li, s1, 0
		_draw_enemies_col_main_loop:
			bge s1 ENEMY_PER_COL _finish_draw_enemies_col_loop
		_draw_enemies_col_loop:
			lb t0 enemy_active(s2)
			beq t0 0 _enemy_is_dead_dont_draw

			lw a0 enemy_x
			lw a1 enemy_y

			mul t0 s0, ENEMY_ROW_SPACING

			mul t1 s1 ENEMY_COL_SPACING

			add a0 a0 t0
			add a1 a1 t1

			la a2 enemy_image
			jal display_blit_5x5
			_enemy_is_dead_dont_draw:
			inc s1
			inc s2

			b _draw_enemies_col_main_loop
		_finish_draw_enemies_col_loop:
		inc s0
		b _draw_enemies_row_main_loop
	_finish_draw_enemies_row:
leave s0 s1 s2 s3

move_enemies:
enter
	# Welcome to probably the most complicated function of the project
	# Not really that complicated though, it only is long because its assembly

	# Basically, first checks if should move based on frame frame_counter
	# Then does some calculation to find where rightmost edge of the enemies
	# currently is.
	# If moving right && touching right bound, it moves down
	# IF moving left && touching left bound, it moves down
	# Otherwise, it moves in the same direction
	# If it moves down, then it moves down and it switches the direction


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
