class_name FuelPickup
extends Interactable

@export var fuel_amount: float = 25.0

@onready var _mesh: MeshInstance3D = $MeshInstance3D

var _material: StandardMaterial3D

func _ready() -> void:
	prompt_label = "Pick up Fuel"
	_material = StandardMaterial3D.new()
	_material.albedo_color = Color(1.0, 0.5, 0.1)
	_mesh.material_override = _material
	super._ready()

func _on_interact(interactor: Node3D) -> void:
	var lantern: Node = interactor.get_node_or_null("Lantern")
	if is_instance_valid(lantern):
		lantern.call("add_fuel", fuel_amount)
	queue_free()

func on_focused() -> void:
	super.on_focused()
	_material.albedo_color = Color(1.0, 0.85, 0.3)

func on_unfocused() -> void:
	super.on_unfocused()
	_material.albedo_color = Color(1.0, 0.5, 0.1)
