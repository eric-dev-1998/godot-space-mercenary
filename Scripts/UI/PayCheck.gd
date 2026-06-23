extends Node

@export var score: Label
@export var money: Label
@export var screen_fx: Screen_FX

func _ready() -> void:
	score.text = str(GameData.score)
	money.text = "$" + str(GameData.score * 10.75)

func _process(delta: float) -> void:
	if InputManager.isAnyPressed:
		# Go back to main screen.
		screen_fx.queue.append(Screen_FX.FX_Type.Dark_in)
		screen_fx.ended.connect(go_back_to_main)

func go_back_to_main():
	GameData.reset_score()
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
