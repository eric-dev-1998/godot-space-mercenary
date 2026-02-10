extends Node2D

class_name Obstacle

enum Item {
	None,
	Health,
	Health_Max,
	Upgrade,
}

@export var health: int = 3
@export var solid: bool = false
@export var rotate: bool = false
@export var is_rocket: bool = false
@export var item: Item

var item_health
var item_health_max
var item_upgrade
var item_spawned: bool = false;

var player: Player
var area2d: Area2D
var particles: CPUParticles2D
var rotationSpeed: float = 12
var rotateLeft: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Main/Level/Player");
	
	area2d = get_node("Area2D")
	area2d.area_entered.connect(hit)
	
	if !solid:
		particles = get_node("Particles")
		particles.finished.connect(onParticlesFinish)
		
	setup_rotation()
	
	if !solid:
		item_health = load("res://Scenes/Pickups/Health_Core_Small.tscn")
		item_health_max = load("res://Scenes/Pickups/Health_Core.tscn")
		item_upgrade = load("res://Scenes/Pickups/Upgrade.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotate_obstacle(delta)
	
	if health <= 0 and !item_spawned:
		spawnItem()

func setup_rotation() -> void:
	var rng = RandomNumberGenerator.new()
	var res = rng.randi_range(-10, 10)
	
	if res < 0:
		rotateLeft = true;
	
	pass

func rotate_obstacle(delta: float) -> void:
	if rotate:
		if rotateLeft:
			# Rotate to the left.
			rotation_degrees += rotationSpeed * delta
		else:
			# Rotate to the right.
			rotation_degrees -= rotationSpeed * delta

func hit(other: Area2D) -> void:
	# Collision handler.
	if global_position.y < 4:
		return
	
	if !solid:
		if is_rocket:
			destroy()
		
		for area in area2d.get_overlapping_areas():					
			if area.get_parent() is Projectile:
				# Got hit by a player blast, inflict damage:
				var projectileData: Projectile = area.get_parent()
				health -= projectileData.power
			
			# Destroy if this obstacle runs out of health:
			if health <= 0:
				destroy()

func destroy() -> void:
	# Display the destruction particle effect:
	particles.emitting = true
	
	# Hide the sprite:
	get_node("Sprite2D").visible = false
	
	# And destroy the area2d object to avoid it interfiering
	# with other collisions:
	area2d.queue_free()
	
	# Add points to player score:
	player.local_score += 1

func spawnItem() -> void:
	# Spawn item if enabled:
	var item_node
	
	if item != Item.None:
		match item:
			Item.Health:
				item_node = item_health.instantiate()
			Item.Health_Max:
				item_node = item_health_max.instatiate()
			Item.Upgrade:
				item_node = item_upgrade.instantiate()
		
		get_parent().add_child(item_node)
		item_node.global_position = global_position
		item_spawned = true
		
	else:
		# Manage randomization:
		# 1. Is an item going to spawn?
		var spawn: bool = false
		var n = randi_range(0, 100)
		
		if n > 20 and n < 35:
			spawn = true
		else:
			item_spawned = true
			return
			
		if spawn:
			# 1. If so, which item is it?
			var item_id: int = -1
			var item_n = randi_range(0, 1000)
			
			if item_n > 20 and item_n < 40:
				item_id = 2
			elif item_n >= 100 and item_n < 300:
				item_id = 1
			else:
				item_id = 0
			
			if spawn:
				if item_id == 0:
					item_node = item_health.instantiate()
				elif item_id == 1:
					item_node = item_upgrade.instantiate()
				else:
					item_node = item_health_max.instantiate()
				
				get_parent().add_child(item_node)
			item_node.global_position = global_position
			
			item_spawned = true

func onParticlesFinish() -> void:	
	# Destroy this obstacle completely when the destruction
	# effect is finished:	
	queue_free();

func is_out_of_screen() -> bool:
	if global_position.y < 0:
		return true
	else:
		return false
