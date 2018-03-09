.eqv MAX_BULLETS 10
# The time in frames between shots
.eqv PLAYER_SHOT_WAIT_TIME 10 # in frames
# The number of pixels the bullet moves a frame
.eqv BULLET_MOVEMENT_SPEED 1

.eqv ENEMY_BULLET_COUNT 5
.eqv ENEMY_SHOT_WAIT_TIME 6

.eqv ENEMY_COUNT 20
.eqv ENEMY_PER_ROW 5
.eqv ENEMY_PER_COL 4
.eqv ENEMY_ROW_SPACING 10
.eqv ENEMY_COL_SPACING 7

.data
enemy_last_shot: .word 0

.text
####### ENEMY BULLETS
check_if_enemy_firing:
enter
	# t0 = frames since last enemy shot
	lw t0, enemy_last_shot
	lw t1, frame_counter
	sub t0 t1 t0

	# shoot if frame is below
	blt t0, ENEMY_SHOT_WAIT_TIME, _finish_check_if_enemy_firing
	sw t1, enemy_last_shot

	jal fire_enemy_bullet

	_finish_check_if_enemy_firing:
leave

fire_enemy_bullet:
enter s0
	la a0 enemy_bullet_active
	li a1 ENEMY_BULLET_COUNT
	jal find_active_bullet

	move s0 v0

	bge s0 ENEMY_BULLET_COUNT _end_fire_e_bullet

	lw t0 enemy_kill_count
	li t1 ENEMY_COUNT
	sub t0 t1 t0
	ble t0 1 _end_fire_e_bullet

	jal get_rand_alive_enemy
	# x--;
	# if(x >= 5) {
	# i = x / 5;
	# j = x % 5
	# }

	li t3 0
	move t4 v0

	blt v0 5 _skip_the_division
	div t3 v0 5
	rem t4 v0 5
	_skip_the_division:

	lw t0 enemy_x
	lw t1 enemy_y

	mul t5 t3, ENEMY_ROW_SPACING
	mul t6 t4 ENEMY_COL_SPACING

	add t0 t0 t5
	add t1 t1 t6

	add t0 t0 2
	add t1 t1 5

	sb t0 enemy_bullet_x(s0)
	sb t1 enemy_bullet_y(s0)

	li t0 1
	sb t0, enemy_bullet_active(s0)

	_end_fire_e_bullet:
leave s0

get_rand_alive_enemy:
enter
	# GEN RANDOM NUMBER [0, ENEMY_COUNT]
	_get_rand_alive_enemy_loop_top:
	li v0 sys_randRange
	li a1 ENEMY_COUNT
	dec a1
	syscall
	lbu t0 enemy_active(a0)
	beq t0 0 _get_rand_alive_enemy_loop_top
	_get_rand_alive_enemy_loop_finish:
	move v0 a0
leave



##########

####### PLAYER BULLETS
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
	la a0 bullet_active
	li a1 MAX_BULLETS
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
	# a0 : address of bullet array
	# a1 : bullet array length
	li t0 0
	_main_loop_findactivebullet:
		bgt t0, a1 _end_findactivebullet
	_loop_findactivebullet:
		# bullet_active [i]
		move t1, a0
		add t1, t1, t0
		lbu t2, (t1)

		beq t2, 0, _end_findactivebullet

		inc t0
		b _main_loop_findactivebullet
	_end_findactivebullet:
		move v0, t0
leave

move_enemy_bullets:
enter s0
	li s0 0
	_main_loop_move_e_bullets:
		bge s0, ENEMY_BULLET_COUNT _end_move_e_bullets
	_loop_move_e_bullets:
		lb t0 enemy_bullet_active(s0)

		bne t0 0, _move_bullet_down
		inc s0
		b _main_loop_move_e_bullets

		_move_bullet_down:
		lbu t1 enemy_bullet_y(s0)
		add t1 t1 BULLET_MOVEMENT_SPEED

		bge t1 64 _delete_e_bullet
		sb t1 enemy_bullet_y(s0)

		b _do_not_delete_e_bullet

		_delete_e_bullet:
		sb zero enemy_bullet_active(s0)

		_do_not_delete_e_bullet:
		inc s0
		b _main_loop_move_e_bullets


	_end_move_e_bullets:
leave s0

move_player_bullets:
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
