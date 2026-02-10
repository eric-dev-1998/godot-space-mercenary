extends Node

# Level main nodes:
var dialogue_system: DialogueSystem
var content: LevelContent
var sfx: Screen_FX
var hud: AnimationPlayer

# Properties:
enum Level {
	Asteroids,
	Battlefield,
	Lab
}
@export var level: Level

var dialogue_level_0: Array = [
	DialogueSystem.DialogueLine.new("There is an asteroid field between me and the lab.", preload("res://Sprites/Dialogues/AsteroidField.png")),
	DialogueSystem.DialogueLine.new("Going arround will take too long.", "none"),
	DialogueSystem.DialogueLine.new("It's better to go across the asteroids field.", "none"),
	DialogueSystem.DialogueLine.new("I better be careful.", "none"),
]
var dialogue_level_1: Array
var dialogue_level_2: Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get screen fx manager:
	sfx = get_node("CanvasLayer/UI/ScreenFX")
	
	# Set intro dialogue:
	dialogue_system = get_node("CanvasLayer/UI/Dialogue")
	match level:
		Level.Asteroids:
			sfx.queue.append(sfx.FX_Type.Dark_out)
			dialogue_system._set_dialogue(dialogue_level_0)
		Level.Battlefield:
			dialogue_system._set_dialogue(dialogue_level_1)
		Level.Lab:
			dialogue_system._set_dialogue(dialogue_level_2)
	
	dialogue_system.onEnd = Callable(self, "onDialogueEnd")
	
	content = get_node("Level/Content")
	sfx = get_node("CanvasLayer/UI/ScreenFX")
	hud = get_node("CanvasLayer/UI/HUD/AnimationPlayer")
	hud.play("anim_hud_hide_snap")
	# Show intro dialogue:
	dialogue_system.show_dialogue()

func onDialogueEnd() -> void:
	content.move = true
	hud.play("anim_hud_show")
