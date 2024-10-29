extends Node2D
class_name AttackHolder
var attacking = false

@export var sprite : Sprite2D

var attack_number = 0
@onready var attacks = get_children()

@export var animation_player : AnimationPlayer
var animation_library = "MeleeAttacks/"

var charging = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_released("attack") and charging:
		set_charge(false)
		print(attacks[attack_number].GetAttackType())
		print(AttackFrameData.AttackType.Charge)
		if attacks[attack_number].GetAttackType() == AttackFrameData.AttackType.Charge:
			print("eajfieoa")
			animation_player.play(animation_library + str(attacks[attack_number].name) + "END")
			NextAttack()
	elif Input.is_action_just_pressed("attack") and not get_attacking():
		animation_player.play(animation_library + str(attacks[attack_number].name))
		set_attack(true)
		if attacks[attack_number].GetAttackType() == AttackFrameData.AttackType.Normal:
			NextAttack()
	
	scale.x = -1 if sprite.flip_h else 1

func NextAttack():
	attack_number += 1
	if attack_number == attacks.size():
		attack_number = 0

func get_attacking() -> bool:
	return attacking

func set_attack(value : bool):
	attacking = value

func set_charge(value : bool):
	charging = value
