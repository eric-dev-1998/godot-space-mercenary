extends Node2D

class_name Hit

var sfx_hit_asteroid: AudioStreamPlayer2D
var sfx_hit_solid: AudioStreamPlayer2D
var sfx_hit_enemy: AudioStreamPlayer2D

func _ready() -> void:
	sfx_hit_asteroid = get_node("/root/Main/SFX/Obstacles/Non_Solid")
	sfx_hit_solid = get_node("/root/Main/SFX/Obstacles/Solid")
	sfx_hit_enemy = get_node("/root/Main/SFX/Obstacles/Enemy_Hit")

func play_sfx(sfx_hit_mode: int) -> void:
	match sfx_hit_mode:
		0:
			sfx_hit_asteroid.play(0.0)
		1:
			sfx_hit_solid.play(0.0)
		2:
			sfx_hit_enemy.play(0.0)
