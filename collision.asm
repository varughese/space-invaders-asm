.data

.text

check_if_bullet_hit_enemy:
enter s0, s1, s2, s3
# a0: bullet x
# a1: bullet y
# a3: bullet pos
# kills enemy

	li s0, 0
	li s1, 0
	li s2, 0
	move s3, a3
	_checkbullet_hit_enemies_row_main_loop:
		bge s0  ENEMY_PER_ROW _finish_checkbullet_hit_enemies_row
	_checkbullet_hit_enemies_row_loop:
		li, s1, 0
		_checkbullet_hit_enemies_col_main_loop:
			bge s1 ENEMY_PER_COL _finish_checkbullet_hit_enemies_col_loop
		_checkbullet_hit_enemies_col_loop:
			lb t0 enemy_active(s2)
			bne t0 1 _do_not_kill_enemy_and_bullet

			lw a2 enemy_x
			lw a3 enemy_y

			mul t0 s0, ENEMY_COL_SPACING
			mul t1 s1 ENEMY_ROW_SPACING

			add a2 a2 t0
			add a3 a3 t1

			li v0 0
			jal check_if_inside_hitbox
			beq v0 0 _do_not_kill_enemy_and_bullet

			# bullet hit enemy
			li t9 2 # 2 is explosion sprite
			sb t9 enemy_active(s2)
			sb zero bullet_active(s3)
			lw t0 enemy_kill_count
			inc t0
			sw t0 enemy_kill_count

			_do_not_kill_enemy_and_bullet:
			inc s1
			inc s2

			b _checkbullet_hit_enemies_col_main_loop
		_finish_checkbullet_hit_enemies_col_loop:
		inc s0
		b _checkbullet_hit_enemies_row_main_loop
	_finish_checkbullet_hit_enemies_row:
leave s0, s1, s2, s3

check_if_enemy_bullet_hit_player:
enter s0
	# a0 bullet_x
	# a1 bullet_y
	# a2 bullet_pos
	move s0 a2
	lw a2 player_x
	lw a3 player_y
	jal check_if_inside_hitbox
	beq v0 0 finish_check_if_enemy_bullet_hit_player
	sb zero enemy_bullet_active(s0)
	jal player_has_been_hit
	finish_check_if_enemy_bullet_hit_player:
leave s0

check_if_inside_hitbox:
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
	b _finish_check_if_inside_hitbox

	_not_in_hitbox:
	li v0 0
	_finish_check_if_inside_hitbox:
leave

player_has_been_hit:
enter
	# check if is invincble
	lb t0 player_invincible
	beq t0 1 _finish_player_has_been_hit

	# not invincible:
	# Player loses life
	lw t0 player_lives
	dec t0
	sw t0 player_lives
	## If no lives left, game over
	bge t0 0 _turn_player_invincible
	jal game_over
	_turn_player_invincible:
	lw t0 frame_counter
	sw t0 player_invincible_last_frame
	li t0 1
	sb t0 player_invincible

	_finish_player_has_been_hit:
leave
