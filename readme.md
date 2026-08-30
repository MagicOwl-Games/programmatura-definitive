# Programmatura

Programmatura is a roguelite turn-based game where the player is a software travelling
from one machine to another, searching for items and uncovering the secrets of the world
outside the Original — that's what the main machine is called.

**Ware** is our hero, and he must not be caught by his fellows **Antiviruses**. If so, the stage
will be restarted, and the items gathered up until that moment are all lost.

The game is played from a top-down perspective, with a 4-way tiled movement, and turn-based actions.
You can move move around and use items to help. Well, not all items. Some items are just collectibles
of the stage. The more you get those, the more points you get at the end of your run.

The first version is supposed to have 5 to 10 stages. Later versions are being planned to have a finite
but very high number of stages.

## TO-DO
- Main Scene
- [ ] Title Screen
- [ ] Game Over Scene
- [ ] Stage Scene
- [ ] UI
	- [ ] Commands
		- [ ] Move player
			- [x] The player should be able to move where there's a free tile
			- [x] The player shouldn't be able to move where there is no free tile (wall or obstacle)
			- [ ] "Check mate" detection. If, in the next move, there's no way to be safe, it should be game over
		- [ ] Items
			-	[ ] It should be possible to use Consumables
			- [ ] It shouldn't be possible to use Collectibles
			- [ ] Collectibles should all be lost after losing a stage and restarting
- [ ] Detection AI (4-way detection)
	-	[ ] The detection raycast shouldn't be pointed to a blocked tile (wall or obstacle)
- [x] 4-way tile-based movement.
- [ ] Turn manager
	- [x] Enemies move after the player
	- [ ] Smoother move transitions (affects UI directly)
	- [ ] Queue system, with the queue visible in the UI
		-	[ ] It should be affected by items (slow an enemy or hasting the player changes the queue)
- [ ] Implement a turn counter
	- [ ] There is a limited amount of turns to move
	- [ ] The player gains bonuses if it gets to the end in less than a given amount of turns
	- [ ] The player loses the stage if the amount of turns ends before finishing the stage
