Mathew Varughese
MAV120

- Made new files that contain different parts of the game
- Each is explained in the top of the "space_invaders.asm" file

Basic overview of how game works:
There is a `sequence_no` variable. Each number corresponds to a different game screen.

- Sequence 0: Game Start screen
- Sequence 1: Current Round screen
- Sequence 2: Actual game, paused
- Sequence 3: Actual game, in play
- Sequence 4: Game Over

In the main loop, a function is called to show the current sequence. This function basically
looks at that variable and determines what things to draw based on this.

The `regular_game_functions` function contains all of the calls for the gameplay (update player,
update enemies, move bullets, draw things, etc).

There is one way for a player to advance to the next round
- Kill all enemies

There are two ways for a player to die and go to the game over screen:
- Lose all lives
- Run out of bullets

# EXTRA CREDIT I DID:
- [2] Game intro and game over screens.

- [4] Difficulty scaling.
After winning each round, the enemy's shoot faster and move faster based on round number.
However, chance of power-ups is increased. Each round you get 10 more bullets.

A score is also determined based on enemies killed, bullets left, and lives left.
- Each enemy killed is worth the round number they were killed on. So if you beat Round 2, you have at least
60 points (20 for enemies killed in Round 1, 40 for Round 2).
- Each bullet left after 20 for each round is a point

- [?] Visual polish.
Made the intro screen and game over screen look kinda nice, but did not add many animations.
A ship explosion animation is included.
Not sure how much this counts for.

- [?] Powerups.
-- extra life powerup
-- extra ammo powerup
-- temp invincible powerup
