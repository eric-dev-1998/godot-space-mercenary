extends Node2D

class_name PlayerMovement

var player: Player

# Movement properties:
var sideSpeed: float = 1.5
var forwardSpeed: float = -0.75
var brakeSpeed: float = 0.75
var moveVector: Vector2 = Vector2.ZERO
var canMove = false
var min_x = 4
var max_x = 156
var min_y = 4
var max_y = 156

var animationTree: AnimationTree

func _init(anim: AnimationTree) -> void:
	animationTree = anim

func move(parent: Player) -> void:
	# Side movement:
	if InputManager.isRightPressed and !InputManager.isLeftPressed:
		moveVector.x = sideSpeed
	elif !InputManager.isRightPressed and InputManager.isLeftPressed:
		moveVector.x = -sideSpeed
	else:
		moveVector.x = 0
	
	# Back and forward movement:
	if InputManager.isUpPressed and !InputManager.isDownPressed:
		# Accelerate:
		moveVector.y = forwardSpeed
		
		# Play boost animation:
		animationTree.set("parameters/Motion/conditions/boost", true)
		animationTree.set("parameters/Motion/conditions/idle", false)
		
	elif !InputManager.isUpPressed and InputManager.isDownPressed:
		# Hit the brakes:
		moveVector.y = brakeSpeed
		
		# Play nomal animation:
		animationTree.set("parameters/Motion/conditions/boost", false)
		animationTree.set("parameters/Motion/conditions/idle", true)
	elif !InputManager.isUpPressed and !InputManager.isDownPressed:
		#Stop moving back and forward:
		moveVector.y = 0;
		
		# Play nomal animation:
		animationTree.set("parameters/Motion/conditions/boost", false)
		animationTree.set("parameters/Motion/conditions/idle", true)
	else:
		moveVector.y = 0
		
	#Apply movement:
	if canMove:
		parent.position += moveVector
	
	# Limit position on screen:
	limitPositionOnScreen(parent)

func limitPositionOnScreen(parent) -> void:
	# Check horizontal position:
	if parent.global_position.x > max_x:
		parent.global_position.x = max_x
	if parent.global_position.x < min_x:
		parent.global_position.x = min_x
		
	# Check vertical position:
	if parent.global_position.y > max_y:
		parent.global_position.y = max_y
	if parent.global_position.y < min_y:
		parent.global_position.y = min_y
