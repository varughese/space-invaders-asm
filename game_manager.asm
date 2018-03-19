# MAV120
# Mathew Varughese

.data
round_no: .word 1
last_round_screen_frame: .word 0
score: .word 0

.text
reset_enemies_and_bullets:
enter s0
	li t0 4
	li t1 5
	sw t0 enemy_x
	sw t1 enemy_y

	li t0 30
	li t1 49
	sw t0 player_x
	sw t1 player_y

	li s0 0
	_reset_enemy_loop_main:
		bge s0 ENEMY_COUNT _reset_enemy_loop_finish
	_reset_enemy_loop_body:
		li t0 1
		sb t0 enemy_active(s0)
		inc s0
		b _reset_enemy_loop_main
	_reset_enemy_loop_finish:

	sw zero enemy_kill_count

	li s0 0
	_reset_p_bullet_loop_main:
		bge s0 PLAYER_BULLET_COUNT _reset_p_bullet_loop_finish
	_reset_p_bullet_loop_body:
		li t0 0
		sb t0 bullet_active(s0)
		inc s0
		b _reset_p_bullet_loop_main
	_reset_p_bullet_loop_finish:

	li s0 0
	_reset_e_bullet_loop_main:
		bge s0 ENEMY_BULLET_COUNT _reset_e_bullet_loop_finish
	_reset_e_bullet_loop_body:
		li t0 0
		sb t0 enemy_bullet_active(s0)
		inc s0
		b _reset_e_bullet_loop_main
	_reset_e_bullet_loop_finish:
leave s0

reset_game:
enter s0
	li t0 3
	sw t0 player_lives

	li t0 50
	sw t0 player_bullets_left

	li t0 1
	sw t0 round_no

	sw zero score

	sb zero player_invincible

	li t0 90
	sw t0 ENEMY_SHOT_WAIT_TIME

	li t0 15
	sw t0 ENEMY_MOVEMENT_SPEED

	jal reset_enemies_and_bullets
leave s0

check_if_won:
enter
	lw t0 enemy_kill_count
	blt t0 ENEMY_COUNT _they_didnt_win
	jal update_score
	jal next_round
	_they_didnt_win:
leave

update_score:
enter s0
	lw s0 score

	lw t0 enemy_kill_count
	lw t1 round_no
	mul t0 t0 t1
	add s0 s0 t0

	lw t0 player_bullets_left
	sub t0 t0 20
	ble t0 0 _didnt_get_any_bullet_points
	add s0 s0 t0

	_didnt_get_any_bullet_points:
	sw s0 score
leave s0


next_round:
enter s0
	li t0 1
	sw t0 sequence_no

	lw t1 frame_counter
	add t1 t1 20
	sw t1 last_round_screen_frame

	lw t0 round_no
	inc t0
	sw t0 round_no

	lw s0 player_bullets_left
	jal reset_enemies_and_bullets

	add s0 s0 20
	sw s0 player_bullets_left

	lw s0 CHANCES_POWERUP_SHOWS
	dec s0
	blt s0 2 _skip_powerup_chance_decrease
	sw s0 CHANCES_POWERUP_SHOWS
	_skip_powerup_chance_decrease:
	jal increase_difficulty
leave s0

increase_difficulty:
enter s0
	lw t9 ENEMY_SHOT_WAIT_TIME
	sub t9 t9 20

	bge t9 0 _dont_cap_enemy_shot_wait_time
	li t9 5

	_dont_cap_enemy_shot_wait_time:
	sw t9 ENEMY_SHOT_WAIT_TIME

	lw t9 ENEMY_MOVEMENT_SPEED
	dec t9
	bge t9 3 _dont_cap_enemy_movement_speed
	li t9 3

	_dont_cap_enemy_movement_speed:
	sw t9 ENEMY_MOVEMENT_SPEED
leave s0
