extends Node2D

class_name Rocket

# Main properties:
@export var follow_player = false
@export var speed: float = 3.0
@export var disttance_to_follow: float = 80.0
@export var is_boss: bool = false

var player: Player
var health: PackedScene
var explosion: CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.projectiles_spawned += 1
	
	player = get_node("/root/Main/Level/Player");
	if player == null:
		print("[Rocket.gd]: Player node was not fonund in scene with the specified path.")
	
	health = preload("res://Scenes/Pickups/Health_Core_Small.tscn")
	
	explosion = get_node("explosion")

func _process(delta: float) -> void:
	if global_position.y > 0:
		if follow_player:
			var targetPosition = Vector2(player.global_position.x, global_position.y)
			position = position.move_toward(targetPosition, speed * delta)
	
	if global_position.y >= 170:
		GameData.projectiles_killed += 1
		queue_free()

func on_collision(area: Area2D) -> void:
	
	if global_position.y < 8:
		return
	
	if area.get_parent() is BossCore and is_boss:
		return;
	
	if area.get_parent() is Player:
		# Collided with player.
		print("Hit player.")
		hit_player()
	elif area.get_parent() is Enemy:
		print("Hit enemy.")
		# Collided with an enemy.
		hit_enemy(area.get_parent() as Enemy)
	elif area.get_parent() is Obstacle:
		# Collided with something else.
		print("Hit obstacle.")
		hit_something(area.get_parent() as Obstacle)
	
	destroy_self()

func hit_player() -> void:
	player.collision.recieveDamage(true)
	destroy_self()

func hit_enemy(enemy: Enemy) -> void:
	var projectileData = Projectile.new()
	projectileData.power = 2
	enemy.hit_blaster(projectileData)

func hit_something(obstacle: Obstacle) -> void:
	obstacle.hit(obstacle.get_node("Area2D"))

func destroy_self() -> void:
	GameData.projectiles_killed += 1
	
	get_node("Sprite2D").visible = false
	
	var sfx = get_node("ExplosionSFX") as AudioStreamPlayer2D
	sfx.play()
	
	var area = get_node("Area2D") as Area2D
	area.set_deferred("monitoring", false)
	area.set_deferred("monitorable", false)
	
	explosion.emitting = true
	
	var rnd = randi_range(0, 100)
	if rnd > 30 and rnd < 70:
		var core = health.instantiate()
		core.position = position
		get_parent().call_deferred("add_child", core)

func on_particle_end() -> void:
	queue_free()
