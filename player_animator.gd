extends Node2D

@export var player : Player
@onready var animation_player : AnimationPlayer = $AnimationPlayer
@export var attack_holder : AttackHolder
@onready var sprite : Sprite2D = $Sprite2D

const jump_deadzone = 0.1
var just_finished_anim := ""
var played_jump_trans = false
var played_fall_trans = false

func _process(delta: float) -> void:
	if !attack_holder.attacking:
		if player.direction == 1:
			sprite.flip_h = false
		elif player.direction == -1:
			sprite.flip_h = true
	
	if not attack_holder.get_attacking():
		if player.velocity.y < -jump_deadzone:
			if not played_jump_trans:
				animation_player.play("Movement/JumpTrans")
			else:
				animation_player.play("Movement/JumpLoop")
		elif player.velocity.y > jump_deadzone:
			if not played_fall_trans:
				animation_player.play("Movement/FallTrans")
			else:
				animation_player.play("Movement/FallLoop")
		elif abs(player.velocity.x) > 0.0:
			animation_player.play("Movement/Run")
		else:
			animation_player.play("Movement/Idle")
	
	if player.velocity.y > -jump_deadzone and player.velocity.y < jump_deadzone:
		played_jump_trans = false
		played_fall_trans = false
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Movement/JumpTrans":
		played_jump_trans = true
	if anim_name == "Movement/FallTrans":
		played_fall_trans = true
