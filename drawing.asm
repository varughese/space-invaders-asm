# MAV120
# Mathew Varughese

.data
intro_message_1: .asciiz "SPACE"
intro_message_2: .asciiz "INVADERS"

intro_message_3: .asciiz "Press B!"

round_message: .asciiz "Round"

game_message: .asciiz "Game"
over_message: .asciiz "Over"
press_u_message: .asciiz "Press Up"
to_restart_message: .asciiz "Restart?"
score_message: .asciiz "Score:"

# this holds frame info that is used for animation
enemy_frame_counter: 	.word 0:ENEMY_COUNT
.text

draw_player:
enter
	lw a0, player_x
	lw a1, player_y
	la a2, player_sprite

	lbu t0 player_invincible
	beq t0 0 _draw_player
	# player's invincble
	lw t0 player_invincible_last_frame
	# trick to make player flash every 4 frames
	# when invincble
	lw t1 frame_counter
	sub t0 t1 t0
	and t0 t0 4
	beq t0 0 _draw_player_finish
	_draw_player:
	jal display_blit_5x5
	_draw_player_finish:
leave

draw_player_lives:
enter s0, s1, s2, s3
	lw s0, player_lives
	li s1, 0 # incrementer, i=0
	li s2, PLAYER_X_UBOUND # rightmost x pos of heart
	li s3, 58 # y pos of heart
	_draw_lives_loop_top:
		bge s1 s0 _finish_draw_lives_loop
	_draw_lives_loop:
		mul t0, s1, 7
		sub t0, s2, t0

		move a0, t0
		move a1, s3
		la a2 player_life_sprite
		jal display_blit_5x5

		# i++
		inc s1
		b _draw_lives_loop_top
	_finish_draw_lives_loop:
leave s0, s1, s2, s3

draw_bullets_lefts:
enter
	li a0 PLAYER_X_LBOUND
	li a1 58
	lw a2 player_bullets_left
	jal display_draw_int
leave

draw_powerup:
enter
	lb t0 current_powerup_on_screen
	beq t0 0 _finish_draw_powerup

	lw a0 powerup_x
	lw a1 powerup_y

	# basically made an array of pointers to avoid
	# a long chain of branches

	mul t0 t0 4
	lw a2 powerup_sprite_array(t0)

	jal display_blit_5x5
	_finish_draw_powerup:
leave

draw_player_bullets:
enter
	li a0 PLAYER_BULLET_COUNT
	la a1 bullet_active
	la a2 bullet_x
	la a3 bullet_y
	jal draw_bullets_helper
leave

draw_enemy_bullets:
enter
	li a0 ENEMY_BULLET_COUNT
	la a1 enemy_bullet_active
	la a2 enemy_bullet_x
	la a3 enemy_bullet_y
	jal draw_bullets_helper
leave


draw_bullets_helper:
enter s0, s1, s2, s3, s4
	# a0 Array Length
	# a1 Bullet Active array
	# a2 Bullet X array
	# a3 Bullet Y array
	li s0, 0
	move s4 a0
	move s1 a1
	move s2 a2
	move s3 a3
	_draw_bullets_main_loop:
		bge s0 s4 _finish_draw_bullets_loop
	_draw_bullets_loop:
		# s1 has bullet_active
		# bullet_active[s0]
		add t0 s1 s0
		lbu t0, (t0)
		beq t0 0, _skip_draw_bullet

		# s2 has bullet_x
		add a0 s2, s0
		# s3 has bullet_y
		add a1 s3, s0

		lbu	a0, (a0)
		lbu	a1, (a1)
		li	a2, COLOR_WHITE
		jal	display_set_pixel

		_skip_draw_bullet:
		inc s0
		b _draw_bullets_main_loop
	_finish_draw_bullets_loop:
leave s0, s1, s2, s3, s4

draw_enemies:
enter s0, s1, s2, s3, s4, s5
	li s0, 0
	li s2, 0
	# draws top to bottom, left to right
	_draw_enemies_row_main_loop:
		bge s0  ENEMY_PER_ROW _finish_draw_enemies_row
	_draw_enemies_row_loop:
		li, s1, 0
		_draw_enemies_col_main_loop:
			bge s1 ENEMY_PER_COL _finish_draw_enemies_col_loop
		_draw_enemies_col_loop:
			lb t9 enemy_active(s2)
			beq t9 0 _enemy_is_dead_dont_draw

			lw a0 enemy_x
			lw a1 enemy_y

			mul t0 s0, ENEMY_COL_SPACING
			mul t1 s1 ENEMY_ROW_SPACING

			add a0 a0 t0
			add a1 a1 t1

			la a2 enemy_sprite
			beq t9 1 _dont_draw_explosion_sprite
				move s4 a0
				move s5 a1
				move a0 s0
				move a1 s1
				jal handle_enemy_explosion_animation
				move a0 s4
				move a1 s5
				la a2 enemy_explosion_sprite
			_dont_draw_explosion_sprite:
			jal display_blit_5x5
			_enemy_is_dead_dont_draw:
			inc s1
			inc s2

			b _draw_enemies_col_main_loop
		_finish_draw_enemies_col_loop:
		inc s0
		b _draw_enemies_row_main_loop
	_finish_draw_enemies_row:
leave s0, s1, s2, s3, s4, s5

handle_enemy_explosion_animation:
enter s0
	# a0 : current row
	# a1 : current col
	mul t0 a0 ENEMY_PER_COL
	add t0 t0 a1
	# s0 index in flat array (enemy_index = ENEMY_PER_COL*col + row)
	move s0 t0
	mul t0 s0 4 # get the actual array index

	lw t1 enemy_frame_counter(t0)
	lw t2 frame_counter
	beq t1 0 _current_frame_is_zero

	sub t3 t2 t1
	lw t9 ENEMY_MOVEMENT_SPEED
	ble t3 t9 _finish_handle_enemy_explosion_animation
	# waited the number of frames
	sw zero enemy_frame_counter(t0)
	sb zero enemy_active(s0)

	b _finish_handle_enemy_explosion_animation
	_current_frame_is_zero:
	sw t2 enemy_frame_counter(t0)

	_finish_handle_enemy_explosion_animation:
leave s0

TEST_FN_draw_active_enemies:
enter s0
	li s0, 0
	_draw_active_enemy_loop_top:
	bge s0 ENEMY_COUNT _draw_active_enemy_loop_finish
	_draw_active_enemy_loop_body:
	lbu t0 enemy_active(s0)
	beq t0 0 _draw_active_enemy_loop_body_skip
	move a0 s0
	mul a0 a0 2
	li a1 1
	li a2 COLOR_WHITE
	jal display_set_pixel
	_draw_active_enemy_loop_body_skip:
	inc s0
	b _draw_active_enemy_loop_top
	_draw_active_enemy_loop_finish:
leave s0

### SCREEN DRAWING
.include "drawing_screens.asm"
