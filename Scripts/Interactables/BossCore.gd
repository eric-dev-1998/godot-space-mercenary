extends Node2D
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
var shieldSprite: Sprite2D

var spawned: bool = false
var level: LevelContent

var _attack: EnemyAttack = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check enter animation:
	anim = get_node("Anim")
	if anim == null:
		print("[Boss core]["+ name +"]: No animation player was found.")
		return
	
	if enter_animation == null or enter_animation.length() <= 0:
		print("[Boss core]["+ name +"]: No enter animation was specified.")
	
	# Check attacks:
	if attack_primary == null:
		print("[Boss core]["+ name +"]: No primary attack was defined.")
		
	if attack_secondary == null:
		print("[Boss core]["+ name +"]: No secondary attack was defined.")
		
	if attack_special == null:
		print("[Boss core]["+ name +"]: No special attack was defined.")
		
	
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
	
	shieldSprite = get_node("Shield")
	
	print("[Boss core]["+ name +"]: Boss ready.")
	
	level = get_node("/root/Main/Level/Content") as LevelContent
	if !level:
		print("No level content node was found.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !spawned:
		if global_position.y >= 80:
			spawn()
			level.stop_movement()
			spawned = true
	
	if _attack != null:
		_attack.fire(delta);
	
	if stages[stage] != null and stages[stage].follow_player:
		if stage <= 0:
			return
		var player = get_node("/root/Main/Level/Player")
		position.x = move_toward(position.x, player.position.x, delta * stages[stage].follow_speed)
	else:
		position.x = move_toward(position.x, 80, delta * 10)

func spawn() -> void:
	# Start boss spawn animation.
	if enter_animation.length() > 0:
		anim.play(enter_animation)
	else:
		print("Advanced from spawn.")
		advance_stage()

func start() -> void:
	# Called at the end of the boss spawn animation.
	print("Advanced from start.")
	advance_stage()

func weak_point_hit(area: Area2D, index: int) -> void:
	if stages[stage].weak_points_afected.size() <= 0:
		return
	
	if area.get_parent() is Projectile:
		var p = area.get_parent() as Projectile
		if !p.isEnemy:
			if stages[stage].wp_health[index] <= 0:
				return;
			
			if stages[stage].advance_condition == BossStage.AdvanceCondition.Weak_Points_And_Shield:
				if stages[stage].shield_health > 0:
					return
			
			# Inflict damage to the weak point and play the hit fx:
			stages[stage].inflict_wp_damage(p.power, index)
			
			var hitfx = weak_points[index].get_parent().get_node("HitFX") as AnimationPlayer
			
			if stages[stage].wp_health[index] <= 0:
				# Play weak point destruction animation.
				var idle_anim = weak_points[index].get_parent().get_node("Idle") as AnimationPlayer
				if idle_anim:
					var tree = idle_anim.get_node("Tree") as AnimationTree
					tree.active = false;
				
				if hitfx.has_animation("destroy"):
					hitfx.play("destroy")
			else:
				# Play weak point hit animation.
				if hitfx.has_animation("damage"):
					hitfx.play("damage")
				
			if stages[stage].check_status():
				# Advance if current stage conditions are met.
				print("Advanced from weak point.")
				advance_stage()

func shield_hit(area: Area2D) -> void:
	if stage < 0:
		return
	
	if stages[stage] == null or stages[stage].advance_condition == BossStage.AdvanceCondition.Weak_Points or stages[stage].advance_condition == BossStage.AdvanceCondition.Wait_For_Animation:
		return
	
	if stages[stage].shield_health <= 0:
		return
	
	if area.get_parent() is Projectile:
		var p = area.get_parent() as Projectile
		if !p.isEnemy:
			stages[stage].inflict_shield_damage(p.power)
			
			# Play shield damage and destroy animation.
			var shieldAnim = shield.get_node("Anim") as AnimationPlayer
			if shieldAnim != null and shieldAnim.has_animation("damage"):
				shieldAnim.play("damage")
				
			var damagePercent = float(stages[stage].shield_health) / float(shield_health)
			if damagePercent < 0.3:
				shieldSprite.texture = stages[stage].shield_damage_textures[3]
			elif damagePercent >= 0.3 and damagePercent < 0.7:
				shieldSprite.texture = stages[stage].shield_damage_textures[2]
			elif damagePercent >= 0.7:
				shieldSprite.texture = stages[stage].shield_damage_textures[1]

			#print(str(shield_health) + "/" + str(stages[stage].shield_health) + " = " + str(damagePercent))
				
			if stages[stage].shield_health <= 0:
				if stages[stage].advance_condition == BossStage.AdvanceCondition.Shield:
					anim.play("shield_destroy")
				elif stages[stage].advance_condition == BossStage.AdvanceCondition.Weak_Points_And_Shield:
					anim.play("shield_destroy_noadvance")
			
			if stages[stage].check_status():
				print("Advanced from shield.")
				advance_stage()

func advance_stage() -> void:
	print("Advanced...")
	
	if stage == len(stages) - 1:
		# It was the last stage, just play advance animation if any and then return.
		if stages[stage].advance_animation.length() != 0:
			anim.play(stages[stage].advance_animation)
		else:
			advance_level()
	else:
		# Play enter animation if any and if stage is not an wait_for_animation stage.
		if stages[stage].advance_animation.length() != 0 and stages[stage].advance_condition != BossStage.AdvanceCondition.Wait_For_Animation:
			anim.play(stages[stage].advance_animation)
		
		# Advance:
		stage += 1
		
		# Load stage attack data:
		match stages[stage].attack_type:
			BossStage.AttackType.None: _attack = null
			BossStage.AttackType.Primary: _attack = attack_primary
			BossStage.AttackType.Secondary: _attack = attack_secondary
			BossStage.AttackType.Special: _attack = attack_special
		
		if _attack != null and _attack.parent_node == null:
			_attack.parent_node = get_node(get_path())
		
		# Reset shield texture if any:
		if len(stages[stage - 1].shield_damage_textures) > 0:
			shieldSprite.texture = stages[stage - 1].shield_damage_textures[0]
		
		# Reset weak points animations:
		if stages[stage].weak_points_afected.size() > 0:
			for wp in weak_points:
				var hitfx = wp.get_parent().get_node("HitFX") as AnimationPlayer
				hitfx.play("RESET");
				
				# Play weak point destruction animation.
				var idle_anim = wp.get_parent().get_node("Idle") as AnimationPlayer
				if idle_anim:
					var tree = idle_anim.get_node("Tree") as AnimationTree
					tree.active = true
		
		if _attack != null and !_attack.spawn_randomly_over_x:
			_attack.load()
			_attack.parent_node = get_parent().get_node(get_path())
		
		stages[stage].trigger()

func advance_level() -> void:
	level.resume_movement()
	queue_free()
