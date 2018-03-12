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
	0	3	7	3	0
	0	7	7	7	0
	0	3	7	3	0
	0	0	0	0	0
