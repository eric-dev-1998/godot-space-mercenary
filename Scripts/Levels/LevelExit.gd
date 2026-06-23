extends Area2D

# Level exit dialogue.
@export var dialogue_lines: Array[String]
var level_sequence: LevelSequence

# Dialogue node.
var dialogueSystem: DialogueSystem
var hud: AnimationPlayer
var center: bool = false

func _ready() -> void:
	# Get dialogue system.
	dialogueSystem = get_node("/root/Main/CanvasLayer/Main_UI/Dialogue")
	hud = get_node("/root/Main/CanvasLayer/Main_UI/HUD/AnimationPlayer")
	level_sequence = get_parent().get_parent().get_parent() as LevelSequence

func _process(delta: float) -> void:
	if center:
		CenterPlayer(delta);

func SetDialogue() -> void:
	dialogueSystem.set_dialogue(level_sequence.exit_dialogue)
	GameData.score += level_sequence.player.local_score

func StartDialogue(_area: Area2D) -> void:
	# This method is called when player collides with this Area2D instance.
	GameData.levels_unlocked += 1
	print("Projectiles spawned: " + str(GameData.projectiles_spawned) + 
	"\nProjectiles killed: " + str(GameData.projectiles_killed) +
	"\nProjectiles alive: " + str(GameData.projectiles_spawned - GameData.projectiles_killed))
	
	# Prepare dialogue.
	SetDialogue()
	
	# Hide HUD:
	hud.play("anim_hud_hide");
	
	# Show dialogue.
	dialogueSystem.show_dialogue()
	dialogueSystem.exit_level = true
	
	# Disable player movement.
	dialogueSystem.player.movement.canMove = false
	
	# Make player inmune to damage:
	dialogueSystem.player.collision.canRecieveDamage = false
	center = true

func CenterPlayer(deltaTime) -> void:
	var player = dialogueSystem.player
	player.global_position = player.global_position.move_toward(Vector2(80, 80), 30 * deltaTime)
