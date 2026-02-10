extends Node2D

# Main properties:
var health: int = 50
var health_bubble: int = 50
var health_shield: int = 100
var bubble_destroyed: int = 0

# Collision nodes:
var area_body: Area2D
var area_bubble: Area2D

# Sprites:
var sprite_body: Sprite2D
var sprite_bubble: Sprite2D
var sprites_bubble: Array
var sprites_body: Array

# FX:
var particles_fire: CPUParticles2D
var particles_smoke: CPUParticles2D
var particles_bubble: CPUParticles2D
var anim: AnimationPlayer
var anim_body: AnimationPlayer
var anim_bubble: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadColliders()
	loadSprites()
	loadFx()
	loadAnim()

func loadColliders() -> void:
	area_body = get_node("Body/Area2D")
	area_body.area_entered.connect(onHitBody)
	area_bubble = get_node("Bubble/Area2D")
	area_bubble.area_entered.connect(onHitBubble)

func loadSprites() -> void:
	# Get sprite nodes:
	sprite_body = get_node("Body")
	sprite_bubble = get_node("Bubble")
	
	# Load sprites to memory:
	sprites_body.append(preload("res://Sprites/Spaceships/Boss/Boss.png"))
	sprites_body.append(preload("res://Sprites/Spaceships/Boss/Boss_Armored.png"))
	
	sprites_bubble.append(preload("res://Sprites/Spaceships/Boss/Boss_Shield.png"))
	sprites_bubble.append(preload("res://Sprites/Spaceships/Boss/Boss_Shield_Damaged.png"))
	sprites_bubble.append(preload("res://Sprites/Spaceships/Boss/Boss_Shield_Damaged_1.png"))
	sprites_bubble.append(preload("res://Sprites/Spaceships/Boss/Boss_Shield_Damaged_2.png"))

func loadFx() -> void:
	# Load particle effects:
	particles_fire = get_node("FX/Particles_End_FIre")
	particles_smoke = get_node("FX/Particles_Damage")
	particles_bubble = get_node("FX/Particles_ShieldBreak")
	particles_bubble.finished.connect(hideSelf)

func loadAnim() -> void:
	# Load animations:
	anim = get_node("AnimationPlayer")
	anim_body = get_node("Body/AnimationPlayer")
	anim_bubble = get_node("Bubble/AnimationPlayer")

func onHitBubble(a: Area2D) -> void:
	for area in area_bubble.get_overlapping_areas():
		if area.get_parent() is Projectile:
			var p: Projectile = area.get_parent()
			if !p.isEnemy:
				# Handle collision with player blast.
				if !bubble_destroyed:
					damage_bubble(p)

func onHitBody(a: Area2D) -> void:
	for area in area_body.get_overlapping_areas():
		if area.get_parent() is Projectile:
			var p: Projectile = area.get_parent()
			if !p.isEnemy:
				# Handle collision with player blast.
				damage_body(p)

func damage_body(p: Projectile) -> void:
	# Inflict damage to boss main body.
	if health_shield > 0:
		# Body shield is not destroyed yet.
		
		# Inflict damage:
		health_shield -= p.power
		
		if health_shield <= 0:
			# Body shield has ran out of health, must
			# be destroyed.
			pass
		pass
	else:
		# Body shield is gone, inflict damage to boss
		# main body.
		
		# Inflict damage:
		health -= p.power
		
		if health <= 0:
			# Boss has ran out of health. Death sequence
			# must start.
			destroy()
			pass
		pass

func damage_bubble(p: Projectile) -> void:
	# Inflict damage to boss bubble shield.
	health_bubble -= p.power
	
	# Update bubble damage sprite:
	if health_bubble < 40 and health_bubble >= 30:
		sprite_bubble.texture = sprites_bubble[1]
		# Update to bubble shield with some scratches.
		pass
	elif health_bubble < 30 and health_bubble >= 20:
		sprite_bubble.texture = sprites_bubble[2]
		# Update to bubble shield slighly damaged.
		pass
	elif health_bubble < 20:
		sprite_bubble.texture = sprites_bubble[3]
		# Update to bubble shield severly damaged.
		pass
	
	if health_bubble <= 0:
		# Bubble shield health is 0, destroy the bubble 
		# shield.
		destroy_bubble()
		pass

func destroy_bubble() -> void:
	bubble_destroyed += 1
	
	# Play bubble destroy fx:
	particles_bubble.emitting = true;
	
	# Hide bubble and disable its collision.
	sprite_bubble.visible = false
	area_bubble.set_deferred("monitorable", false)
	area_bubble.set_deferred("monitoring", false)

func hideSelf() -> void:
	# Play hide animation if bubble shield is
	# not been broken more than 3 times.
	anim.play("anim_boss_hide")
	pass

func destroy() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
