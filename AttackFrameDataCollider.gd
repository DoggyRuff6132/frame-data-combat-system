@tool
extends CollisionShape2D
class_name AttackFrameDataCollider

@export var attack_frame_number : int #if there are multiple active frames. 
@export var multi_hit_number : int #one attack can damage multiple times, this is an identifier
@export var hit_priority : int = 100 #if two attack frames hit at the same time, higher hit priority does damage
@export var hitbox_number : int # if one active frame has multiple hitboxes.

@export_category("buttons")
@export var remove_frame: bool : set = set_remove_frame
@export var insert_frame_before: bool: set = set_insert_frame_before
@export var insert_frame_after: bool: set = set_insert_frame_after
@export var insert_hitbox_before: bool: set = set_insert_hitbox_before
@export var insert_hitbox_after: bool: set = set_insert_hitbox_after
@export var show_all : bool : set = ShowAll
@export var hide_all : bool : set = HideAll

@export_category("Stats")
@export var damage_multiplier = 1
@export var knockback_multiplier = 1
@export var impact_multiplier = 1
#@export var debuff


func _ready():
	get_parent().body_entered.connect(hit_enemy_with_attack)


func hit_enemy_with_attack(enemy):
	get_parent().AlreadyAttackedBody(enemy, multi_hit_number)

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

func ShowAll(value):
	get_parent().ShowAll(value)

func HideAll(value):
	get_parent().HideAll(value)
