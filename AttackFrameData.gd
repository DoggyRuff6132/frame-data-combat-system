@tool
extends Area2D
class_name AttackFrameData

@export var attack_type : AttackType

@export_category("Buttons")
@export var add_frame_data = false
@export var add_empty_frame_data = false
@export var number_of_hitboxes = 1
@export var reset_frame_data1 = false
@export var reset_frame_data2 = false
@export var show_all : bool : set = ShowAll
@export var hide_all : bool : set = HideAll

@export_category("Stats")
@export var damage : int = 100
@export var knockback : int = 1
@export var impact : int = 1

func get_damage() -> int:
	return round(damage)
func get_knockback() -> int:
	return round(knockback)
func get_impact() -> int:
	return round(impact)


var in_game_frame_number = 0

var attack_frames = []
var already_attacked = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#change these depending on default hitboxes
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_layer_value(3, true)
	set_collision_mask_value(6, true)
	
	for child in get_children():
		child.disabled = true
	
	in_game_frame_number = 0
	
	SetAttackFrameArray()
	
func SetAttackFrameArray():
	var children = get_children()
	attack_frames.clear()
	
	var width = -1
	var height = -1
	for child in children:
		if width < child.attack_frame_number:
			width = child.attack_frame_number
		if height < child.hitbox_number:
			height = child.hitbox_number
	
	#make 2d array
	for i in width+1:
		attack_frames.append([])
	
	for child in children:
		attack_frames[child.attack_frame_number].insert(child.hitbox_number, child)
		child.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if add_frame_data:
			attack_frames.append(AddFrameData())
			RenameAllNodes()
		elif add_empty_frame_data:
			attack_frames.append(AddFrameData())
			RenameAllNodes()
		elif reset_frame_data1 and reset_frame_data2:
			attack_frames.clear()
			for child in get_children():
				child.queue_free()
			reset_frame_data1 = false
			reset_frame_data2 = false
	
	

func ResetFrameNumber():
	in_game_frame_number = 0
	already_attacked.clear()

func NextFrame():
	if in_game_frame_number != 0:
		var previous_frame = attack_frames[in_game_frame_number-1]
		for i in range(previous_frame.size()):
			var hitbox = previous_frame[i]
			hitbox.visible = false
			hitbox.disabled = true
			
	var current_frame = attack_frames[in_game_frame_number]
	for i in range(current_frame.size()):
		var hitbox = current_frame[i]
		hitbox.visible = true
		hitbox.disabled = false
	
	in_game_frame_number += 1

func AddFrameData() -> Array:
	var colliders = []
	
	var loop_range = number_of_hitboxes if add_frame_data else 1
	
	for i in range(loop_range):
		var frame_collider := AttackFrameDataCollider.new()
		add_child(frame_collider)
		frame_collider.set_owner(get_tree().get_edited_scene_root())
		colliders.append(frame_collider)
		
		frame_collider.attack_frame_number = attack_frames.size()
		
		if add_frame_data:
			frame_collider.shape = CapsuleShape2D.new()
			frame_collider.debug_color = "ff000050"
			frame_collider.hitbox_number = colliders.size()
			print("Created " + str(number_of_hitboxes) + " Frame Data")
		elif add_empty_frame_data:
			print("Created Empty Frame Data")
		
	add_frame_data = false
	add_empty_frame_data = false
	return colliders

func RemoveFrame(frame : int, hitbox : int):
	if hitbox == -1:
		for hitbox_frame in attack_frames[frame]:
			hitbox_frame.queue_free()
		
		attack_frames.remove_at(frame)
		
		
	else:
		attack_frames[frame][hitbox].queue_free()
		attack_frames[frame].remove_at(hitbox)
		if attack_frames[frame].size() == 0:
			attack_frames.remove_at(frame)
	
	RenameAllNodes()
	
	print("Removed Frame " + str(frame) + ", other elements renamed to match new indices")

func RenameAllNodes():
	for i in range(attack_frames.size()):
		for j in range(attack_frames[i].size()):
			var hbx_frame = attack_frames[i][attack_frames[i].size()-j-1]
			hbx_frame.attack_frame_number = i
			hbx_frame.hitbox_number = attack_frames[i].size()-j-1
			hbx_frame.call_deferred("rename", attack_frames[i].size())

func ReorderAllNodes():
	var tree_index = 0
	for i in range(attack_frames.size()):
		for j in range(attack_frames[i].size()):
			move_child(attack_frames[i][j], tree_index)
			tree_index += 1

func InsertFrameBefore(frame : int):
	add_frame_data = true
	number_of_hitboxes = 1
	attack_frames.insert(frame, AddFrameData())
	RenameAllNodes()
	ReorderAllNodes()

func InsertFrameAfter(frame : int):
	add_frame_data = true
	number_of_hitboxes = 1
	attack_frames.insert(frame+1, AddFrameData())
	RenameAllNodes()
	ReorderAllNodes()

func InsertHitboxBefore(frame : int, hitbox : int):
	add_frame_data = true
	number_of_hitboxes = 1
	attack_frames[frame].insert(hitbox, AddFrameData()[0])
	RenameAllNodes()
	ReorderAllNodes()

func InsertHitboxAfter(frame : int, hitbox : int):
	add_frame_data = true
	number_of_hitboxes = 1
	attack_frames[frame].insert(hitbox+1, AddFrameData()[0])
	RenameAllNodes()
	ReorderAllNodes()

func ShowAll(value):
	if value:
		for child in get_children():
			child.visible = true
			child.disabled = false
	show_all = false

func HideAll(value):
	if value:
		for child in get_children():
			child.visible = false
			child.disabled = true
	hide_all = false

func AlreadyAttackedBody(body, multi_hit_number) -> bool:
	if already_attacked.size() > multi_hit_number:
		for target in already_attacked[multi_hit_number]:
			if body == target:
				return true
		
		already_attacked[multi_hit_number].append(body)
	else:
		already_attacked.append([body])
	
	print(name + " did " + str(get_damage()) + " to body: "+ str(body))
	return false

#region check attack type
enum AttackType{
	Normal,
	Charge
}

func GetAttackType() -> AttackType:
	return attack_type
#endregion
