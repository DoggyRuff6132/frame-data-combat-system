@tool
extends AttackFrameData
class_name ChargeAttackFrameData

var damage_multiplier = 0.5
var knockback_multiplier = 0.5
var impact_multiplier = 0.5

# x = initial + (initial * multiplier * charge_level)
func get_damage() -> int:
	var init_damage = super.get_damage()
	return round(init_damage + init_damage * damage_multiplier * floor(current_charge_level))
func get_knockback() -> int:
	var init_knockback = super.get_knockback()
	return round(init_knockback + init_knockback * knockback_multiplier * floor(current_charge_level))
func get_impact() -> int:
	var init_impact = super.get_impact()
	return round(init_impact + init_impact * impact_multiplier * floor(current_charge_level))

@export var max_charge_level : int = 1

var current_charge_level : int = 0

func AddCharge():
	current_charge_level += 1

#override
func ResetFrameNumber():
	super()
	current_charge_level = 0
