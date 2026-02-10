extends Control

class_name DialogueSystem

# Dialogue lines properties:
class DialogueLine:	
	var text: String
	var texture
	
	func _init(text: String, texture) -> void:
		self.text = text
		self.texture = texture

# Nodes:
var text: Label
var picture: TextureRect
var anim: AnimationPlayer
var anim_picture: AnimationPlayer
var player: Player

# Dialogue system properties:
var previous_pic: Texture
var lineCounter: int = -1
var show: bool = false
var onEnd;

# Dialogue content:
var lines: Array

func _ready() -> void:
	text = get_node("Text")
	picture = get_node("Picture")
	anim = get_node("AnimationPlayer")
	anim_picture = get_node("Picture/AnimationPlayer")
	player = get_node("/root/Main/Level/Player")

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed():
			if event.keycode == KEY_SPACE:
				if !anim.is_playing() && show:
					anim.play("anim_dialogue_fade")
					
					var pic
					if lineCounter < lines.size() - 1:
						pic = lines[lineCounter + 1].texture
					
					if pic is Texture:
						if pic != previous_pic:
							anim_picture.play("anim_dialogue_picture_fade")
					elif pic is String:
						if pic == "none":
							lines[lineCounter + 1].texture = null
							anim_picture.play("anim_dialogue_picture_fade")
						elif pic == "same":
							return

func _set_dialogue(lines: Array) -> void:
	self.lines = lines
	show = true

func show_dialogue() -> void:
	# Start dialogue:
	
	anim.play("anim_dialogue_fade")
	picture.texture = null
	show = true
	lineCounter = -1
	
	if player != null:
		player.movement.canMove = false
		player.blast.canFire = false

func writeNextLine() -> void:
	# Write the next dialogue line if available:
	if lineCounter >= (lines.size() - 1):
		endDialogue()
	else:
		lineCounter += 1
		text.text = lines[lineCounter].text

func changePicture() -> void:
	picture.texture = lines[lineCounter +1].texture

func endDialogue() -> void:
	# End dialogue:
	
	text.text = ""
	show = false
	
	if player != null:
		player.movement.canMove = true
		player.blast.canFire = true
	
	if onEnd is Callable:
		onEnd.call()
