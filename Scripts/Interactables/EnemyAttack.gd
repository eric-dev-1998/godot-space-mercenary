extends Resource
class_name EnemyAttack

@export var blastNode: PackedScene
@export var power: int = 1
@export var blastSpeed: int = 1
@export var reloadCooldown: float = 3
@export var singleShotSpeed: float = 0.75
@export var maxAmmo: int = 4

var parent: EnemyCore
var blastSpawnPoint: Node2D

var autoProtect: bool = false
var autoFire: bool = false
var canFire: bool = true
var alreadyFired: bool = false

var projectilesFired: int = 0

var projectileTimer: float = 0.0
var fireTimer: float = 0.0

func onReady() -> void:
	blastSpawnPoint = parent.get_node("BlastPosition")
	if !blastSpawnPoint:
		print("No blast spawn point was found for: '" + parent.name + "'.")

func fire(delta: float) -> void:
	if canFire:
		if !alreadyFired:
			fire_blast()
		else:
			cooldownPerProjectile(delta)
	else:
		cooldown(delta)

func fire_blast() -> void:
	if projectilesFired >= maxAmmo:
		alreadyFired = true
		canFire = false
		if autoProtect:
			parent.invinsible = false
		return
		
	spawn_blast()
	projectilesFired += 1
	alreadyFired = true
	projectileTimer = 0

func cooldownPerProjectile(delta: float) -> void:
	projectileTimer += delta
	if projectileTimer >= singleShotSpeed:
		alreadyFired = false
		projectileTimer = 0

func cooldown(delta: float) -> void:
	fireTimer += delta
	if fireTimer >= reloadCooldown:
		if autoFire:
			canFire = true
		
		if autoProtect:
			parent.invinsible = true
		
		fireTimer = true
		fireTimer = 0
		alreadyFired = false
		projectilesFired = 0

func spawn_blast() -> void:
	var blast = blastNode.instantiate() as Projectile
	blast.speed = blastSpeed
	blast.power = self.power
	blast.isEnemy = true
	blast.position = blastSpawnPoint.global_position
	parent.get_parent().add_child(blast)
