class_name CameraController
extends Node3D

signal shake_started
signal shake_finished

@export_group("Follow")
@export var horizontal_speed: float = 8.0
@export var vertical_speed: float = 5.0
@export var vertical_deadzone: float = 1.0

@export_group("Look Ahead")
@export var look_ahead_distance: float = 2.5
@export var look_ahead_speed: float = 3.0

@export_group("Shake")
@export var shake_decay: float = 6.0

var _target: Node3D = null
var _shake_intensity: float = 0.0
var _look_ahead_offset: float = 0.0
var _tracked_y: float = 0.0
var _camera_base_pos: Vector3 = Vector3.ZERO

@onready var _camera: Camera3D = $Camera3D

func _ready() -> void:
	_camera_base_pos = _camera.position
	call_deferred("_find_target")
	Debug.print_info("CameraController ready", "Camera")

func _process(delta: float) -> void:
	if not is_instance_valid(_target):
		return
	_follow_target(delta)
	_apply_shake(delta)

func _find_target() -> void:
	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		_target = players[0] as Node3D
		_snap_to_target()
		Debug.print_info("Camera target: " + _target.name, "Camera")
	else:
		Debug.print_warning("No node in 'player' group found", "Camera")

func _snap_to_target() -> void:
	global_position.x = _target.global_position.x
	global_position.y = _target.global_position.y
	_tracked_y = _target.global_position.y
	_look_ahead_offset = 0.0

func _follow_target(delta: float) -> void:
	var target_pos: Vector3 = _target.global_position

	_look_ahead_offset = lerpf(
		_look_ahead_offset,
		_get_facing_direction() * look_ahead_distance,
		1.0 - exp(-look_ahead_speed * delta)
	)

	var y_diff: float = target_pos.y - _tracked_y
	if absf(y_diff) > vertical_deadzone:
		_tracked_y = lerpf(_tracked_y, target_pos.y, 1.0 - exp(-vertical_speed * delta))

	global_position.x = lerpf(
		global_position.x,
		target_pos.x + _look_ahead_offset,
		1.0 - exp(-horizontal_speed * delta)
	)
	global_position.y = lerpf(
		global_position.y,
		_tracked_y,
		1.0 - exp(-vertical_speed * delta)
	)
	global_position.z = 0.0

func _apply_shake(delta: float) -> void:
	if is_zero_approx(_shake_intensity):
		_camera.position = _camera_base_pos
		return
	_camera.position = _camera_base_pos + Vector3(
		randf_range(-_shake_intensity, _shake_intensity),
		randf_range(-_shake_intensity, _shake_intensity),
		0.0
	)
	_shake_intensity = lerpf(_shake_intensity, 0.0, 1.0 - exp(-shake_decay * delta))
	if _shake_intensity < 0.001:
		_shake_intensity = 0.0
		shake_finished.emit()

func trigger_shake(intensity: float) -> void:
	if is_zero_approx(_shake_intensity) and intensity > 0.0:
		shake_started.emit()
	_shake_intensity = maxf(_shake_intensity, intensity)

func _get_facing_direction() -> float:
	var facing: Variant = _target.get("is_facing_right")
	if facing == null:
		return 0.0
	return 1.0 if bool(facing) else -1.0
