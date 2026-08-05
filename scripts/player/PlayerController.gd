class_name PlayerController
extends CharacterBody3D

signal jumped(is_double_jump: bool)
signal landed
signal started_falling
signal facing_changed(facing_right: bool)

enum LocomotionState { IDLE, RUNNING, JUMPING, FALLING }

@export_group("Movement")
@export var move_speed: float = 6.0
@export var ground_acceleration: float = 60.0
@export var ground_deceleration: float = 80.0
@export var air_acceleration: float = 35.0
@export var air_deceleration: float = 20.0

@export_group("Jump")
@export var jump_velocity: float = 9.0
@export var gravity: float = 30.0
@export var max_fall_speed: float = 20.0
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12
@export var jump_cut_multiplier: float = 0.4
@export var enable_double_jump: bool = true

var locomotion_state: LocomotionState = LocomotionState.IDLE
var is_facing_right: bool = true

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0
var _air_jumps_used: int = 0
var _was_on_floor: bool = false
var _locked_z: float = 0.0

@onready var _visual_root: Node3D = $VisualRoot
@onready var _animator: PlayerAnimator = $VisualRoot/CharacterMesh

func _ready() -> void:
	_locked_z = global_position.z
	add_to_group("player")
	jumped.connect(func(_double: bool) -> void: _animator.on_jumped())
	landed.connect(_animator.on_landed)
	_attach_lantern_to_hand()
	Debug.print_info("PlayerController ready", "Player")

func _physics_process(delta: float) -> void:
	if global_position.y < Constants.KILL_PLANE_Y:
		CheckpointManager.respawn_player()
		return
	_update_timers(delta)
	_apply_gravity(delta)
	_handle_jump()
	_apply_horizontal_movement(delta)
	_apply_depth_constraint()
	move_and_slide()
	global_position.z = _locked_z
	_handle_floor_state_change()
	_update_locomotion_state()
	_animator.update_state(velocity, is_on_floor())

func _update_timers(delta: float) -> void:
	if is_on_floor():
		_coyote_timer = coyote_time
	elif _coyote_timer > 0.0:
		_coyote_timer -= delta
	if _jump_buffer_timer > 0.0:
		_jump_buffer_timer -= delta

func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		if velocity.y < 0.0:
			velocity.y = 0.0
		return
	velocity.y = maxf(velocity.y - gravity * delta, -max_fall_speed)

func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time

	if Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y *= jump_cut_multiplier

	if _jump_buffer_timer > 0.0:
		if _coyote_timer > 0.0:
			_execute_jump(false)
		elif enable_double_jump and _air_jumps_used < 1:
			_execute_jump(true)

func _execute_jump(is_double: bool) -> void:
	velocity.y = jump_velocity
	_jump_buffer_timer = 0.0
	_coyote_timer = 0.0
	if is_double:
		_air_jumps_used += 1
		Debug.print_info("Double jump", "Player")
	else:
		Debug.print_info("Jumped", "Player")
	jumped.emit(is_double)

func _apply_horizontal_movement(delta: float) -> void:
	var input_x: float = Input.get_axis("move_left", "move_right")
	var accel: float = ground_acceleration if is_on_floor() else air_acceleration
	var decel: float = ground_deceleration if is_on_floor() else air_deceleration
	if not is_zero_approx(input_x):
		velocity.x = move_toward(velocity.x, input_x * move_speed, accel * delta)
		_update_facing(input_x > 0.0)
	else:
		velocity.x = move_toward(velocity.x, 0.0, decel * delta)

func _apply_depth_constraint() -> void:
	velocity.z = 0.0

func _handle_floor_state_change() -> void:
	var on_floor: bool = is_on_floor()
	if on_floor and not _was_on_floor:
		_air_jumps_used = 0
		landed.emit()
		Debug.print_info("Landed", "Player")
	elif not on_floor and _was_on_floor and velocity.y < 0.0:
		started_falling.emit()
	_was_on_floor = on_floor

func _update_locomotion_state() -> void:
	if not is_on_floor():
		locomotion_state = LocomotionState.JUMPING if velocity.y > 0.0 else LocomotionState.FALLING
	elif not is_zero_approx(velocity.x):
		locomotion_state = LocomotionState.RUNNING
	else:
		locomotion_state = LocomotionState.IDLE

func _attach_lantern_to_hand() -> void:
	var lantern := $Lantern as Node3D
	# Reparent under VisualRoot so it flips with facing direction (scale.x)
	lantern.reparent(_visual_root, false)
	# x: side offset, y: hand height (~56% of 1.28m character), z: toward camera
	lantern.position = Vector3(0.13, 0.72, 0.04)
	lantern.rotation = Vector3.ZERO
	lantern.scale = Vector3.ONE

func _update_facing(facing_right: bool) -> void:
	if is_facing_right == facing_right:
		return
	is_facing_right = facing_right
	if is_instance_valid(_visual_root):
		_visual_root.scale.x = 1.0 if facing_right else -1.0
	facing_changed.emit(facing_right)
