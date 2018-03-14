.data
player_sprite: .byte
	0	0	4	0	0
	0	4	7	4	0
	4	7	7	7	4
	4	4	4	4	4
	4	0	2	0	4

player_life_sprite: .byte
	0	1	0	1	0
	1	1	1	1	1
	1	1	1	1	1
	0	1	1	1	0
	0	0	1	0	0


enemy_sprite: .byte
	1	0	2	0	1
	1	1	1	1	1
	1	2	2	2	1
	0	1	2	1	0
	0	0	1	0	0

enemy_explosion_sprite: .byte
	0	2	0	2	0
	2	0	0	0	2
	0	0	0	0	0
	2	0	0	0	2
	0	2	0	2	0

powerup_extra_bullets: .byte
	0	0	0	0	0
	0	2	2	2	0
	0	2	7	2	0
	0	2	2	2	0
	0	0	0	0	0

powerup_extra_life: .byte
	0	0	0	0	0
	0	1	7	1	0
	0	1	1	1	0
	0	7	1	7	0
	0	0	0	0	0

powerup_invincibility: .byte
	0	0	0	0	0
	0	6	6	6	0
	0	4	6	4	0
	0	6	4	6	0
	0	0	0	0	0

.eqv NUM_OF_POWERUPS 4 # this is actual one more than the actual number, to simplify some code
# An array that holds the addresses of the sprites. Makes some code less complex
powerup_sprite_array: .word 0:NUM_OF_POWERUPS
