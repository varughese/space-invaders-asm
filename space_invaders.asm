# MAV120
# Mathew Varughese

# Jarret's library with helper functions and macros like "print_int" and enter/leave
.include "convenience.asm"
# Jarret's Library to let you display things to screen
.include "display.asm"
# Variables that hold player "sprites", so the byte arrays of pixel colors
.include "sprites.asm"
# Logic related to enemy and player bullet movement
.include "bullets.asm"
# Logic related to player and enemy movement
.include "movement.asm"
# All functions that draw players, enemy, bullets
.include "drawing.asm"
# Logic to deal with collisions and collision detection
.include "collision.asm"
# Player specific variables, and modifications like "invisibility"/powerups
.include "player.asm"
# Enemy specific variables
.include "enemy.asm"
# Has logic to update round, increase difficulty, reset game, etc
.include "game_manager.asm"


.eqv GAME_TICK_MS      16
.eqv FRAMES_TO_SHOW_ROUND_SCREEN 60

.data
# Game is broken down into game "sequences"
# Sequence number determines which "screen" to show
# Sequence 0: Game Start screen
# Sequence 1: Current Round screen
# Sequence 2: Actual game, paused
# Sequence 3: Actual game, in play
# Sequence 4: Game Over

sequence_no:	.word 0
game_paused: .word 0

# don't get rid of these, they're used by wait_for_next_frame.
last_frame_time:  .word 0
frame_counter:    .word 0

.text
# --------------------------------------------------------------------------------------------------

.globl main
main:
	# set up anything you need to here,
	# and wait for the user to press a key to start.

_main_loop:
	jal play_current_sequence

	# Next frame
	jal display_update_and_clear
	jal	wait_for_next_frame
	b	_main_loop

game_over:
enter
	jal update_score
	li t0 4
	sw t0 sequence_no
leave

# --------------------------------------------------------------------------------------------------
# call once per main loop to keep the game running at 60FPS.
# if your code is too slow (longer than 16ms per frame), the framerate will drop.
# otherwise, this will account for different lengths of processing per frame.

wait_for_next_frame:
enter	s0
	lw	s0, last_frame_time
	_wait_next_frame_loop:
	# while (sys_time() - last_frame_time) < GAME_TICK_MS {}
	li	v0, 30
	syscall # why does this return a value in a0 instead of v0????????????
	sub	t1, a0, s0
	bltu	t1, GAME_TICK_MS, _wait_next_frame_loop

	# save the time
	sw	a0, last_frame_time

	# frame_counter++
	lw	t0, frame_counter
	inc	t0
	sw	t0, frame_counter
leave	s0

# --------------------------------------------------------------------------------------------------

# .....and here's where all the rest of your code goes :D

play_current_sequence:
enter s0
	lw s0 sequence_no
	bgt s0 0 _after_start_screen
		jal show_start_screen
		b _finish_play_current_sequence

	_after_start_screen:
	bgt s0 1 _after_round_screen
		jal show_current_round_screen
		b _finish_play_current_sequence

	_after_round_screen:
	bgt s0 3 _go_to_game_over_screen
		# 2 pauses game, 3 is regular game
		jal regular_game_functions
		bge s0 3 _finish_play_current_sequence
		# if puased, check for check input to unpause
		jal input_get_keys
		beq v0 0 _finish_play_current_sequence
		li s0 3
		sw s0 sequence_no
		b _finish_play_current_sequence

	_go_to_game_over_screen:
		jal show_game_over_screen

	_finish_play_current_sequence:
leave s0

show_start_screen:
enter
	jal draw_start_screen
	jal input_get_keys
	and t0, v0, KEY_B # t0 = keys & KEY_B

	bne t0, KEY_B, _do_not_update_seq_no_to_1
	lw t0 sequence_no
	inc t0
	sw t0 sequence_no

	lw t1 frame_counter
	sw t1 last_round_screen_frame

	_do_not_update_seq_no_to_1:
leave

show_current_round_screen:
enter s0
	lw t0 frame_counter
	lw t1 last_round_screen_frame
	sub t0 t0 t1
	move s0 t0

	jal draw_round_screen
	ble s0 FRAMES_TO_SHOW_ROUND_SCREEN _do_not_update_seq_no_to_2

	lw t0 sequence_no
	inc t0
	sw t0 sequence_no

	_do_not_update_seq_no_to_2:
leave s0

show_game_over_screen:
enter
	jal draw_game_over_screen
	jal input_get_keys
	and t0, v0, KEY_U # t0 = keys & KEY_U

	bne t0, KEY_U, _do_not_restart_game
	li t0 0
	sw t0 sequence_no
	jal reset_game
	_do_not_restart_game:
leave

regular_game_functions:
enter
	# Check for user input,
	jal move_player
	jal check_if_firing

	lw t0 sequence_no
	beq t0 2 _skip_to_paused_mode

	# Move bullets and enemies
	jal move_player_bullets
	jal move_enemy_bullets
	jal move_enemies

	# Fire enemy bullet
	jal check_if_enemy_firing

	# Check if player is invincble or has other powerups
	jal check_player_modifications

	_skip_to_paused_mode:

	# Draw everything,
	jal draw_player
	jal draw_player_lives
	jal draw_bullets_lefts
	jal draw_player_bullets
	jal draw_enemies
	jal draw_enemy_bullets

	# update round if they won
	jal check_if_won
leave
