extends Node2D

class_name Player

# Player components:
var movement : PlayerMovement
var blast: Player_Blast
var collision: PlayerCollision
var anim: AnimationTree
var sprite: Sprite2D

var currentLevel: LevelContent

# VFX
var smoke: CPUParticles2D
var fire: CPUParticles2D
var explosion: CPUParticles2D
var explosion_bits: CPUParticles2D

# SFX:
var sfx_collision: AudioStreamPlayer2D
var sfx_hit: AudioStreamPlayer2D
var sfx_damage: AudioStreamPlayer2D
var sfx_damage_severe: AudioStreamPlayer2D
var sfx_explosion: AudioStreamPlayer2D
var sfx_engine: AudioStreamPlayer2D
var sfx_boost: AudioStreamPlayer2D
var sfx_brake: AudioStreamPlayer2D

# Hud properties:
var health: int = 10
var health_max: int = 10
var health_bar: ColorRect
var score_label: Label
var local_score: int = 0
var total_score: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = get_node("PlayerSprite")
	health_bar = get_node("/root/Main/CanvasLayer/UI/HUD/Health/Fill")
	score_label = get_node("/root/Main/CanvasLayer/UI/HUD/Score")
	anim = get_node("AnimationPlayer/AnimationTree")
	movement = PlayerMovement.new(anim)
	blast = Player_Blast.new(self)
	collision = PlayerCollision.new(self, get_node("Area2D"), anim)
	currentLevel = get_parent().get_node("Content")
	
	load_vfx()
	load_sfx()

func load_vfx() -> void:
	smoke = get_node("VFX/Particles_Damage")
	fire = get_node("VFX/Particles_Fire")
	explosion = get_node("VFX/Explosion")
	explosion_bits = get_node("VFX/Explosion_Bits")
	
func load_sfx() -> void:
	sfx_hit = get_node("/root/Main/SFX/Player/Hit")
	sfx_collision = get_node("/root/Main/SFX/Player/Collision")
	sfx_damage = get_node("/root/Main/SFX/Player/Damage")
	sfx_damage_severe = get_node("/root/Main/SFX/Player/Damage_Severe")
	sfx_explosion = get_node("/root/Main/SFX/Player/Death")
	sfx_engine = get_node("/root/Main/SFX/Player/Engine_Idle")
	sfx_boost = get_node("/root/Main/SFX/Player/Engine_Boost")
	sfx_brake = get_node("/root/Main/SFX/Player/Engine_Brake")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update_hud_info()
	
	if health < 6 and health > 3:
		smoke.emitting = true
	elif health <= 3 and health >= 1:
		fire.emitting = true
	else:
		smoke.emitting = false
		fire.emitting = false
	
	# Update blast:
	blast._cooldown(delta)
	if collision.canRecieveDamage:
		if movement.canMove:
			blast.fire(position)
	
	# Update movement:
	movement.move(self)
	
	# Update collision:
	collision.updateCooldown(delta)
	
	# Update sfx:
	if health > 3:
		sfx_damage_severe.stop()
	if health > 6:
		sfx_damage.stop()

func update_hud_info() -> void:
	var targetSize: float = 32 * (float(health) / float(health_max))
	health_bar.size.x = int(targetSize)
	
	var score_string = ""
	if local_score < 10:
		score_string = "00" + str(local_score)
	elif local_score > 9 and local_score <= 99:
		score_string = "0" + str(local_score)
	else:
		score_string = str(local_score)
	
	score_label.text = score_string
