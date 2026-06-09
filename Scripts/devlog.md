# 2/9/2026 18:00pm:
The project was updated to Godot 4.6 and is ready for work.
	
## Next:
### [Done] For level 1:
1. (Optional) Upgrade the dialogue system code to be easier to implement.
2. [Done] Make the player move to the center of screen when the level exit dialogue starts.
3. [Done] Make the player inmune to damage while in dialogue.
4. [Done] Transitionate to level selection menu when the level exit dialogue ends.
### For level 2:
#### Design, no coding or sprite drawing yet.
1. [Done] Define level lore.
2. [Done] Define entering level dialogue.
3. [Done] Define level exit dialogue.
4. Design level layout.
##### Design level obstacles.
1. [Done] Spaceship parts.
2. [Done] Damaged spacehips.
3. [Done] Weak missile.
4. [Done] Auto aim missile.
5. [Done] Ally spaceship.
##### Design level enemies.
1. [Done] Enemy spaceship.
2. [Done] Alpha spaceship.
3. [Done] Mini boss.
4. [Done] Boss.
#### Graphics:
1. [Done] Draw obstacle sprites.
2. [Done] Draw enemy sprites.
3. [Done] Design obstacle visual effects.
4. Design enemy visual effects.
#### Logic: Coding starts here
1. Apply entering level dialogue.
2. [Done] Code obstacles logic.
3. Code enemies logic.
4. Apply design to level layout.
5. Apply level exit dialogue.
#### Test level.

## Focus plan:
Day 1: [Done] Make the plan.
Day 2: [Done] End level 1.
Day 3: Design & grahpics.
Day 4: Logic.
Saturday: Logic & test. 

# 2/10/2026 19:38pm:
Level 1 is finished, some details need to be polished in the future:
1. [Done] Enemies should disappear when they exit the screen at the bottom.
2. [Done] Enemies and obstacles should do more damage.
3. [Done] Blast powerups should only appear on the same specific locations every time.
4. [Done] Blast powerups should not spawn randomly from obstacles.
5. [Done] HUD should hide when the exit dialogue starts.
6. [Done] Add a little delay before loading the level selection scene.

# 2/11/2026 14:35pm:
Level 1 is finished and polished. The BGM is still pending though.
Level 2 design stage has started.

### Next:
1. [Done] Add BGM to level 1 before continuing with level 2.
	
# 2/11/2026 16:47pm:
Level 1 is finished.

### Next:
Continue with level 2 design.

### Notes:
1. Fix player engine sfx, its not reaction to input.
2. Enemy groups should despawn when the group animation ends.
		
# 2/18/2026 11:51pm:
Missile motion logic has been coded.

### Next:
1. [Done] Implement collision detection with player and other obstacles.
1. [Done] Begin obstacles logic implementation.

# 2/18/2026 14:30pm:
Level 2 obstacles have been coded.
Level 2 common enemies have been coded.

### Next:
1. [Done] Code miniboss logic.

# 3/4/2026 19:21pm:
Battlefield minibos has been coded.

### Next:
1. Code battlefield boss logic.

# 3/13/2026 15:32pm:
A boss core code was created and designed to be reusable.

# 3/16/2026 12:04pm:
A boss can now advance a stage for these cases: Weak point damage, shield damage and both.

# 3/16/2026 15:23pm:
A boss can now advance trough any stage type.

# 5/15/2026 17:17pm:
Im finally back to development on this project.
The main boss core logic is working, but damage indicator such as animations and sfx are missing.

### Next:
See if calling the boss animations and sfx by a common name is possible. If not, then do more research about overrideable functions.
If none of that works, then complex bosses could be keep out of the final game.

# 5/18/2026 14:20pm:
A boss can now attack and the attack can vary on each stage.

### Next:
Find a way to make the weak points get back to normal.

# 5/18/2026 14:20pm:
The battlefield boss is now compete, i just need to make it play the proper sfx when a player projectile hits it.

# 5/19/2026 12:33pm:
The battlefield boss is now fully complete.
The dialogue system was improved and it works without problems.

### Next:
Start level 2 design.

# 5/20/2026: 17:48pm:
Level 2 is almost finished, the boss projectiles are not beign spawned in the right position and projectiles are affecting the player for a while after beign destroyed.

# Next:
1. [Done] Fix the bug with the projectile collision sfx.
2. [Done] Add a explosion sfx to rockets.
3. [Done] Make the boss projectiles spawn at the right position.     
4. [Done] Fix audio problem when hitting the miniboss.
5. [Done] Add an explosion sfx to minibos death animation.
6. [Done] Make the boss rockets explode.

# 5/22/2026 11:39am:
Level 2 full cycle is now complete.

# Next:
1. [Fixed] Some projectiles sfx are beign played when no projectile interaction is seen on screen. Fix it.
2. [Omited for now] Enemy spaceships still fire after beign destroyed.
2. Start with Level 3 design.
