.data
intro_message_1: .asciiz "SPACE"
intro_message_2: .asciiz "INVADERS"

intro_message_3: .asciiz "Press B"

round_message: .asciiz "Round"

game_message: .asciiz "Game"
over_message: .asciiz "Over"
press_u_message: .asciiz "Press Up"
to_restart_message: .asciiz "Restart?"
score_message: .asciiz "Score:"

.text

draw_player:
enter
	lw a0, player_x
	lw a1, player_y
	la a2, player_image

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
		la a2 player_life_image
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
enter s0 s1 s2 s3
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
			lb t0 enemy_active(s2)
			beq t0 0 _enemy_is_dead_dont_draw

			lw a0 enemy_x
			lw a1 enemy_y

			mul t0 s0, ENEMY_COL_SPACING
			mul t1 s1 ENEMY_ROW_SPACING

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


draw_start_screen:
enter s0 s1
	li	a0, 8
	li	a1, 20
	la	a2, intro_message_1
	jal	display_draw_text

	li	a0, 9
	li	a1, 27
	la	a2, intro_message_2
	jal	display_draw_text

	li t7 0

	lw t0 frame_counter
	and t0 t0 16
	beq t0 0 _skip_write_press_b

	li	a0, 8
	li	a1, 39
	la	a2, intro_message_3
	jal	display_draw_text

	li t7 1

	_skip_write_press_b:

	_draw_start_screen_loop_top:
	bge s0 ENEMY_PER_ROW, _draw_start_screen_loop_finish
	_draw_start_screen_loop_body:
		li a0 10
		mul t0 s0 ENEMY_COL_SPACING
		add a0 a0 t0
		li a1 5
		add a1 a1 t7
		la a2 enemy_image
		jal display_blit_5x5

		li a1 54
		la a2 player_image
		jal display_blit_5x5

		inc s0
		b _draw_start_screen_loop_top
	_draw_start_screen_loop_finish:

leave s0 s1

draw_round_screen:
enter
	li	a0, 10
	li	a1, 30
	la	a2, round_message
	jal	display_draw_text

	li a0 40
	li a1 30
	lw a2 round_no
	jal display_draw_int
leave

draw_game_over_screen:
enter s0, s1
	li a0 6 # left-margin val
	li a1 8
	la a2, score_message
	jal	display_draw_text

	li a0 42
	li a1 8
	lw a2 score
	jal display_draw_int

	li a0 6 # left-margin val
	li a1 22
	la a2, game_message
	jal	display_draw_text

	li s0 0
	_draw_game_over_screen_loop_main:
		bge s0 3 _draw_game_over_screen_loop_finish
	_draw_game_over_screen_loop_body:
		li a0 34
		li a1 22
		mul t0 s0 7
		add a0 a0 t0
		move s1 a0
		la a2 enemy_image
		jal display_blit_5x5

		move a0 s1
		li a1 29
		jal display_blit_5x5

		inc s0
		b _draw_game_over_screen_loop_main
	_draw_game_over_screen_loop_finish:

	lw t0 frame_counter
	and t0 t0 16
	beq t0 0 _skip_write_game_over

	li a0 6 # left-margin val
	li a1 29
	la a2, over_message
	jal	display_draw_text

	_skip_write_game_over:

	li a0 6 # left-margin val
	li a1 44
	la a2, to_restart_message
	jal display_draw_text

	li a0 6 # left-margin val
	li a1 50
	la a2, press_u_message
	jal display_draw_text

leave s0, s1
