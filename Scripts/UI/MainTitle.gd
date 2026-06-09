extends Control

class_name MainTitle

@export var intro_dialogue: Array[DialogueLine]

var icon: TextureRect
var anim: AnimationPlayer
var fx: Screen_FX
var selection: int = 0
var canInteract: bool = true
var pressedStart: bool = false

var sfx_select: AudioStreamPlayer2D
var sfx_switch: AudioStreamPlayer2D

# Intro dialogue properties:
var dialogueSystem: DialogueSystem


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon = get_node("Icon")
	fx = get_node("ScreenFX")
	anim = get_node("AnimationPlayer")
	dialogueSystem = get_node("../Dialogue_Intro")
	
	sfx_select = get_node("Select")
	sfx_switch = get_node("Switch")

func _process(delta: float) -> void:
	icon.visible = canInteract

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed() && !pressedStart:
			if event.keycode == KEY_UP:
				sfx_switch.play()
				selectStart()
			if event.keycode == KEY_DOWN:
				sfx_switch.play()
				selectExit()
			if event.keycode == KEY_SPACE:
				if selection == 0:
					#start()
					sfx_select.play()
					pressedStart = true
				else:
					exit()

func selectStart() -> void:
	if canInteract:
		selection = 0
		icon.position.y = 108

func selectExit() -> void:
	if canInteract:
		selection = 1
		icon.position.y = 108 + 16

func start() -> void:
	# Start game.
	if canInteract:
		fx.queue.append(Screen_FX.FX_Type.Dark_in)
		#fx.queue.append(Screen_FX.FX_Type.Dark_out)
		
		# Show intro dialogue:
		dialogueSystem.set_dialogue(intro_dialogue)
		#dialogueSystem.onEnd.connect(goToLevelSelection)
		dialogueSystem.show_dialogue()
		
		anim.play("anim_main_title_fade")
		canInteract = false

func exit() -> void:
	# Exit game.
	pass

func goToLevelSelection() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/level_selection.tscn")
