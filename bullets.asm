.eqv MAX_BULLETS 10
# The time in frames between shots
.eqv PLAYER_SHOT_WAIT_TIME 10 # in frames
# The number of pixels the bullet moves a frame
.eqv BULLET_MOVEMENT_SPEED 1

.text

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

		lbu a0 bullet_x(s0)
		move a1 t1
		move a3 s0
		jal check_if_bullet_hit_enemy

		b _do_not_delete_bullet

		_delete_bullet:
		sb zero bullet_active(s0)

		_do_not_delete_bullet:
		inc s0
		b _main_loop_movebullets


	_end_movebullets:
leave s0

####### END BULLETS
