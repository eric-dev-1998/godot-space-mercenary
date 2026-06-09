extends Node

@onready var screen_fx: Screen_FX = $CanvasLayer/Main_UI/ScreenFX
var advance: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if not advance and InputManager.isSpacePressed:
		advance = true
		screen_fx.ended.connect(go_to_main_screen, CONNECT_ONE_SHOT)
		
		screen_fx.queue.append(Screen_FX.FX_Type.Dark_in)

func go_to_main_screen() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://Scenes/main.tscn")
