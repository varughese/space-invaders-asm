# Project 1: Invasion!
## Due Saturday, 3/17 by 11:59 PM
## Due late (-15%) Sunday, 3/18 by 11:59 PM

[space_invaders_asm]: http://pitt.edu/~jfb42/cs0447/projects/space_invaders.asm
[display_asm]:        http://pitt.edu/~jfb42/cs0447/projects/display.asm
[convenience_asm]:    http://pitt.edu/~jfb42/cs0447/projects/convenience.asm
[details]:            https://gist.github.com/JarrettBillingsley/4f2ac78f94e873c685c8a33be2e3bbe9

## [`space_invaders.asm`][space_invaders_asm] (please use this!!!)
## [`display.asm`][display_asm] (for interacting with the LED/Keypad)
## [`convenience.asm`][convenience_asm] (to make your life much easier)

For project 1, you'll be writing a video game in MIPS assembly: [Space Invaders](https://en.wikipedia.org/wiki/Space_Invaders)! If you're not familiar with the game, find an online version of it and play around. It's a pretty simple game.

![](http://pitt.edu/~jfb42/cs0447/projects/invaders_4.gif)

We'll be using a MARS plugin originally developed by José Baiocchi, a previous Pitt CS grad student. It simulates a 64x64 pixel display and a 5-button keypad. I've improved it by adding more colors and greatly increasing the performance to the point that you can draw an entire screen of graphics at 60 FPS. :D

It's available in the [modified version of MARS (version b) I've provided here](http://pitt.edu/~jfb42/cs0447/Mars_2184_b.jar), under **Tools > Keypad and LED Display Simulator** (*NOT* "Keyboard and Display MMIO Simulator", that's something else).

## Brief game description

The player controls the **ship** at the bottom of the screen. You can move the ship left, right, up, and down. The ship is limited in its movement.

The **enemies** are the other ships at the top of the screen. Your goal is to **destroy all the enemies.** (They're, uh, robots without emotions who are bent on destroying humanity.)

The way you do that is by **firing bullets** from your ship. You have a limited number of bullets. If any bullet touches any enemy, they are destroyed and the bullet disappears.

When the game first starts, you have 50 (or so) shots, 3 (or so) lives, and 20 (or so) enemies to destroy.

**The game should not start until the user presses any key.** At that point, the enemies will start to slowly move left, right, and down, and the player will take control of the ship.

Enemies can also fire bullets. If an **enemy bullet** hits your ship, you lose a life and briefly **become invincible.**

There are **three ways** for the game to end:

- If you **lose all your lives**
- If you **run out of bullets**
- If you **destroy all the enemies**

## [Here are the nitty-gritty details of how your game should work.][details]

## Submission details

### There are almost 150 of you. Please make things easier for the grader by following these rules exactly.

The less time they have to spend copying files, asking you for extra things etc. the faster they can grade your projects and get them back to you.

You will submit a ZIP file named `username_proj1.zip` where `username` is your Pitt username. For example, I would name mine `jfb42_proj1.zip`.

**Do not put a folder in the zip file, just the files you are submitting.** When the grader opens the zip file, they should see the following:

- Your `space_invaders.asm` file.
	- *Put your name at the top of the file in comments.*
- The `display.asm` file I provided to you.
	- *It's okay to modify this file, but please mention that in your readme.*
- **Any other files** needed to assemble and run your program, e.g. `convenience.asm`.
	- *Put your name at the top of the file in comments.*
- A **`readme.txt`** file. **DO NOT SUBMIT A README.DOCX. DO NOT SUBMIT A README.PDF. SUBMIT A PLAIN TEXT FILE. *PLEASE.*** It should contain:
	- Your name
	- Your Pitt username
	- Anything that **does not work**
	- Any **extra credit** you did
	- Anything you changed in `display.asm`, `convenience.asm` etc.
	- Anything else you think might help the grader grade your project more easily

[Those in the morning lecture submit here.](https://pitt.box.com/s/suuufmxymjt7vwszze54g9ldywquyvsb)

[Those in the afternoon lecture submit here.](https://pitt.box.com/s/x8yvu2qyy35a3rar2lf0gbytbhcin7l0)

## Grading Rubric

- **[16 points]:** Submission and style
	- **[6]:** You submitted your program properly (follow the directions above).
		- This is all or nothing. Please, just follow the instructions.
	- **[10]:** Your code is split into functions, and the functions use the calling convention we learned. **Don't keep global variables in registers!** Save *s* registers and *ra* as needed!
- **[84 points]:** The game
	- **[12]:** Game flow
		- **[4]** No crashes encountered during normal operation
		- **[4]** Game starts when player hits any key
		- **[4]** Game ends, somehow
	- **[24]:** Player
		- **[4]** Player ship is drawn onscreen
		- **[4]** Player moves around as specified (and can't leave specified area)
		- **[4]** Shots remaining are kept track of and displayed
		- **[4]** Lives remaining are kept track of and displayed
		- **[4]** Game over when shots == 0 or lives == 0
		- **[4]** Player ship looks different while invincible, and invincibility wears off after a time
	- **[24]:** Enemies
		- **[8]** Enemies represented in global variables in some way
		- **[4]** Some layout of enemies is drawn onscreen
		- **[4]** Enemies move left, right, and down (and can't go too low)
		- **[4]** Number of enemies remaining is kept track of
		- **[4]** Game over when all enemies destroyed
	- **[24]:** Bullets
		- **[4]** Player can fire bullets by pressing B, and they are rate-limited
		- **[8]** When enemy is hit by a bullet, the enemy is destroyed
		- **[8]** Enemies fire bullets (*any* enemy can, not just the same one over and over)
		- **[4]** When player is hit by a bullet, a life is lost and player becomes invincible

## **[+20 points]:** Extra Credit

You can earn up to 20 points extra, which is 3% of your class grade. **Please focus on the core game features above before trying to do the extra credit.**

If you want to implement something not on this list, please contact me beforehand and I can tell you how much it would be worth.

- **[+2]** Game intro and game over screens.
	- [Even something as simple as this example image](https://i.imgur.com/KVawr52.png) is fine.
	- Obviously you should give a happy message if they win!
	- ...and a sad message if they lose :(
- **[+4]** Difficulty scaling.
	- There are lots of ways to do this, and some are more fair than others. :P
	- Ideas: making the enemies get faster and faster; making them shoot faster; having multiple rounds and increasing difficulty with each one...
- **[+6]** Visual polish.
	- This is kinda subjective, but...
	- Animations, background elements, pretty-looking game intro/game over screens, etc.
- **[+8]** Powerups.
	- These should *noticeably* change gameplay.
	- Ideas: ammunition (more shots), extra lives, temporary invincibility, weapon upgrades, a shield with limited hits, etc.
