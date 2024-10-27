extends Node2D
class_name AttackHolder
var attacking = false

@export var sprite : Sprite2D

var attack_number = 0
@onready var attacks = get_children()

@export var animation_player : AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack") and not get_attacking():
		animation_player.play("MeleeAttacks/" + str(attacks[attack_number].animation_name))
		set_attack_active(true)
		NextAttack()
	
	scale.x = -1 if sprite.flip_h else 1

func NextAttack():
	attack_number += 1
	if attack_number == attacks.size():
		attack_number = 0

func get_attacking() -> bool:
	return attacking

func set_attack_active(value : bool):
	attacking = value
