# **Space mercenary: Level 2**

## **Lore:**
The player enters the battlefield, some enemy hordes attack one after another.
Ally spaceships come to help from time to time, player loses points if kills an ally spaceship.
In the middle, a bigger enemy creature spawns, is a mini boss. After that, more enemy hordes come to attack.
An even bigger enemy spaceship comes, and kills the ally spaceships nearby if any.
The player destroys the enemy boss and then reaches the lab facilities.

### Enter dialogue:
	I can see the battlefield ahead.
	It's time to go all in.

### Exit dialogue:
	What are those creatures?
	...
	I can see the lab, let's go.

## **Enemies:**
1. Beetle.
2. Spaceship
3. Mini boss
4. Boss

## **Obstacles:**
1. Small missiles: These come in to a straight line.
2. Auto aimed missiles: These aim for the player.
3. Damaged spaceships: These will explode on contact.
4. Spaceship parts.

## **Level stages:**
1. [Done] Some damaged spaceships appear followed by some beetles.
2. [Done] A few small missiles and a horde of weak enemy spaceships.
3. [Done] A few alpha spaceships attack.
4. [Done] Mini boss
5. [Done] Rain of auto aimed missiles.
6. [Done] Pieces of the lab starts to show up followed by more weak spaceships.
7. [Omitted] A horde of alpha spaceships appears.
8. Boss

## Mini boss:
### Appearance:
It's a creature stuck inside a cage, it has a big eye and tentacles coming out of the cage's bars.

### Abilities:
It can fire a beam through it's eye and can spawn power balls that explodes when it touches something.

### Behavior:
It cant move around because of the cage, but it will move freely once the cages breaks.

### Battle sequence:
1. Caged: It wont move, but will fire a beam through its eye.
2. Free: It will move around a little, it can fire the beam and can throw power damaging balls.

## Boss:
### Appearance:
A big and slimy 3-eyed creature with robotic parts on its inside.

### Abilities:
Slime attack -> Throws a slime ball to the player.
Slime rain -> Throws a load of tiny slime balls.
Missile attack -> Launch missiles desperately.

### Behavior:
This creature moves around trying to hit the player, but its not too fast.

### Battle sequence:
Stage 1:
	If there are still eyes healthy:
		Do slime attack.
	else:
		Hide.
		Do slime rain.
Stage 2:
	If there are still eyes healthy:
		Do slime attack.
	else:
		Hide.
		Do slime rain.
Stage 3:
	If there are still eyes healthy:
		Do slime attack.
	else:
		Expose mechanical body.
		Do missile attack.
Stage 4:
	If there are still eyes healthy:
		Do missile attack.
	else:
		Explode.
