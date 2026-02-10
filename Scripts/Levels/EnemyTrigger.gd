extends Area2D

@export var enemy_group: EnemyGroup
@export var is_enter: bool = false
var alreadyTriggered: bool = false

func onPlayerEnter(area: Area2D) -> void:
	if !alreadyTriggered:
		if is_enter:
			enemy_group.show_enemies()
			alreadyTriggered = true
		else:
			enemy_group.hide_enemies()
