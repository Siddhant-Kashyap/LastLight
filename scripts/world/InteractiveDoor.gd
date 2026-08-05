class_name InteractiveDoor
extends Interactable

@export var door_id: String = "door_01"
@export var is_locked: bool = false
@export var door_height: float = 2.8

var _door_body: StaticBody3D
var _door_shape: CollisionShape3D
var _status_mat: StandardMaterial3D
var _is_open: bool = false
var _is_animating: bool = false
var _open_pos: Vector3
var _closed_pos: Vector3

func _ready() -> void:
	super()
	add_to_group("door_" + door_id)
	prompt_label = "Locked" if is_locked else "Open Door"
	_build()
	_closed_pos = _door_body.position
	_open_pos = _door_body.position + Vector3(0, door_height + 0.4, 0)

func _build() -> void:
	# Interactable detection sphere
	var det := CollisionShape3D.new()
	var sp := SphereShape3D.new()
	sp.radius = 1.6
	det.shape = sp
	add_child(det)

	# Physics door panel (always exists for collision)
	_door_body = StaticBody3D.new()
	_door_body.name = "DoorBody"
	_door_shape = CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(0.18, door_height, 2.2)
	_door_shape.shape = box
	_door_body.add_child(_door_shape)

	# Try gltf asset first, fall back to BoxMesh
	# Door_Closed model: X:±1 W=2, Y:0→4 H=4, Z:0.81→1.0 (thin)
	# Rotate 90° Y → door spans Z, thin in X; scale 0.7 → 2.8m tall
	# X offset -0.634 centers the door panel on X=0 after rotation+scale
	# Y offset -1.4 puts model base at world y=0 (DoorBody is at parent y=1.4)
	var packed := load("res://assets/models/environment/Door_Closed.gltf")
	if packed != null:
		var model := (packed as PackedScene).instantiate()
		model.rotation_degrees.y = 90.0
		model.scale = Vector3(0.7, 0.7, 0.7)
		model.position = Vector3(-0.634, -1.4, 0.0)
		_door_body.add_child(model)
	else:
		var panel := MeshInstance3D.new()
		var bm := BoxMesh.new()
		bm.size = Vector3(0.18, door_height, 2.2)
		panel.mesh = bm
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.18, 0.17, 0.15)
		mat.roughness = 0.52
		mat.metallic = 0.38
		panel.material_override = mat
		_door_body.add_child(panel)

	add_child(_door_body)

	# Status LED strip — always procedural so emission can be controlled
	_status_mat = StandardMaterial3D.new()
	_status_mat.emission_enabled = true
	_status_mat.albedo_color = Color(0.06, 0.02, 0.02)
	_status_mat.emission_energy_multiplier = 1.2
	_set_status_locked(is_locked)

	var status := MeshInstance3D.new()
	var sm := BoxMesh.new()
	sm.size = Vector3(0.06, door_height * 0.85, 0.04)
	status.mesh = sm
	status.position = Vector3(0, 0, 0.5)
	status.material_override = _status_mat
	add_child(status)

func _on_interact(_interactor: Node3D) -> void:
	if is_locked or _is_animating:
		return
	if _is_open:
		close_door()
	else:
		open_door()

func open_door() -> void:
	if _is_open or _is_animating:
		return
	_is_animating = true
	prompt_label = "Close Door"
	_set_status_locked(false)
	var tween := create_tween()
	tween.tween_property(_door_body, "position", _open_pos, 0.80)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(func() -> void:
		_is_open = true
		_is_animating = false
		_door_shape.disabled = true
	)

func close_door() -> void:
	if not _is_open or _is_animating:
		return
	_door_shape.disabled = false
	_is_animating = true
	prompt_label = "Open Door"
	var tween := create_tween()
	tween.tween_property(_door_body, "position", _closed_pos, 0.80)\
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.finished.connect(func() -> void:
		_is_open = false
		_is_animating = false
	)

func unlock() -> void:
	is_locked = false
	prompt_label = "Open Door"
	_set_status_locked(false)

func _set_status_locked(locked: bool) -> void:
	if _status_mat == null:
		return
	_status_mat.emission = Color(0.55, 0.05, 0.02) if locked else Color(0.04, 0.45, 0.12)
