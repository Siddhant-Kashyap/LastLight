class_name PlayerAnimator
extends Node3D

@export var character_model_path: String = "res://assets/models/characters/Character_Male_1.gltf"
@export var model_scale: float = 0.45
## Rotate so character faces +X (right); VisualRoot.scale.x handles left flip
@export var model_rotation_y: float = 90.0
@export var blend_time: float = 0.15
@export var walk_threshold: float = 1.5
@export var run_threshold: float = 4.0
@export var hand_bone: String = "Fist.R"
@export var hand_offset: Vector3 = Vector3(0.0, -0.08, 0.0)

const _LAND_HOLD: float = 0.30

var hand_node: Node3D = null

var _anim: AnimationPlayer = null
var _current: String = ""
var _land_timer: float = 0.0

func _ready() -> void:
	var packed := load(character_model_path)
	if packed == null:
		return
	var model: Node3D = (packed as PackedScene).instantiate()
	model.scale = Vector3.ONE * model_scale
	model.rotation_degrees.y = model_rotation_y
	add_child(model)
	_anim = _find_anim_player(model)
	if _anim == null:
		push_warning("PlayerAnimator: no AnimationPlayer found in %s" % character_model_path)
	else:
		_configure_loops()
		_play("Idle")
	_setup_hand(model)

func _process(delta: float) -> void:
	if _land_timer > 0.0:
		_land_timer -= delta

func update_state(vel: Vector3, on_floor: bool) -> void:
	if _anim == null or _land_timer > 0.0:
		return
	var spd := absf(vel.x)
	if not on_floor:
		_play("Jump" if vel.y > 0.5 else "Jump_Idle")
	elif spd < walk_threshold:
		_play("Idle")
	elif spd < run_threshold:
		_play("Walk")
	else:
		_play("Run")

func on_jumped() -> void:
	if _anim == null:
		return
	_land_timer = 0.0
	_play("Jump")

func on_landed() -> void:
	if _anim == null:
		return
	_land_timer = _LAND_HOLD
	_play("Jump_Land")

func play_hit() -> void:
	_play("HitReact")

func play_death() -> void:
	_play("Death")

const _LOOP_ANIMS: Array[String] = [
	"Idle", "Walk", "Run", "Jump_Idle",
	"Duck", "Idle_Hold", "Idle_Attack", "Run_Hold", "Run_Attack", "Walk_Hold",
]

func _configure_loops() -> void:
	for lib_name: StringName in _anim.get_animation_library_list():
		var lib := _anim.get_animation_library(lib_name)
		for anim_name: StringName in lib.get_animation_list():
			var animation := lib.get_animation(anim_name)
			animation.loop_mode = (
				Animation.LOOP_LINEAR if str(anim_name) in _LOOP_ANIMS
				else Animation.LOOP_NONE
			)

func _play(name: String) -> void:
	if _current == name or _anim == null:
		return
	if not _anim.has_animation(name):
		return
	_current = name
	_anim.play(name, blend_time)

# --- hand attachment ---

func _setup_hand(model: Node3D) -> void:
	# Prefer a named node (rigid-body rigs where each part is a Node3D)
	var target := _find_node_named(model, hand_bone)
	if target != null:
		var offset := Node3D.new()
		offset.name = "HandOffset"
		offset.position = hand_offset
		target.add_child(offset)
		hand_node = offset
		return
	# Fall back to Skeleton3D + BoneAttachment3D (skinned meshes)
	var skeleton := _find_skeleton(model)
	if skeleton == null:
		return
	var bone_idx := skeleton.find_bone(hand_bone)
	if bone_idx == -1:
		push_warning("PlayerAnimator: bone '%s' not found" % hand_bone)
		return
	var attachment := BoneAttachment3D.new()
	attachment.name = "HandAttachment"
	attachment.bone_name = hand_bone
	attachment.bone_idx = bone_idx
	skeleton.add_child(attachment)
	var offset := Node3D.new()
	offset.name = "HandOffset"
	offset.position = hand_offset
	attachment.add_child(offset)
	hand_node = offset

func _find_node_named(node: Node, target_name: String) -> Node3D:
	if node.name == target_name and node is Node3D:
		return node as Node3D
	for child: Node in node.get_children():
		var found := _find_node_named(child, target_name)
		if found != null:
			return found
	return null

func _find_skeleton(node: Node) -> Skeleton3D:
	if node is Skeleton3D:
		return node as Skeleton3D
	for child: Node in node.get_children():
		var found := _find_skeleton(child)
		if found != null:
			return found
	return null

func _find_anim_player(node: Node) -> AnimationPlayer:
	if node is AnimationPlayer:
		return node as AnimationPlayer
	for child: Node in node.get_children():
		var found := _find_anim_player(child)
		if found != null:
			return found
	return null
