@tool
extends CollisionShape2D
class_name AttackFrameDataCollider

@export var attack_frame_number : int
@export var hitbox_number : int

@export_category("buttons")
@export var remove_frame: bool : set = set_remove_frame
@export var insert_frame_before: bool: set = set_insert_frame_before
@export var insert_frame_after: bool: set = set_insert_frame_after
@export var insert_hitbox_before: bool: set = set_insert_hitbox_before
@export var insert_hitbox_after: bool: set = set_insert_hitbox_after

@export_category("Stats")
@export var damage_multiplier = 1
@export var knockback_multiplier = 1
@export var impact_multiplier = 1
#@export var debuff

#var attack_frame_data_parent

func set_remove_frame(value):
	if value == true:
		get_parent().RemoveFrame(attack_frame_number, hitbox_number)
		remove_frame = false

func set_insert_frame_before(value):
	if value == true:
		get_parent().InsertFrameBefore(attack_frame_number)
		insert_frame_before = false

func set_insert_frame_after(value):
	if value == true:
		get_parent().InsertFrameAfter(attack_frame_number)
		insert_frame_after = false

func set_insert_hitbox_before(value):
	if value == true:
		get_parent().InsertHitboxBefore(attack_frame_number, hitbox_number)
		insert_hitbox_before = false

func set_insert_hitbox_after(value):
	if value == true:
		get_parent().InsertHitboxAfter(attack_frame_number, hitbox_number)
		insert_hitbox_after = false

func rename(total_hitboxes : int):
	var node_name = str(attack_frame_number) + "-"
	if shape == null:
		node_name += "empty"
	elif total_hitboxes == 1:
		node_name += "single_frame"
	else:
		node_name += "frame_" + str(hitbox_number)
	
	name = node_name
