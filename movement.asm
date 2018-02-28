# 2 ≤ X ≤ 57
# 46 ≤ Y ≤ 52
.eqv PLAYER_X_LBOUND	2
.eqv PLAYER_X_UBOUND	57
.eqv PLAYER_Y_LBOUND	46
.eqv PLAYER_Y_UBOUND	52

.text
###### MOVEMENT
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

############## END MOVEMENT
