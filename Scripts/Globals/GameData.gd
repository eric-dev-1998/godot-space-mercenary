extends Node

class_name GameData

static var score: int = 0
static var lives: int = 0
static var levels_unlocked: int = 0
static var first_dialogue: bool = false

static var projectiles_spawned: int = 0
static var projectiles_killed: int = 0

static func reset_score() -> void:
	score = 0
	lives = 0
	levels_unlocked = 0
	projectiles_spawned = 0
	projectiles_killed = 0
	first_dialogue = false
