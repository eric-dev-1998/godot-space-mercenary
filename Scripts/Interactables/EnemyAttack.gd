extends Resource
class_name EnemyAttack

@export var blastNode: PackedScene
@export var power: int = 1
@export var blastSpeed: float = 1
@export var reloadCooldown: float = 3
@export var singleShotSpeed: float = 0.75
@export var maxAmmo: int = 4
@export var spawn_randomly_over_x: bool = false
@export var spawn_min_x: int = 0
@export var spawn_max_x: int = 20

var parent: EnemyCore
var parent_node: Node2D
var parent_path: String
var blastSpawnPoint: Node2D
var level: LevelContent

var autoProtect: bool = false
@export var autoFire: bool = false
var canFire: bool = true
var alreadyFired: bool = false

var projectilesFired: int = 0

var projectileTimer: float = 0.0
var fireTimer: float = 0.0

func load() -> void:
	if parent != null:
		blastSpawnPoint = parent.get_node("BlastPosition")
		if !blastSpawnPoint:
			print("No blast spawn point was found for: '" + parent.name + "'.")
	elif parent_node != null:
		blastSpawnPoint = parent_node.get_node("BlastPosition")
		if !blastSpawnPoint:
			print("No blast spawn point was found for: '" + parent.name + "'.")
	else:
		print("No enemy core parent was found for this enemy projectile.")

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
	var blast = blastNode.instantiate()
	
	if blast is Projectile:
		blast.speed = blastSpeed
		blast.power = self.power
		blast.isEnemy = true
	elif blast is Enemy:
		blast.health = self.power
		blast.follow = true
		blast.followSpeed = blastSpeed
		blast.moveIndependently = true
		blast.maxAmmo = 1
		blast.reloadCooldown = 4
	
	if parent:
		level = parent.get_node("/root/Main/Level/Content") as LevelContent
	else:
		level = parent_node.get_node("/root/Main/Level/Content") as LevelContent
	
	if !spawn_randomly_over_x:
		var targetPosition = blastSpawnPoint.global_position - level.global_position
		
		blast.position = targetPosition
		print("target position: " + str(blastSpawnPoint.global_position) + ", final position: " + str(blast.global_position))
	else:
		if parent:
			blast.position = Vector2i(randi_range(spawn_min_x, spawn_max_x), (parent.position.y + 10) - level.global_position.y)
		else:
			blast.position = Vector2i(randi_range(spawn_min_x, spawn_max_x), (parent_node.global_position.y - 80) - level.global_position.y)
		if blast is Enemy:
			blast.position.y += 10
	if parent != null:
		parent.get_parent().get_parent().add_child(blast)
	else:
		parent_node.get_parent().add_child(blast)

func set_parent(parent: Node2D) -> void:
	parent_node = parent
