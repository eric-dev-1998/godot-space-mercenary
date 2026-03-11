extends Node
class_name BattlefieldBoss

var eyes: int = 3
var eye_health = [15, 15, 15]
var health: int = 50
var stage: int = 0
var vulnerable: bool = true

var eye_vulnerabillity = [true, true, true]
var eye_nodes: Array[Sprite2D]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	eye_nodes = [
		get_node("Eye_0") as Sprite2D, 
		get_node("Eye_1") as Sprite2D, 
		get_node("Eye_2") as Sprite2D
	]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func hit_eye_0(area: Area2D) -> void:
	damage_eye(area, 0)

func hit_eye_1(area: Area2D) -> void:
	damage_eye(area, 1)

func hit_eye_2(area: Area2D) -> void:
	damage_eye(area, 2)

func damage_eye(area: Area2D, eye_index: int) -> void:
	if area.get_parent() is Projectile:
		var p: Projectile = area.get_parent() as Projectile
		if !p.isEnemy:
			if eye_vulnerabillity[eye_index]:
				eye_health[eye_index] -= p.power
				display_eye_damage(eye_index)
				check_eyes_health(eye_index)
			p.explode(2)

func display_eye_damage(eye_index: int) -> void:
	var anim: AnimationPlayer = eye_nodes[eye_index].get_node("Eye_Damaged")
	if anim.is_playing():
		anim.stop()
	anim.play("anim_bfboss_eye_damage")

func check_eyes_health(eye_index: int) -> void:
	if eye_health[eye_index] <= 0:
		eye_vulnerabillity[eye_index] = false
		eye_nodes[eye_index].texture = load("res://Sprites/Spaceships/Mini boss 0/Eye_Closed.png")
		var anim: AnimationTree = eye_nodes[eye_index].get_node("Eye_Idle/Tree")
		anim.active = false
	
	if eye_health[0] <= 0 and eye_health[1] <= 0 and eye_health[2] <= 0:
		# Advance to next stage.
		stage += 1
		advance_stage()

func advance_stage() -> void:
	print("Advanced to next stage.")
	pass
