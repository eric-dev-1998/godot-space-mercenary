extends Resource
class_name EnemyBehavior

enum BehaviorType {
	Still,
	Follow,
	Follow_Protect,
	Follow_Fire_Protect
}

@export var type: BehaviorType = BehaviorType.Still
@export var followSpeed: float = 1.0
@export var timeToStop: float = 5.0
@export var stopCooldown: float = 3.0

var parent: EnemyCore
var parentAttack: EnemyAttack
var stop: bool = false
var moveTimer: float = 0.0
var stopCooldownTimer: float = 0.0

# Called when the node enters the scene tree for the first time.
func onReady() -> void:
	if type == BehaviorType.Follow:
		parent.attack.autoFire = true
	elif type == BehaviorType.Follow_Protect:
		parent.attack.autoFire = true
		parent.attack.autoProtect = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process(delta: float) -> void:
	match type:
		EnemyBehavior.BehaviorType.Still:
			behave_still()
		EnemyBehavior.BehaviorType.Follow:
			behave_follow(delta)
		EnemyBehavior.BehaviorType.Follow_Protect:
			behave_follow(delta)
		EnemyBehavior.BehaviorType.Follow_Fire_Protect:
			behave_follow_and_stop(delta, true)

func behave_still() -> void:
	pass

func behave_follow(delta: float) -> void:
	follow(delta)

func behave_follow_and_stop(delta: float, protect: bool) -> void:
	if !stop:
		follow(delta)
		
		moveTimer += delta
		if moveTimer >= timeToStop:
			moveTimer = 0.0
			stop = true
			if protect:
				parent.invinsible = true
			parentAttack.canFire = true
	else:
		stopCooldownTimer += delta
		if stopCooldownTimer >= stopCooldown:
			stopCooldownTimer = 0.0
			stop = false
			if protect:
				parent.invinsible = false

func follow(delta: float) -> void:
	var player: Node2D = parent.get_node("/root/Main/Level/Player")
	if player == null:
		print("No player node was found.")
		type = BehaviorType.Still
		
	var targetPosition = Vector2(player.global_position.x, parent.global_position.y)
	parent.global_position = parent.position.move_toward(targetPosition, delta * followSpeed)
