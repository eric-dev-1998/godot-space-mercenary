extends Node2D

var area_exit: Area2D
var anim: AnimationPlayer
var player: Player
var player_entered: bool = false

func _ready() -> void:
	area_exit = get_node("Exit/Area2D")
	anim = get_node("AnimationPlayer")
	player = get_node("/root/Main/Level/Player")

func _process(delta: float) -> void:
	
	if !player_entered:
		if global_position.y > 20:
			onEnter()
			player_entered = true

func onEnter() -> void:
	# Enter the meteor:
	anim.play("anim_meteor_enter")
	
	# Change player movement range:
	player.movement.min_x = 26
	player.movement.max_x = 134
	player.movement.min_y = 26
	player.movement.max_y = 134

func onExit(area: Area2D) -> void:
	# Exit the meteor:
	if isPlayerOnArea(area_exit):
		# Change player movement range back to normal:
		player.movement.min_x = 4
		player.movement.max_x = 156
		player.movement.min_y = 4
		player.movement.max_y = 156

func isPlayerOnArea(area: Area2D) -> bool:
	for a in area.get_overlapping_areas():
		if a.get_parent() is Player:
			return true
	return false


func _on_enemies_enter_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
