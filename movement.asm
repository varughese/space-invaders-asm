# MAV120
# Mathew Varughese

# 2 ≤ X ≤ 57
# 46 ≤ Y ≤ 52
.eqv PLAYER_X_LBOUND	2
.eqv PLAYER_X_UBOUND	57
.eqv PLAYER_Y_LBOUND	46
.eqv PLAYER_Y_UBOUND	52

# .eqv ENEMY_MOVEMENT_SPEED 15 # in frames

.data
ENEMY_MOVEMENT_SPEED: .word 15
enemy_direction: .word 1
enemy_last_moved: .word 0

.text
###### PLAYER MOVEMENT
move_player:
enter
	jal input_get_keys

	and t0, v0, KEY_L # t0 = keys & KEY_L
	and t1, v0, KEY_R # t1 = keys & KEY_R
	and t2, v0, KEY_U # t2 = keys & KEY_U
	and t3, v0, KEY_D # t3 = keys & KEY_D

	_check_key_l_pressed:
	bne t0, KEY_L, _check_key_r_pressed
	jal move_player_left
	_check_key_r_pressed:
	bne t1, KEY_R, _check_key_u_pressed
	jal move_player_right
	_check_key_u_pressed:
	bne t2, KEY_U, _check_key_d_pressed
	jal move_player_up
	_check_key_d_pressed:
	bne t3, KEY_D, _finish_check_move_player
	jal move_player_down

	_finish_check_move_player:

	jal check_player_in_bounds
leave

move_player_left:
enter
	lw t0, player_x
	dec t0
	sw t0, player_x
leave

move_player_right:
enter
	lw t0, player_x
	inc t0
	sw t0, player_x
leave

move_player_down:
enter
	lw t0, player_y
	inc t0
	sw t0, player_y
leave

move_player_up:
enter
	lw t0, player_y
	dec t0
	sw t0, player_y
leave

check_player_in_bounds:
enter
	lw t0, player_x
	lw t1, player_y

	li t2, PLAYER_X_LBOUND
	li t3, PLAYER_X_UBOUND
	li t4, PLAYER_Y_LBOUND
	li t5, PLAYER_Y_UBOUND

	_check_x_l_bound:
	bgt t0, PLAYER_X_LBOUND, _check_x_u_bound
	sw t2, player_x
	b _check_y_l_bound
	_check_x_u_bound:
	# add t0, t0, 5
	blt t0 PLAYER_X_UBOUND _check_y_l_bound
	sw t3, player_x

	_check_y_l_bound:
	# add t2, t1, 5
	bgt t1, PLAYER_Y_LBOUND, _check_y_u_bound
	sw t4, player_y
	b _finish
	_check_y_u_bound:
	blt t1, PLAYER_Y_UBOUND, _finish
	sw t5, player_y

	_finish:
leave

############## END PLAYER MOVEMENT

move_enemies:
enter
	# Welcome to probably the most complicated function of the project
	# Not really that complicated though, it only is long because its assembly

	# Basically, first checks if should move based on frame frame_counter
	# Then does some calculation to find where rightmost edge of the enemies
	# currently is.
	# If moving right && touching right bound, it moves down
	# IF moving left && touching left bound, it moves down
	# Otherwise, it moves in the same direction
	# If it moves down, then it moves down and it switches the direction


	# check frames since last moved
	lw t3 enemy_last_moved
	lw t4 frame_counter
	sub t3 t4 t3 # t3 : time since last moved

	lw t9 ENEMY_MOVEMENT_SPEED
	blt t3 t9, _dont_move_enemies
	sw t4 enemy_last_moved


	lw t0 enemy_x
	# Determine if we must change the direction of the fleet:

	# Rightmost ship's x coordinate will be at
	# enemy_x + 5 + ENEMY_COL_SPACING(ENEMY_PER_ROW-1)
	# but, have to minus 5 pixels to account for the fact that
	# they will be displayed 5 pixels more, because display_blit_5x5
	# draws top left
	li t1 ENEMY_PER_ROW
	dec t1
	mul t1 t1 ENEMY_COL_SPACING
	add t1 t1 t0
	lw t2 enemy_direction
	# t1 has the x coordinate of rightmost ship
	# if the ship should change direction, it moves down first and
	# then goes the other way

	bne t2 1 _check_if_enemy_touching_left_side
	bgt t1 PLAYER_X_UBOUND, _move_e_down
	_check_if_enemy_touching_left_side:
	bne t2 -1 _skip_enemy_side_check
	blt t0 PLAYER_X_LBOUND, _move_e_down

	_skip_enemy_side_check:
	# determine the direction to go
	# -1 left, 1 right

	beq t2, 1, _move_e_right
	_move_e_left:
	dec t0
	b _finish_move_e

	_move_e_right:
	inc t0

	_finish_move_e:
	sw t0 enemy_x
	b _dont_move_enemies

	_move_e_down:
	# have to calculate the lower most thing, and only move down
	# if its bounds

	# ENEMY_Y + 5 + ENEMY_ROW_SPACING(ENEMY_PER_COL-1)
	# is bottom ship row's pixel

	lw t0 enemy_y
	li t1, ENEMY_PER_ROW
	dec t1
	mul t1 t1 ENEMY_ROW_SPACING
	add t1, t1, 5
	add t1 t1 t0

	bgt t1 PLAYER_Y_UBOUND _its_not_okay_to_move_enemy_down

	_its_okay_to_move_enemy_down:
	inc t0
	sw t0 enemy_y
	_its_not_okay_to_move_enemy_down:
	mul t2, t2, -1
	sw t2 enemy_direction

	_dont_move_enemies:
leave
