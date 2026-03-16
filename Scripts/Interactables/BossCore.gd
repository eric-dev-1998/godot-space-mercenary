extends Node
class_name BossCore

# Most motions will be built into animation clips.

@export var health: int = 100
@export var attack_primary: EnemyAttack
@export var attack_secondary: EnemyAttack
@export var attack_special: EnemyAttack
@export var weak_points: Array[Area2D]
@export var weak_point_health: int = 10
@export var shield: Area2D
@export var shield_health: int = 20
@export var enter_animation: String
@export var stages: Array[BossStage]

var stage: int = -1 # Stage -1 means the boss is wating to be spawned.
var enable_pimary_attack: bool = false
var enable_secondary_attack: bool = false
var enable_special_attack: bool = false
var weak_points_health: Array[int]
var anim: AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check enter animation:
	anim = get_node("Anim")
	if anim == null:
		print("[Boss core]["+ name +"]: No animation player was found.")
		return
	
	if enter_animation == null or enter_animation.length() <= 0:
		print("[Boss core]["+ name +"]: No enter animation was specified.")
		return
	
	# Check attacks:
	if attack_primary == null:
		print("[Boss core]["+ name +"]: No primary attack was defined.")
		return
	if attack_secondary == null:
		print("[Boss core]["+ name +"]: No secondary attack was defined.")
		return
	if attack_special == null:
		print("[Boss core]["+ name +"]: No special attack was defined.")
		return
	
	# Check weak points:
	if len(weak_points) <= 0:
		print("[Boss core]["+ name +"]: No weak points were specified. This enemy boss will take damage from anywhere.")
	else:
		# Check weak points area2d nodes:
		for i in range(0, len(weak_points)):
			if weak_points[i] == null:
				print("[Boss core]["+ name +"]: One or more weak points area2d nodes were not defined.")
				return
		
		# Check weak points health:
		for i in range(0, len(weak_points)):
			if weak_point_health > 0:
				weak_points_health.append(weak_point_health)
			else:
				weak_points_health.append(10)
				print("[Boss core]["+ name +"]: The default weak point health was zero or lower, the health for each weak point will be set to 10.")
	
	# Check shields:
	if shield == null:
		print("[Boss core]["+ name +"]: No shield was defined.")
	else:
		if shield_health <= 0:
			shield = null
			print("[Boss core]["+ name +"]: A shield was specified but the health was set to zero or lower. Shield was deactivated.")
	
	# Check stages:
	if len(stages) <= 0 or stages == null:
		print("[Boss core]["+ name +"]: No stages were defined.")
		return
	else:
		for i in range(0, len(stages)):
			if stages[i] == null:
				print("[Boss core]["+ name +"]: Null boss stage data found at index: " + str(i))
				return
			stages[i].set_parent(self)
			if !stages[i].check():
				print("[Boss core][" + name + "]: A stage did not pass the check.")
				return
	
	print("[Boss core]["+ name +"]: Boss ready.")
	
	spawn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn() -> void:
	# Start boss spawn animation.
	anim.play(enter_animation)

func start() -> void:
	# Called at the end of the boss spawn animation.
	advance_stage()

func weak_point_hit(area: Area2D, index: int) -> void:
	if area.get_parent() is Projectile:
		var p = area.get_parent() as Projectile
		if !p.isEnemy:
			#print("[Boss core]["+ name +"]: Hit on weak point no: " + str(index))
			stages[stage].inflict_wp_damage(p.power, index)
			if stages[stage].check_status():
				# Advance if current stage conditions are met.
				advance_stage()

func shield_hit(area: Area2D) -> void:
	if area.get_parent() is Projectile:
		var p = area.get_parent() as Projectile
		if !p.isEnemy:
			stages[stage].inflict_shield_damage(p.power)
			if stages[stage].check_status():
				advance_stage()

func advance_stage() -> void:
	print("Advanced...")
	
	if stage == len(stages) - 1:
		# It was the last stage, just play advance animation if any and then return.
		if stages[stage].advance_animation.length() != 0:
			anim.play(stages[stage].advance_animation)
	else:
		# Play enter animation if any and if stage is not an wait_for_animation stage.
		if stages[stage].advance_animation.length() != 0 and stages[stage].advance_condition != BossStage.AdvanceCondition.Wait_For_Animation:
			anim.play(stages[stage].advance_animation)
		
		# Advance:
		stage += 1
		stages[stage].trigger()
