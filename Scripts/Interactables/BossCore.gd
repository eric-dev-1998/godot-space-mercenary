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
@export var stages: Array[BossStage]

var stage: int = -1 # Stage -1 means the boss is wating to be spawned.
var enable_pimary_attack: bool = false
var enable_secondary_attack: bool = false
var enable_special_attack: bool = false
var weak_points_health: Array[int]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
			if !stages[i].check():
				return
	
	print("\n[Boss core]["+ name +"]: Boss ready.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn() -> void:
	# Start boss spawn animation.
	pass

func start() -> void:
	# Called at the end of the boss spawn animation.
	pass

func weak_point_hit(area: Area2D, index: int) -> void:
	if area.get_parent() is Projectile:
		var p = area.get_parent() as Projectile
		if !p.isEnemy:
			print("[Boss core]["+ name +"]: Hit on weak point no: " + str(index))
