extends Node2D

class_name EnemyGroup

var anim: AnimationPlayer
var camera: Camera2D
var hookToCamera: bool = false;

func _ready() -> void:
	anim = get_node("AnimationPlayer")
	camera = get_node("/root/Main/Level/Camera2D")
	
	anim.play("anim_hide_enemies")
	make_enemies_invinsible()

func _process(delta: float) -> void:
	hook_to_camera()

func hook_to_camera() -> void:
	global_position = camera.global_position

func hide_enemies() -> void:
	anim.play("anim_hide_enemies_smooth")

func show_enemies() -> void:
	anim.play("anim_show_enemies")
	make_enemies_vulnerable()
	hookToCamera = true

func make_enemies_vulnerable() -> void:
	for e in get_children():
		if e is Enemy:
			var enemy_data = e as Enemy
			enemy_data.invinsible = false

func make_enemies_invinsible() -> void:
	for e in get_children():
		if e is Enemy:
			var enemy_data = e as Enemy
			enemy_data.invinsible = true

func start_fire() -> void:
	for e in get_children():
		if e is Enemy:
			var enemy_data = e as Enemy
			enemy_data.in_position = true
			
			# Randomize time to star firing:
			enemy_data.alreadyFired = true
			enemy_data.singleShotSpeed = 5.0
			enemy_data.projectileTimer = randf_range(0.1, enemy_data.singleShotSpeed)
