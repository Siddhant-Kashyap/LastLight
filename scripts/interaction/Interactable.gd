class_name Interactable
extends Area3D

signal focused
signal unfocused
signal interacted(interactor: Node3D)

@export var prompt_label: String = "Interact"
@export var is_enabled: bool = true

func _ready() -> void:
	add_to_group("interactable")
	collision_layer = 1 << (Constants.INTERACTION_LAYER - 1)
	collision_mask = 0
	monitoring = false
	monitorable = true

func interact(interactor: Node3D) -> void:
	if not is_enabled:
		return
	interacted.emit(interactor)
	_on_interact(interactor)

func on_focused() -> void:
	focused.emit()

func on_unfocused() -> void:
	unfocused.emit()

func _on_interact(_interactor: Node3D) -> void:
	pass
