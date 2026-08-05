class_name InteractableSwitch
extends Interactable

@export var switch_id: String = "switch_01"
@export var target_door_id: String = ""

var _is_on: bool = false
var _lever_pivot: Node3D
var _status_mat: StandardMaterial3D

func _ready() -> void:
	super()
	prompt_label = "Flip Switch"
	_build()

func _build() -> void:
	# Detection sphere
	var det := CollisionShape3D.new()
	var sp := SphereShape3D.new()
	sp.radius = 1.1
	det.shape = sp
	add_child(det)

	# Housing box
	var housing := MeshInstance3D.new()
	var hm := BoxMesh.new()
	hm.size = Vector3(0.12, 0.42, 0.32)
	housing.mesh = hm
	var h_mat := StandardMaterial3D.new()
	h_mat.albedo_color = Color(0.20, 0.20, 0.23)
	h_mat.roughness = 0.48
	h_mat.metallic = 0.42
	housing.material_override = h_mat
	add_child(housing)

	# Lever pivot
	_lever_pivot = Node3D.new()
	_lever_pivot.name = "LeverPivot"
	_lever_pivot.position = Vector3(0, 0.08, 0.08)
	add_child(_lever_pivot)

	var lever := MeshInstance3D.new()
	var lm := CylinderMesh.new()
	lm.top_radius = 0.022
	lm.bottom_radius = 0.038
	lm.height = 0.25
	lever.mesh = lm
	lever.position.y = 0.125
	var l_mat := StandardMaterial3D.new()
	l_mat.albedo_color = Color(0.32, 0.30, 0.28)
	l_mat.roughness = 0.28
	l_mat.metallic = 0.72
	lever.material_override = l_mat
	_lever_pivot.add_child(lever)

	# Lever knob
	var knob := MeshInstance3D.new()
	var km := SphereMesh.new()
	km.radius = 0.042
	km.height = 0.084
	knob.mesh = km
	knob.position.y = 0.26
	knob.material_override = l_mat
	_lever_pivot.add_child(knob)

	# Status LED
	var led := MeshInstance3D.new()
	var lmesh := SphereMesh.new()
	lmesh.radius = 0.035
	lmesh.height = 0.07
	led.mesh = lmesh
	led.position = Vector3(0, 0.14, 0.17)
	_status_mat = StandardMaterial3D.new()
	_status_mat.albedo_color = Color(0.5, 0.04, 0.02)
	_status_mat.emission_enabled = true
	_status_mat.emission = Color(0.55, 0.04, 0.02)
	_status_mat.emission_energy_multiplier = 1.6
	led.material_override = _status_mat
	add_child(led)

func _on_interact(_interactor: Node3D) -> void:
	_is_on = not _is_on
	_animate_lever()
	_update_led()
	if target_door_id != "":
		_trigger_door()

func _animate_lever() -> void:
	var target_rot := -0.55 if _is_on else 0.55
	var tween := create_tween()
	tween.tween_property(_lever_pivot, "rotation:z", target_rot, 0.22)\
		.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)

func _update_led() -> void:
	if _status_mat == null:
		return
	_status_mat.emission = Color(0.04, 0.55, 0.12) if _is_on else Color(0.55, 0.04, 0.02)

func _trigger_door() -> void:
	var doors := get_tree().get_nodes_in_group("door_" + target_door_id)
	for door: Node in doors:
		if _is_on:
			if door.has_method("unlock"):
				door.call("unlock")
			if door.has_method("open_door"):
				door.call("open_door")
		else:
			if door.has_method("close_door"):
				door.call("close_door")
