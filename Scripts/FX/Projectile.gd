extends Node2D

class_name Projectile

@export var power: int = 1
@export var isEnemy: bool = false
@export var isExplosive: bool = false;
@export var speed: float = 4
var timeToAutoDestruction: float = 3
var timer: float = 0
var fx_hit
var area: Area2D
var sprite: Sprite2D
var sfx: AudioStreamPlayer2D

func _ready() -> void:
	GameData.projectiles_spawned += 1
	
	area = get_node("Area2D")
	sprite = get_node("Sprite")
	fx_hit = preload("res://Scenes/FX/scene_fx_hit.tscn")
	
	sfx = get_node("AudioStreamPlayer2D")

func _process(delta: float) -> void:
	if !isEnemy:
		position.y -= speed
	else:
		position.y += speed
	
	if global_position.y >= 170 or global_position.y <= -10:
		GameData.projectiles_killed += 1
		queue_free()

func setPosition(position) -> void:
	self.position = Vector2(position.x, position.y + 6)

func collide(body: Area2D) -> void:
	for a in area.get_overlapping_areas():
		if a.get_parent().is_in_group("Damagables"):
			var hit = fx_hit.instantiate()
			var hit_object: Hit = hit as Hit
			hit.position = position
			get_parent().add_child(hit)
			hit_object.play_sfx(2)
			GameData.projectiles_killed += 1
			queue_free()
			return
		
		# Player can damage itself with its own projectiles.
		if a.get_parent() is Player and !isEnemy:
			return
		
		if a.get_parent() is Enemy:
			# An enemy cannot damage another enemy.
			if isEnemy:
				return
			else:
				var enemy = a.get_parent() as Enemy
				
				# An enemy should not get hurt when is out of the screen.
				if enemy.is_out_of_screen():
					return;
				else:
					var hit = fx_hit.instantiate()
					var hit_object: Hit = hit as Hit
					hit.position = position
					get_parent().add_child(hit)
					hit_object.play_sfx(2)
					GameData.projectiles_killed += 1
					queue_free()
					return;
		
		if a.get_parent() is Obstacle:
			var obstacle = a.get_parent() as Obstacle
			
			# An obstacle should detect hit when its out of the screen.
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
				
				GameData.projectiles_killed += 1
				queue_free()
				return
		
		if a.get_parent() is Rocket:
			var hit = fx_hit.instantiate()
			var hit_object: Hit = hit as Hit
			hit.position = position
			get_parent().add_child(hit)
			hit_object.play_sfx(2)
			GameData.projectiles_killed += 1
			queue_free()
			return
		
		if a.get_parent().name == "Body":
			return
		
		explode(1)

func explode(sfx_index: int) -> void:
	GameData.projectiles_killed += 1
	
	if !isExplosive:
		var hit = fx_hit.instantiate()
		var hit_object: Hit = hit as Hit
		hit.position = position
		get_parent().add_child(hit)
		hit_object.play_sfx(sfx_index)
		queue_free()
	else:
		sprite.visible = false
		
		sfx.play()
		
		var particles = get_node("Particles") as CPUParticles2D
		particles.emitting = true
		
		var area = get_node("Area2D") as Area2D
		area.set_deferred("monitoring", false)
		area.set_deferred("monitorable", false)
