class_name Checkpoint
extends Area3D

@export var checkpoint_id: String = "checkpoint_01"

@onready var _mesh: MeshInstance3D = $MeshInstance3D

var _material: StandardMaterial3D
var _activated: bool = false

func _ready() -> void:
	collision_layer = 0
	collision_mask = 1 << (Constants.PLAYER_LAYER - 1)
	monitoring = true
	monitorable = false
	body_entered.connect(_on_body_entered)

	_material = StandardMaterial3D.new()
	_material.emission_enabled = true
	_set_inactive_look()
	_mesh.material_override = _material

func _on_body_entered(body: Node3D) -> void:
	if _activated or not body.is_in_group("player"):
		return
	_activated = true
	CheckpointManager.set_checkpoint(global_position + Vector3(0, 0.5, 0), checkpoint_id)
	_set_active_look()

func _set_inactive_look() -> void:
	_material.albedo_color = Color(0.2, 0.5, 0.7)
	_material.emission = Color(0.05, 0.15, 0.25)

func _set_active_look() -> void:
	_material.albedo_color = Color(0.25, 0.85, 0.55)
	_material.emission = Color(0.1, 0.4, 0.25)
