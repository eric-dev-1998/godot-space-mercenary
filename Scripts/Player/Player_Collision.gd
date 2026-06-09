extends Node

class_name PlayerCollision

var player: Player
var area2d: Area2D
var anim: AnimationTree
var damageCooldown: float = 3
var damateTimer: float = 0
var canRecieveDamage: bool = true
var damage_impulse: float = 100

var death_cooldown: float = 4
var death_timer: float = 0
var dead: bool = false

# Called when the node enters the scene tree for the first time.
func _init(player: Player, area: Area2D, anim: AnimationTree) -> void:
	area2d = area
	area2d.area_entered.connect(onCollisionEenter)
	self.anim = anim
	self.player = player

func updateCooldown(delta: float) -> void:
	if !canRecieveDamage:
		if damateTimer >= damageCooldown:
			anim.set("parameters/Motion/conditions/damage", false);
			anim.set("parameters/Motion/conditions/no_damage", true);
			canRecieveDamage = true
			damateTimer = 0
		
		damateTimer += delta

func onCollisionEenter(area: Area2D) -> void:
	if area.get_parent() is Obstacle:
		# Recieve damage
		if canRecieveDamage:
			recieveDamage(false)
	elif area.get_parent() is Projectile:
		var projectileData: Projectile = area.get_parent()
		if projectileData.isEnemy:
			if canRecieveDamage:
				recieveDamage(true)
	elif area.get_parent() is Enemy:
		var enemy = area.get_parent() as Enemy
		enemy.explode()
		if canRecieveDamage:
			recieveDamage(false)
	elif area.is_in_group("Dangerous") or area.is_in_group("Damagables"):
		if canRecieveDamage:
			recieveDamage(false)
		player.global_position.y += 48


func recieveDamage(isProjectile: bool) -> void:
	if dead:
		return
	
	# Apply damage:
	player.health -= 2	
	if player.health <= 0:
		explode()
		return
	
	# Play collision sfx:
	if isProjectile:
		player.sfx_hit.play(0.0)
	else:
		player.sfx_collision.play(0.0)
	
	# Play damage sfx if player is damaged enough:
	if player.health < 6 && player.health > 3:
		player.sfx_damage.play()
		player.sfx_damage_severe.stop()
	elif player.health <= 3:
		player.sfx_damage.stop()
		if !player.sfx_damage_severe.playing:
			player.sfx_damage_severe.play()
	else:
		player.sfx_damage.stop()
		player.sfx_damage_severe.stop()
	
	canRecieveDamage = false
	anim.set("parameters/Motion/conditions/damage", true);
	anim.set("parameters/Motion/conditions/no_damage", false);

func explode() -> void:
	dead = true
	
	player.scale = Vector2.ZERO
	
	# Stop damage sfx:
	player.sfx_damage.stop()
	player.sfx_damage_severe.stop()
	var bgm = player.get_node("/root/Main/BGM") as BGM
	bgm.Stop()
	
	# Stop damage vfx:
	player.smoke.emitting = false
	player.fire.emitting = false
	
	# Hide player ship sprite:
	anim.set("parameters/Motion/conditions/dead", true)
	
	# Play explosion vfx:
	player.explosion.emitting = true
	player.explosion_bits.emitting = true
	
	# Play explosion sfx:
	player.sfx_explosion.play(0.0)
	
	# Stop level movement:
	player.currentLevel.move = false
