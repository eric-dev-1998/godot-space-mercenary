extends Node2D

# Main properties:
@export var follow_speed: float = 3.0
@export var disttance_to_follow: float = 20.0
@export var rotation_speed: float = 25.0
@export var is_rocket: bool = false
var player: Player

# Collision properties:
var area: Area2D

# FX:
var explosion: CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("/root/Test_Level/Camera2D/Player")
