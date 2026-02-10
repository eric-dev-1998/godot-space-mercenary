extends Node2D

enum PowerupType {
	Health,
	Health_Plus,
	Energy,
	Blaster,
}

@export var type: PowerupType
var area2d: Area2D
var sprite: Sprite2D
var sfx: AudioStreamPlayer2D
var entered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area2d = get_node("Area2D")
	sprite = get_node("Sprite2D")
	
	if type == PowerupType.Blaster:
		sfx = get_node("/root/Main/SFX/Collectables/Upgrade")
	else:
		sfx = get_node("/root/Main/SFX/Collectables/Health")
		
	area2d.area_entered.connect(onHit)

func onHit(area: Area2D) -> void:
	for a in area2d.get_overlapping_areas():
		if a.get_parent() is Player and !entered:
			var player: Player = a.get_parent()
			# Handle collision with player.
			take(player)

func take(player: Player) -> void:
	entered = true
	
	# Apply effect to player.
	match type:
		PowerupType.Health:
			player.health += 3
			if player.health >= player.health_max:
				player.health = player.health_max
		
		PowerupType.Health_Plus:
			player.health += player.health_max
			
		PowerupType.Energy:
			pass
			
		PowerupType.Blaster:
			player.blast.mode += 1
			if player.blast.mode >= 2:
				player.blast.mode = 2
	
	sprite.visible = false
	sfx.play(0.0)

func destroy() -> void:
	# Destroy this object.
	queue_free()
