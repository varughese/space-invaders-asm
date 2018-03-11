.data
# PLAYER
player_x: .word 30
player_y: .word 49
player_lives: .word 3
player_bullets_left: .word 50
player_bullet_last_fired: .word 0
player_invincible_last_frame: .word 0
player_invincible: .byte 0

.text
.eqv INVCINCIBILITY_DURATION 70
check_player_modifications:
enter
	lbu t0 player_invincible
	beq t0 0 _check_player_mods_not_invincible
	jal check_player_invincibility
	_check_player_mods_not_invincible:
leave

check_player_invincibility:
enter
	lw t0 player_invincible_last_frame
	lw t1 frame_counter
	sub t0 t1 t0
	blt t0 INVCINCIBILITY_DURATION _finish_check_player_invincibility
	sb zero player_invincible

	_finish_check_player_invincibility:
leave
