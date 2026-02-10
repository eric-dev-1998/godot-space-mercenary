extends Node2D

class_name LevelContent

@export var move: bool = false
var speed: int = 40

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move:
		scroll(delta)

func scroll(delta) -> void:
	position.y += speed * delta
