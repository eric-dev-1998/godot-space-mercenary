extends Node

class_name Player_Blast

# Properties:
var mode: int = 0
var secondShot: bool = false;
var canFire: bool = true;
var playerPosition: Vector2
var player_node: Node2D
var cooldown: float = 0.2
var cooldownCount: float = 0

@onready var blast = preload("res://Scenes/Projectiles/blast.tscn")

func _init(player_node) -> void:
	self.player_node = player_node

func _cooldown(delta: float) -> void:
	if !canFire:
		if cooldownCount >= cooldown:
			canFire = true
			cooldownCount = 0
		cooldownCount += delta

# Main fire function:
func fire(position) -> void:	
	if InputManager.isPrimaryPressed && canFire:
		playerPosition = position
		match(mode):
			0:
				# Fire a single blast.
				fire_single()
			1:
				# Fire a double blast.
				fire_double()
			2:
				# Fire a powerful double blast.
				fire_double_max()
		
		canFire = false
		cooldownCount = 0

func fire_single() -> void:
	var blast = preload("res://Scenes/Projectiles/blast.tscn").instantiate()
	
	if secondShot:
		# Fire from left.
		blast.position = Vector2(playerPosition.x - 4, playerPosition.y)
		secondShot = false
	else:
		# Fire from right.
		blast.position = Vector2(playerPosition.x + 4, playerPosition.y)
		secondShot = true
	
	player_node.get_parent().add_child(blast)

func fire_double() -> void:
	var left_blast = preload("res://Scenes/Projectiles/blast_1.tscn").instantiate()
	var right_blast = preload("res://Scenes/Projectiles/blast_1.tscn").instantiate()
	
	left_blast.position = Vector2(playerPosition.x - 4, playerPosition.y)
	right_blast.position = Vector2(playerPosition.x + 4, playerPosition.y)
	
	player_node.get_parent().add_child(left_blast)
	player_node.get_parent().add_child(right_blast)
	
	var blast_data = left_blast as Projectile
	blast_data.sfx.stop();

func fire_double_max() -> void:
	var left_blast = preload("res://Scenes/Projectiles/blast_upgraded.tscn").instantiate()
	var right_blast = preload("res://Scenes/Projectiles/blast_upgraded.tscn").instantiate()
	
	left_blast.power = 2
	right_blast.power = 2
	
	left_blast.position = Vector2(playerPosition.x - 4, playerPosition.y)
	right_blast.position = Vector2(playerPosition.x + 4, playerPosition.y)
	
	player_node.get_parent().add_child(left_blast)
	player_node.get_parent().add_child(right_blast)
	
	var blast_data = left_blast as Projectile
	blast_data.sfx.stop();
