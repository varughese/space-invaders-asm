# Mathew Varughese
# MAV120
# Space Invaders

- Everything works. The extra credit I did is at the bottom.

- I made new asm files that contain different parts of the game, so I didn't just have one super long file
- Each is `included` and explained in the top of the `space_invaders.asm` file

There is a start screen. You press B to start. There are rounds. Game starts when you click a key.
When you defeat all the enemies, you go to the next round.

## Overview of How Game Works
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

## EXTRA CREDIT I DID:
- [2] Game intro and game over screens.

- [4] Difficulty scaling.
After winning each round, the enemies shoot faster and move faster.
Chance of power-ups is increased. And each round you get 20 more bullets.

A score is also determined based on round number, enemies killed, and bullets left
- Each enemy killed is worth the round number they were killed on. So if you beat Round 2, you have at least
60 points (20 for enemies killed in Round 1, 40 for Round 2).
- Each bullet left after 20 for each round is a point

- [?] Visual polish.
Made the intro screen and game over screen look kinda nice. A ship explosion animation is included.
Powerups have different sprites. Not sure how much this counts for.

- [8] Powerups.
Powerups have a random chance of showing up. In the `powerups.asm` file, `POWER_UP_FRAME_TIMING`
and `CHANCES_POWERUP_SHOWS` determine these chances. Every `POWER_UP_FRAME_TIMING` frames, there is a
1 in `CHANCES_POWERUP_SHOWS` chance that a powerup shows. The powerup pops up on the side opposite
of the player.

To test them out, you can go to `powerups.asm` file, and change the `CHANCES_POWERUP_SHOWS` variable
to 1. This will make a powerup show every second. In the same file, in the `add_powerup` function,
you can force a powerup to always show by setting `a0` to the powerup you want.

Here is a list of the powerups, and a description.

- 1. More Ammo
-- Yellow
-- 30 More bullets

- 2. Extra Life
-- Red
-- Adds a life

- 3. Temp Invincible
-- Purple/Green
-- You become invincible, for twice as long as you would if you lost a life

- 4. Freeze Ships
-- Blue
-- The ships freeze and do not move
