class_name InteractionDetector
extends Area3D

# Uses Area3D as the base type and duck-typing so there is no compile-time
# dependency on Interactable — Godot only compiles scene-linked scripts in
# headless mode, so class_name resolution order is not guaranteed.

signal interactable_focused(interactable: Area3D, label: String)
signal interactable_unfocused

var _nearby: Array[Area3D] = []
var _current: Area3D = null

func _ready() -> void:
	collision_layer = 0
	collision_mask = 1 << (Constants.INTERACTION_LAYER - 1)
	monitoring = true
	monitorable = false
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	Debug.print_info("InteractionDetector ready", "Interaction")

func _process(_delta: float) -> void:
	_update_focus()
	if UIManager.is_ui_open("dialogue"):
		return
	if Input.is_action_just_pressed("interact"):
		try_interact()

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("interactable"):
		_nearby.append(area)

func _on_area_exited(area: Area3D) -> void:
	_nearby.erase(area)
	if _current == area:
		_clear_focus()
		_update_focus()

func _update_focus() -> void:
	var nearest: Area3D = _find_nearest_enabled()
	if nearest == _current:
		return
	if is_instance_valid(_current):
		_current.call("on_unfocused")
		interactable_unfocused.emit()
	_current = nearest
	if is_instance_valid(_current):
		_current.call("on_focused")
		interactable_focused.emit(_current, str(_current.get("prompt_label")))

func _clear_focus() -> void:
	if is_instance_valid(_current):
		_current.call("on_unfocused")
		interactable_unfocused.emit()
	_current = null

func _find_nearest_enabled() -> Area3D:
	var nearest: Area3D = null
	var nearest_dist: float = INF
	for item in _nearby:
		if not is_instance_valid(item) or not bool(item.get("is_enabled")):
			continue
		var dist: float = global_position.distance_squared_to(item.global_position)
		if dist < nearest_dist:
			nearest_dist = dist
			nearest = item
	return nearest

func try_interact() -> void:
	if is_instance_valid(_current) and bool(_current.get("is_enabled")):
		_current.call("interact", get_parent())

func has_interactable() -> bool:
	return is_instance_valid(_current)

func get_current_interactable() -> Area3D:
	return _current
