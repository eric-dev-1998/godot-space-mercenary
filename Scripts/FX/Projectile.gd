extends Node2D

class_name Projectile

@export var power: int = 1
@export var isEnemy: bool = false
var speed: float = 4
var timeToAutoDestruction: float = 3
var timer: float = 0
var fx_hit
var area: Area2D
var sprite: Sprite2D
var sprite_upgraded
var sfx: AudioStreamPlayer2D

func _ready() -> void:
	sprite_upgraded = load("res://Sprites/Blasts/blast_upgraded.png")
	
	area = get_node("Area2D")
	sprite = get_node("Sprite")
	fx_hit = preload("res://Scenes/FX/scene_fx_hit.tscn")
	sfx = get_node("AudioStreamPlayer2D")

func _process(delta: float) -> void:
	if !isEnemy:
		position.y -= speed
	else:
		position.y += speed
	
	timer += delta
	if timer >= timeToAutoDestruction:
		queue_free()

func setPosition(position) -> void:
	self.position = Vector2(position.x, position.y + 6)

func collide(body: Area2D) -> void:
	for a in area.get_overlapping_areas():
		if a.get_parent() is Player and !isEnemy:
			return;
		if a.get_parent() is Enemy:
			if isEnemy:
				return
			else:
				var enemy = a.get_parent() as Enemy
				if enemy.is_out_of_screen():
					return;
				else:
					var hit = fx_hit.instantiate()
					var hit_object: Hit = hit as Hit
					hit.position = position
					get_parent().add_child(hit)
					hit_object.play_sfx(2)
					queue_free()
		
		if a.get_parent() is Obstacle:
			var obstacle = a.get_parent() as Obstacle
			if obstacle.is_out_of_screen():
				return;
			else:
				var hit = fx_hit.instantiate()
				var hit_object: Hit = hit as Hit
				hit.position = position
				get_parent().add_child(hit)
				if obstacle.solid:
					hit_object.play_sfx(1)
				else:
					hit_object.play_sfx(0)
				
				queue_free()
