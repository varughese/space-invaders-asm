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
.eqv INVCINCIBILITY_DURATION 120
check_player_modifications:
enter
	# modifications is the same as powerups pretty much
	# invincibility can happen cuz player got hit, or because
	# they got a powerup
	lbu t0 player_invincible
	beq t0 0 _check_player_mods_not_invincible
	jal check_player_invincibility
	_check_player_mods_not_invincible:

	lbu t0 powerup_player_has_equipped
	beq t0 0 _finish_checking_modifications
	bgt t0 1 _powerup_not_bullets
		jal add_bullets_powerup
		b _finish_checking_modifications
	_powerup_not_bullets:
	bgt t0 2 _powerup_not_extra_life
		jal add_extra_life_powerup
		b _finish_checking_modifications
	_powerup_not_extra_life:
	bgt t0 3 _powerup_not_invincibility
		jal add_invincibility_powerup
		b _finish_checking_modifications

	_powerup_not_invincibility:
	_finish_checking_modifications:
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

add_bullets_powerup:
enter
	lw t0 player_bullets_left
	add t0 t0 30
	sw t0 player_bullets_left

	sb zero powerup_player_has_equipped
leave

add_extra_life_powerup:
enter
	lw t0 player_lives
	inc t0
	sw t0 player_lives

	sb zero powerup_player_has_equipped
leave

add_invincibility_powerup:
enter
	# invcibility powerup lasts twice as long as
	# regular
	li t0 1
	sb t0 player_invincible
	lw t0 frame_counter
	add t0 t0 INVCINCIBILITY_DURATION
	sw t0 player_invincible_last_frame
leave
