extends Control

var icon: TextureRect
var anim: AnimationPlayer
var fx: Screen_FX
var selection: int = 0
var canInteract: bool = true;

# Intro dialogue properties:
var dialogueSystem: DialogueSystem

var intro_dialogue: Array = [
	DialogueSystem.DialogueLine.new("Incomming message from head quarters.", "none"),
	DialogueSystem.DialogueLine.new("Attention to all pilots.", "none"),
	DialogueSystem.DialogueLine.new("This is a serious emergency.", "none"),
	DialogueSystem.DialogueLine.new("The LAB is under attack and suffered severe damages already.", preload("res://Sprites/Dialogues/LAB_Destroyed.png")),
	DialogueSystem.DialogueLine.new("Every pilot in the surounding areas must go and defend.", "same"),
	DialogueSystem.DialogueLine.new("I repeat, this is a serious emergency.", "same"),
	DialogueSystem.DialogueLine.new("All pilots on the surroundng areas must go and defend the LAB.", "same"),
	DialogueSystem.DialogueLine.new("NOW.", "none"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	icon = get_node("Icon")
	fx = get_node("../ScreenFX")
	anim = get_node("AnimationPlayer")
	dialogueSystem = get_node("../Dialogue_Intro")

func _process(delta: float) -> void:
	icon.visible = canInteract

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_UP:
				selectStart()
			if event.keycode == KEY_DOWN:
				selectExit()
			if event.keycode == KEY_SPACE:
				if selection == 0:
					start()
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
		fx.queue.append(Screen_FX.FX_Type.Dark_out)
		
		# Show intro dialogue:
		dialogueSystem.lines = intro_dialogue
		dialogueSystem.onEnd.connect(goToLevelSelection)
		dialogueSystem.show_dialogue()
		
		anim.play("anim_main_title_fade")
		canInteract = false

func exit() -> void:
	# Exit game.
	pass

func goToLevelSelection() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/level_selection.tscn")
