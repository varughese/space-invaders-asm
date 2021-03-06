# MAV120
# Mathew Varughese

.data
last_powerup_frame: .word 0
POWER_UP_FRAME_TIMING: .word 60
CHANCES_POWERUP_SHOWS: .word 10 # 1 in a __ chance

powerup_x: .word 0
powerup_y: .word 52

powerup_player_has_equipped: .byte 0
current_powerup_on_screen: .byte 0
# 0: Nothing
# 1: More Ammo
# 2: Extra Life
# 3: Temp Invincible
# 4: Freeze Ships

.eqv NUM_OF_POWERUPS 5 # this is actual one more than the actual number, to simplify some code

# Array that holds the addresses of the sprites. Makes code less complex.
powerup_sprite_array: .word 0:NUM_OF_POWERUPS
# Array that has pointers to functions.
powerup_fn_array: .word 0:NUM_OF_POWERUPS

.text
set_up_powerup_sprite_array:
enter
	la t0 powerup_extra_bullets_sprite
	la t1 powerup_extra_life_sprite
	la t2 powerup_invincibility_sprite
	la t3 powerup_freeze_sprite

	li t9 4
	sw t0 powerup_sprite_array(t9)
	li t9 8
	sw t1 powerup_sprite_array(t9)
	li t9 12
	sw t2 powerup_sprite_array(t9)
	li t9 16
	sw t3 powerup_sprite_array(t9)
leave

set_up_powerup_fn_array:
enter
	la t0 add_bullets_powerup
	la t1 add_extra_life_powerup
	la t2 add_invincibility_powerup
	la t3 add_freeze_powerup

	li t9 4
	sw t0 powerup_fn_array(t9)
	li t9 8
	sw t1 powerup_fn_array(t9)
	li t9 12
	sw t2 powerup_fn_array(t9)
	li t9 16
	sw t3 powerup_fn_array(t9)
leave

check_to_add_powerup:
enter s0
	# Every POWER_UP_FRAME_TIMING frames, a power up has a 1 in
	# CHANCES_POWERUP_SHOWS chance to show up.
	lbu t1 current_powerup_on_screen
	bne t1 0 _finish_check_to_add_power_up

	# the following determines difference between last powerup
	# or since start of game
	lw t0 last_powerup_frame
	lw t1 frame_counter
	beq t0 0 _load_game_start_frame_instead
	b _finish_loading_frame_counter
	_load_game_start_frame_instead:
	lw t0 game_start_frame
	_finish_loading_frame_counter:
	sub t0 t1 t0
	# t0 = frames since last power up

	lw t9 POWER_UP_FRAME_TIMING
	blt t0 t9 _finish_check_to_add_power_up
	sw t1 last_powerup_frame

	# a0 = random [0,CHANCES_POWERUP_SHOWS-1]
	li v0 sys_randRange
	lw a1 CHANCES_POWERUP_SHOWS
	syscall

	bne a0 0 _finish_check_to_add_power_up

	jal add_powerup

	lw t1 frame_counter
	sw t1 last_powerup_frame

	_finish_check_to_add_power_up:
leave s0

add_powerup:
enter
	li v0 sys_randRange
	li a1 NUM_OF_POWERUPS
	syscall
	sb a0 current_powerup_on_screen

	# a0 = 1 # uncomment this line to force a certain powerup

	lw t0 player_y
	sw t0 powerup_y

	lw t0 player_x
	bge t0 32 _place_power_up_on_left

	_place_power_up_on_right:
	li t0 51
	b _set_powerup_position
	_place_power_up_on_left:
	li t0 8
	_set_powerup_position:
	sw t0 powerup_x
leave

check_if_touching_powerup:
enter
	lw a0 powerup_x
	add a0 a0 3
	lw a1 powerup_y
	add a1 a1 3
	lw a2 player_x
	lw a3 player_y


	li v0 0
	jal check_if_inside_hitbox
	beq v0 0 _not_touching_powerup

	lbu t0 current_powerup_on_screen
	sb t0 powerup_player_has_equipped

	sb zero current_powerup_on_screen

	lw t0 frame_counter
	sw t0 last_powerup_frame

	_not_touching_powerup:
leave
