extends Resource
class_name BossStage

enum AdvanceCondition 
{
	Weak_Points,
	Shield,
	Weak_Points_And_Shield,
	Wait_For_Animation,
}
enum AttackType 
{
	Primary,
	Secondary,
	Special
}

# A stage should have its own wp or shield damage counter.

@export var advance_condition: AdvanceCondition
@export var weak_points_afected: Array[int]
@export var attack_type: AttackType
@export var inmmunity: bool = false
@export var animation: String
@export var has_enter_animation = false
@export var enter_animation: String
@export var has_advance_animation = false
@export var advance_animation: String

var parent: BossCore
var wp_health: Array[int]
var shield_health: int

func set_parent(parent: BossCore)-> void:
	self.parent = parent
	
	if advance_condition == AdvanceCondition.Weak_Points or advance_condition == AdvanceCondition.Weak_Points_And_Shield:
		for i in range(len(weak_points_afected)):
			wp_health.append(parent.weak_point_health)
	
	if advance_condition == AdvanceCondition.Shield or advance_condition == AdvanceCondition.Weak_Points_And_Shield:
		shield_health = parent.shield_health

func check() -> bool:
	# Check parent:
	if parent == null:
		print("\t[Boss stage]: Parent is null.")
		return false
	
	if advance_condition == AdvanceCondition.Wait_For_Animation:
		if animation == null or animation.length() <= 0:
			print("\t[Boss stage]: Stage advance condition is set to 'Wait for animation' but no animation was specified.")
			return false
	
	# Check weak points:
	if advance_condition == AdvanceCondition.Weak_Points or advance_condition == AdvanceCondition.Weak_Points_And_Shield:
		if len(weak_points_afected) <= 0:
			print("\t[Boss stage]: Advance condition requires weak points to be destroyed, but no weak points were defined in this stage.")
			return false
	
	print("\t[Boss stage]: Advance condition: " + str(advance_condition) + ".")
	print("\t[Boss stage]: Weak points affected: " + str(weak_points_afected) + ".")
	print("\t[Boss stage]: Attack type: " + str(attack_type) + ".")
	print("\t[Boss stage]: Inmmunity: " + str(inmmunity) + ".")
	print("\t[Boss stage]: Enter animation: " + str(has_enter_animation) + ".")
	print("\t[Boss stage]: Advance animation: " + str(has_advance_animation) + ".")
	
	return true

func check_status() -> bool:
	match advance_condition:
		AdvanceCondition.Weak_Points:
			return check_weak_points()
		AdvanceCondition.Shield:
			return check_shield()
		AdvanceCondition.Weak_Points_And_Shield:
			return check_weak_points() and check_shield()
		AdvanceCondition.Wait_For_Animation:
			pass
	return false

func check_weak_points() -> bool:
	for i in range(len(weak_points_afected)):
		if wp_health[i] >= 1:
			return false
	return true

func check_shield() -> bool:
	if shield_health <= 0:
		return true
	else:
		return false

func inflict_wp_damage(damage: int, weak_point: int) -> void:
	if advance_condition == AdvanceCondition.Weak_Points or advance_condition == AdvanceCondition.Weak_Points_And_Shield:
		wp_health[weak_point] -= damage

func inflict_shield_damage(damage: int) -> void:
	if advance_condition == AdvanceCondition.Shield or advance_condition == AdvanceCondition.Weak_Points_And_Shield:
		shield_health -= damage

func trigger() -> void:
	if advance_condition == AdvanceCondition.Wait_For_Animation:
		# Just play the specified stage animation.
		parent.anim.play(animation)
		pass
	else:
		if has_enter_animation:
			parent.anim.play(enter_animation)
