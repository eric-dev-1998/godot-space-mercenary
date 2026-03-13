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

@export var advance_condition: AdvanceCondition
@export var weak_points_afected: Array[int]
@export var attack_type: AttackType
@export var inmmunity: bool = false
@export var has_enter_animation = false
@export var has_advance_animation = false

func check() -> bool:
	# Check weak points:
	if advance_condition == AdvanceCondition.Weak_Points or advance_condition == AdvanceCondition.Weak_Points_And_Shield:
		if len(weak_points_afected) <= 0:
			print("\t[Boss stage]: Advance condition requires weak points to be destroyed, but no weak points were defined in this stage.")
			return false

	print("\n\t[Boss stage]: Advance condition: " + str(advance_condition) + ".")
	print("\t[Boss stage]: Weak points affected: " + str(weak_points_afected) + ".")
	print("\t[Boss stage]: Attack type: " + str(attack_type) + ".")
	print("\t[Boss stage]: Inmmunity: " + str(inmmunity) + ".")
	print("\t[Boss stage]: Enter animation: " + str(has_enter_animation) + ".")
	print("\t[Boss stage]: Advance animation: " + str(has_advance_animation) + ".")
	
	return true
