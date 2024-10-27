@tool
extends Area2D
class_name AttackFrameData

@export_category("Buttons")
@export var add_frame_data = false
@export var add_empty_frame_data = false
@export var number_of_hitboxes = 1
@export var reset_frame_data1 = false
@export var reset_frame_data2 = false
@export var show_all : bool : set = ShowAll
@export var hide_all : bool : set = HideAll

@export_category("Stats")
@export var animation_name = "none"
@export var damage = 100
@export var knockback = 1
@export var impact = 1

var in_game_frame_number = 0

var attack_frames = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#change these depending on default hitboxes
	collision_layer = 1
	collision_mask = 1
	
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
	
	print(width)
	print(height)
	
	for child in children:
		print(name + " " + str(child.attack_frame_number))
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

func NextFrame():
	if in_game_frame_number != 0:
		var previous_frame = attack_frames[in_game_frame_number-1]
		for i in range(previous_frame.size()):
			previous_frame[i].visible = false
			
	var current_frame = attack_frames[in_game_frame_number]
	for i in range(current_frame.size()):
		current_frame[i].visible = true
	
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
	hide_all = false

func HideAll(value):
	if value:
		for child in get_children():
			child.visible = false
	hide_all = false
