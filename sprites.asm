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

powerup_extra_bullets_sprite: .byte
	0	0	0	0	0
	0	2	2	2	0
	0	2	7	2	0
	0	2	2	2	0
	0	0	0	0	0

powerup_extra_life_sprite: .byte
	0	0	0	0	0
	0	1	7	1	0
	0	1	1	1	0
	0	7	1	7	0
	0	0	0	0	0

powerup_invincibility_sprite: .byte
	0	0	0	0	0
	0	6	6	6	0
	0	4	6	4	0
	0	6	4	6	0
	0	0	0	0	0

powerup_freeze_sprite: .byte
	0	0	0	0	0
	0	5	5	5	0
	0	5	7	5	0
	0	5	5	5	0
	0	0	0	0	0
