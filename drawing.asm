
.text

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

draw_player_bullets:
enter
	li a0 MAX_BULLETS
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

TEST_FN_draw_active_enemy:
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
