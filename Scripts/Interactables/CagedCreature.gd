extends Node

class_name EnemyCore

@export var health: int = 5
@export var health_high: int = 4
@export var health_mid: int = 3
@export var health_low: int = 2 
@export var attack: EnemyAttack
@export var behavior: EnemyBehavior

var invinsible: bool = false

var damage_anim: AnimationPlayer
var damage: CPUParticles2D
var damageMid: CPUParticles2D
var damageSev: CPUParticles2D
var explosion_particles: CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack.parent = get_node(get_path())
	attack.onReady()
	
	behavior.parent = get_node(get_path())
	behavior.parentAttack = attack
	behavior.onReady()
	
	damage_anim = get_node("AnimDamage")
	damage = get_node("Damage")
	damageMid = get_node("DamageMid")
	damageSev = get_node("DamageSevere")
	explosion_particles = get_node("Explosion")

func _process(delta: float) -> void:
	if attack:
		attack.fire(delta)
	
	if behavior:
		behavior.process(delta)

func onBodyHit(area: Area2D) -> void:
	if area.get_parent() is Projectile:
		var p = area.get_parent() as Projectile
		if !p.isEnemy:
			recieveDamage(p)

func spawn() -> void:
	pass

func destroy() -> void:
	var body: Sprite2D = get_node("Body")
	var eye: Sprite2D = get_node("Eye")
	
	body.visible = false
	eye.visible = false
	
	explosion_particles.emitting = true;

func showDamage() -> void:
	if health < health_high and health >= health_mid:
		damage.emitting = true
	elif health < health_mid and health >= health_low:
		damage.emitting = false
		damageMid.emitting = true
	elif health < health_low:
		damageMid.emitting = false
		damageSev.emitting = true

func recieveDamage(projectile: Projectile) -> void:
	projectile.explode()
	
	if invinsible:
		return
	
	if damage_anim.is_playing():
		damage_anim.stop()
	damage_anim.play("anim_miniboss_damaged")  
	
	health -= projectile.power
	showDamage()
	
	if health <= 0:
		destroy()

func onExplosionFinished() -> void:
	queue_free()
