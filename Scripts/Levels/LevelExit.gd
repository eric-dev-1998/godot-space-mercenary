extends Area2D

# Level exit dialogue.
@export var dialogue_lines: Array[String]
var dialogue: Array[DialogueSystem.DialogueLine]

# Dialogue node.
var dialogueSystem: DialogueSystem
var hud: AnimationPlayer
var center: bool = false

func _ready() -> void:
	# Get dialogue system.
	dialogueSystem = get_node("/root/Main/CanvasLayer/UI/Dialogue")
	hud = get_node("/root/Main/CanvasLayer/UI/HUD/AnimationPlayer");

func _process(delta: float) -> void:
	if center:
		CenterPlayer(delta);

func SetDialogue() -> void:
	# Convert input lines to a dialogue.
	for line in dialogue_lines:
		dialogue.append(DialogueSystem.DialogueLine.new(line, null))
	
	# Parse output dialogue to dialogue system.
	dialogueSystem.set_dialogue(dialogue, 2.0)

func StartDialogue(_area: Area2D) -> void:
	# This method is called when player collides with this Area2D instance.
	GameData.levels_unlocked += 1
	
	# Prepare dialogue.
	SetDialogue()
	
	# Hide HUD:
	hud.play("anim_hud_hide");
	
	# Show dialogue.
	dialogueSystem.show_dialogue()
	
	# Disable player movement.
	dialogueSystem.player.movement.canMove = false
	
	# Make player inmune to damage:
	dialogueSystem.player.collision.canRecieveDamage = false
	center = true

func CenterPlayer(deltaTime) -> void:
	var player = dialogueSystem.player
	player.global_position = player.global_position.move_toward(Vector2(80, 80), 30 * deltaTime)
