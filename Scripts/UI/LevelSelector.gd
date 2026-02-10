extends Node

# Stage displays:
var asteroids: Sprite2D
var battlefield: Node2D
var lab: Node2D

# UI Properties:
var arrow_left: TextureRect
var arrow_right: TextureRect
var label: Label
var top_label: Label
var sfx: Screen_FX

# Camera properties:
var camera: Camera2D
var camera_speed: float = 150.0
var camera_smoothness: float = 0.03
var camera_target: Vector2

var currentPosition: int = 0
var lockMovement: bool = false
var onPosition: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx = get_node("CanvasLayer/UI/ScreenFX")
	asteroids = get_node("Stages/Asteroids")
	battlefield = get_node("Stages/Battlefield")
	lab = get_node("Stages/LAB")
	camera = get_node("Stages/Camera2D")
	arrow_left = get_node("CanvasLayer/UI/Arrow_Left")
	arrow_right = get_node("CanvasLayer/UI/Arrow_Right")
	label = get_node("CanvasLayer/UI/Label")
	top_label = get_node("CanvasLayer/UI/Label2")
	
	sfx.queue.append(sfx.FX_Type.Dark_out)
	camera_target = asteroids.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.global_position.x = move_toward(camera.global_position.x, camera_target.x, camera_speed * camera_smoothness)
	if camera.global_position == camera_target:
		onPosition = true
		label.visible = true
		top_label.visible = true
		manage_arrows()
	else:
		onPosition = false
		label.visible = false
		top_label.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed():
			if onPosition:
				match event.keycode:
					KEY_SPACE:
						select_stage()
					KEY_LEFT:
						switch_stage(clampIndex(currentPosition - 1))
					KEY_RIGHT:
						switch_stage(clampIndex(currentPosition + 1))

func clampIndex(index: int) -> int:
	if GameData.levels_unlocked == 0:
		return 0;
	
	if GameData.levels_unlocked == 1:
		if index < 0:
			return 0
		if index > 1:
			return 1
	
	if index < 0:
		return 0
	if index > 2:
		return 2
	
	currentPosition = index
	return currentPosition

func manage_arrows() -> void:
	if GameData.levels_unlocked == 0:
		arrow_left.visible = false;
		arrow_right.visible = false;
		return
	
	if GameData.levels_unlocked == 1:
		if currentPosition == 1:
			arrow_left.visible = true;
			arrow_right.visible = false;
			return
	
	match currentPosition:
		0:
			arrow_left.visible = false
			arrow_right.visible = true
		1:
			arrow_left.visible = true
			arrow_right.visible = true
		2:
			arrow_left.visible = true
			arrow_right.visible = false

func switch_stage(index: int) -> void:
	match index:
		0:
			camera_target = asteroids.global_position
			label.text = "Asteroids field"
		1:
			camera_target = battlefield.global_position
			label.text = "Battlefield"
		2:
			camera_target = lab.global_position
			label.text = "The LAB"

func select_stage() -> void:
	
	if onPosition:
		match currentPosition:
			0:
				# Load asteroids level.
				get_tree().change_scene_to_file("res://Scenes/Levels/level_asteroids.tscn")
				pass
			1:
				# Load batteflield level.
				pass
			2:
				# Load LAB level.
				pass
