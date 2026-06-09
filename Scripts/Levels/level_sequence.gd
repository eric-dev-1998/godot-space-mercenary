extends Node

class_name LevelSequence

# Level main nodes:
var dialogue_system: DialogueSystem
var content: LevelContent
var sfx: Screen_FX
var hud: AnimationPlayer
var bgm: BGM

# Properties:
enum Level {
	Asteroids,
	Battlefield,
	Lab
}
@export var level: Level

@export var enter_dialogue: Array[DialogueLine]
@export var exit_dialogue: Array[DialogueLine]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get screen fx manager:
	sfx = get_node("CanvasLayer/Main_UI/ScreenFX")
	bgm = get_node("BGM")
	
	# Set intro dialogue:
	dialogue_system = get_node("CanvasLayer/Main_UI/Dialogue")
	dialogue_system.set_dialogue(enter_dialogue)
	
	dialogue_system.onEnd.connect(onDialogueEnd)
	
	content = get_node("Level/Content")
	hud = get_node("CanvasLayer/Main_UI/HUD/AnimationPlayer")
	hud.play("anim_hud_hide_snap")
	
	#sfx.queue.append(Screen_FX.FX_Type.Dark_out)
	
	# Show intro dialogue:
	dialogue_system.show_dialogue()

func onDialogueEnd() -> void:
	content.move = true
	hud.play("anim_hud_show")
	bgm.Start()
	dialogue_system.onEnd.disconnect(onDialogueEnd)
