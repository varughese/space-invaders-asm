.data
enemy_x:	.word 4
enemy_y:	.word 5
enemy_active: 	.byte 1:ENEMY_COUNT
# The enemys are counted top to bottom, left to right, for ex:
# 0  4  8   12  16
# 1  5  9   13  17
# 2  6  10  14  18
# 3  7  11  15  19


enemy_kill_count: .word 0
