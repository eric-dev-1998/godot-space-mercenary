extends Node

class_name BGM

var intro: AudioStreamPlayer
var loop: AudioStreamPlayer

@export var introAudio: AudioStream
@export var loopAudio: AudioStream

func Start() -> void:
	intro = get_node("Intro");
	loop = get_node("Loop");
	
	if introAudio == null or loopAudio == null:
		print("Intro or loop audio is null.")
		return
	
	intro.stream = introAudio
	loop.stream = loopAudio
	
	intro.play(0.0)
	await intro.finished
	loop.play()
