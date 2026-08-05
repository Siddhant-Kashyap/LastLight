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

	# Physics door panel
	_door_body = StaticBody3D.new()
	_door_body.name = "DoorBody"
	_door_shape = CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = Vector3(0.18, door_height, 2.2)
	_door_shape.shape = box
	_door_body.add_child(_door_shape)

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

	# Horizontal detail strip on door face
	var strip := MeshInstance3D.new()
	var sm := BoxMesh.new()
	sm.size = Vector3(0.20, 0.08, 2.21)
	strip.mesh = sm
	strip.position.y = 0.6
	var strip_mat := StandardMaterial3D.new()
	strip_mat.albedo_color = Color(0.28, 0.26, 0.24)
	strip_mat.roughness = 0.42
	strip_mat.metallic = 0.62
	strip.material_override = strip_mat
	_door_body.add_child(strip)

	var strip2 := MeshInstance3D.new()
	var sm2 := BoxMesh.new()
	sm2.size = Vector3(0.20, 0.08, 2.21)
	strip2.mesh = sm2
	strip2.position.y = -0.6
	strip2.material_override = strip_mat
	_door_body.add_child(strip2)

	add_child(_door_body)

	# Status light strip — stays fixed at door position
	_status_mat = StandardMaterial3D.new()
	_status_mat.emission_enabled = true
	_status_mat.albedo_color = Color(0.08, 0.02, 0.02)
	_status_mat.emission_energy_multiplier = 1.0
	_set_status_locked(is_locked)

	var status := MeshInstance3D.new()
	var status_mesh := BoxMesh.new()
	status_mesh.size = Vector3(0.22, door_height + 0.04, 0.05)
	status.mesh = status_mesh
	status.position = Vector3(0, 0, 1.12)
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
