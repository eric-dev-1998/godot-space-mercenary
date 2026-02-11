extends Node2D

class_name Enemy

@export var follow: bool = true
@export var health: int = 3
@export var healthToShowDamage: int = 2
@export var power: int = 1
@export var in_group: bool = false;
@export var followSpeed: float = 10
@export var reloadCooldown: float = 3
@export var singleShotSpeed: float = 0.75
@export var maxAmmo: int = 4

var player: Player
var area2d: Area2D
var invinsible: bool = false
var in_position: bool = false;
var canFire: bool = true
var alreadyFired: bool = false
var distanceFromGameArea: float
var forwardSpeed: float = 3
var projectilesFired: int = 0
var projectileTimer: float = 0
var fireTimer: float = 0
var blastNode

# Visual fx:
var particles_smoke: CPUParticles2D
var particles_bits: CPUParticles2D
var particles_explosion: CPUParticles2D

# SFX:
var sfx_death: AudioStreamPlayer2D

func _ready() -> void:
	area2d = get_node("Area2D")
	area2d.area_entered.connect(onHit)
	particles_smoke = get_node("FX/Damage")
	particles_bits = get_node("FX/Explosion_Bits")
	particles_bits.finished.connect(clear)
	particles_explosion = get_node("FX/Explosion")
	player = get_node("/root/Main/Level/Player")
	blastNode = load("res://Scenes/Projectiles/enemy_blast.tscn")
	sfx_death = get_node("/root/Main/SFX/Obstacles/Enemy_Death")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# If player is near enough, follow him and perform
	# shooting sequence.
	if in_group:
		if in_position:
			fire(delta)
	else:
		if global_position.y > 10:
			follow_player(delta)
			fire(delta)
	
	if health <= 0:
		var area = get_node("Area2D") as Area2D
		area.monitorable = false
		area.monitoring = false
		
	if is_out_of_screen():
		# Clear this enemy from the scene if it exits the screen from the bottom.
		print("Enemy cleared from scene.")
		clear()

func onHit(area: Area2D) -> void:
	if global_position.y < 4:
		return
	
	for a in area2d.get_overlapping_areas():
		var area_name = a.get_parent().name
		
		if get_parent() is Player:
			# Collider with player.
			hit_player(a)
			pass
		
		if a.get_parent() is Projectile:
			var projectileData: Projectile = a.get_parent()
			
			if projectileData != null:
				# Collider with player blast:
				hit_blaster(projectileData)
				pass
		
		if a.get_parent() is Obstacle:
			# Got hit by an obstacle.
			explode()
			
		# Ignore if got hit by something else.
	pass

func hit_player(player_area: Area2D) -> void:
	# Hit by player.
	explode()
	pass

func hit_blaster(projectileData: Projectile) -> void:
	# Hit by player blaster.
	if invinsible:
		return
	
	# Inflict damage.
	health -= projectileData.power
	
	# Check current health:
	if health <= 0:
		# This enemy ran out of health, destroy it.
		explode()
		pass
	
	if health <= healthToShowDamage:
		# This enemy is badly damaged, init smoke particles.
		particles_smoke.emitting = true
		pass
	pass

func explode() -> void:
	# Init enemy explotion sequence.
	sfx_death.play(0.0)
	get_node("Sprite2D").visible = false
	particles_smoke.emitting = false
	particles_explosion.emitting = true
	particles_bits.emitting = true
	
	# Add score to player local scrore:
	player.local_score += 1
	pass

func clear() -> void:
	# Remove this enemy instance from scene.
	queue_free()
	pass

func follow_player(delta: float) -> void:
	if follow:
		position.x = move_toward(position.x, player.position.x, followSpeed * delta)

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
		canFire = true
		fireTimer = true
		fireTimer = 0
		alreadyFired = false
		projectilesFired = 0

func spawn_blast() -> void:
	var blast = blastNode.instantiate()
	blast.position = position
	get_parent().add_child(blast)

func is_out_of_screen() -> bool:
	if global_position.y > 168:
		return true
	else:
		return false
