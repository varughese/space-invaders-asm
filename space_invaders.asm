# MAV120
# Mathew Varughese

# Helper functions and macros like "print_int" and enter/leave
.include "convenience.asm"

# Library to display things to screen
.include "display.asm"
# Variables that hold player "sprites"
.include "images.asm"
# Logic related to enemy and player bullet movement
.include "bullets.asm"
# Logic related to player and enemy movement
.include "movement.asm"
# All functions that draw player, enemy, bullets
.include "drawing.asm"
# Logic to deal with collisions and collision detection
.include "collision.asm"
# Player specific variables, and modifications like "invisibility"/powerups
.include "player.asm"
# Enemy specific variables
.include "enemy.asm"


.eqv GAME_TICK_MS      16


.data
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
	# check for input,
	jal move_player
	jal check_if_firing

	# move bullets
	jal move_player_bullets
	jal move_enemy_bullets
	jal move_enemies

	jal check_if_enemy_firing
	jal check_player_modifications

	# draw everything,
	jal draw_player
	jal draw_player_lives
	jal draw_bullets_lefts
	jal draw_player_bullets
	jal draw_enemies
	jal draw_enemy_bullets

	# restart frame
	jal display_update_and_clear
	jal	wait_for_next_frame
	b	_main_loop

_game_over:
	exit

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
