extends Node

@export var dialogue: Array[DialogueLine]

func _ready() -> void:
	var dialogue_system = get_node("CanvasLayer/Main_UI/Dialogue") as DialogueSystem
	dialogue_system.set_dialogue(dialogue)
	dialogue_system.show_dialogue()
	dialogue_system.onEnd.connect(go_to_paycheck)

func go_to_paycheck() -> void:
	get_tree().change_scene_to_file("res://Scenes/PayCheck.tscn")
