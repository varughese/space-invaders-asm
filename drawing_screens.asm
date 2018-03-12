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

	li a0 44
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
