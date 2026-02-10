extends Area2D

# Level exit dialogue.
@export var dialogue_lines: Array[String]
var dialogue: Array[DialogueSystem.DialogueLine]

# Dialogue node.
var dialogueSystem: DialogueSystem

func _ready() -> void:
	# Get dialogue system.
	dialogueSystem = get_node("/root/Main/CanvasLayer/UI/Dialogue")

func SetDialogue() -> void:
	# Convert input lines to a dialogue.
	for line in dialogue_lines:
		dialogue.append(DialogueSystem.DialogueLine.new(line, null))
	
	# Parse output dialogue to dialogue system.
	dialogueSystem._set_dialogue(dialogue)

func StartDialogue(_area: Area2D) -> void:
	# This method is called when player collides with this Area2D instance.
	
	# Prepare dialogue.
	SetDialogue()
	
	# Show dialogue.
	dialogueSystem.show_dialogue()
