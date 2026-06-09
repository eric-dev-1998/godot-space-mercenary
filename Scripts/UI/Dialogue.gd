extends Control

class_name DialogueSystem

# Nodes:
var text: Label
var picture: TextureRect
var anim: AnimationPlayer
var anim_picture: AnimationPlayer
var player: Player
var screenFx: Screen_FX
var sfx: AudioStreamPlayer2D
var sfx_end: AudioStreamPlayer2D
var exit_level: bool = false

# Dialogue system properties:
var previous_pic: Texture
var lineCounter: int = -1
var show: bool = false
signal onEnd

# Dialogue content:
var _dialogue_lines: Array[DialogueLine]
var lines: Array
var isAutomatic: bool = false;
var autoDelay: float = 0
var lastPicture: Texture2D

func GoToLevelSelection() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/level_selection.tscn")

func _ready() -> void:
	text = get_node("Text")
	picture = get_node("Picture")
	anim = get_node("AnimationPlayer")
	anim_picture = get_node("Picture/AnimationPlayer")
	player = get_node("/root/Main/Level/Player")
	screenFx = get_node("/root/Main/CanvasLayer/Main_UI/ScreenFX")
	sfx = get_node("SFX")
	sfx_end = get_node("SFX_END")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_SPACE:
				if !anim.is_playing() && show:
					anim.play("anim_dialogue_fade")
					
					if lineCounter < _dialogue_lines.size() - 1:
						var picture: Texture2D = _dialogue_lines[lineCounter + 1].texture
						if picture != null:
							if lastPicture != null and lastPicture.resource_name == picture.resource_name:
								return
							else:
								anim_picture.play("anim_dialogue_picture_fade")
						
func set_dialogue(dialogue: Array[DialogueLine]):
	_dialogue_lines = dialogue

func auto_dialogue_loop() -> void:
	while show and isAutomatic:
		await get_tree().create_timer(autoDelay).timeout
		
		if not show or not isAutomatic:
			break;
		
		anim.play("anim_dialogue_fade")
	endDialogue()
	screenFx.ended.connect(GoToLevelSelection)
	screenFx.play(Screen_FX.FX_Type.Dark_in)

func show_dialogue() -> void:
	# Start dialogue:
	anim.play("anim_dialogue_fade")
	picture.texture = null
	show = true
	lineCounter = -1
	
	if player != null:
		player.movement.canMove = false
		player.blast.canFire = false
	
	if isAutomatic:
		auto_dialogue_loop()

func writeNextLine() -> void:
	# Write the next dialogue line if available:
	if lineCounter >= (_dialogue_lines.size() - 1):
		endDialogue()
	else:
		if lineCounter == -1:
			sfx.play()
		lineCounter += 1
		text.text = _dialogue_lines[lineCounter].text
		exit_level = _dialogue_lines[lineCounter].exit_level
		
		if exit_level:
			sfx_end.connect("finished", GoToLevelSelection)

func changePicture() -> void:
	picture.texture = _dialogue_lines[lineCounter + 1].texture
	lastPicture = picture.texture

func endDialogue() -> void:
	# End dialogue:
	
	text.text = ""
	show = false
	
	if player != null:
		player.movement.canMove = true
		player.blast.canFire = true
	emit_signal("onEnd")
	
	if exit_level:
		screenFx.queue.append(Screen_FX.FX_Type.Dark_in)
	
	sfx_end.play()
