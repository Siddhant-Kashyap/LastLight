class_name MemoryLog
extends Interactable

@export var log_id: String = "log_01"
@export var speaker_name: String = ""
@export var log_lines: PackedStringArray = PackedStringArray(["[Empty log]"])

@onready var _mesh: MeshInstance3D = $MeshInstance3D

var _material: StandardMaterial3D

func _ready() -> void:
	prompt_label = "Read Log"
	_material = StandardMaterial3D.new()
	_material.albedo_color = Color(0.7, 0.65, 0.3)
	_material.emission_enabled = true
	_material.emission = Color(0.15, 0.12, 0.03)
	_mesh.material_override = _material
	super._ready()

func _on_interact(_interactor: Node3D) -> void:
	var item_key := "log_" + log_id
	if InventoryManager.has_item(item_key):
		UIManager.show_dialogue(log_lines, speaker_name)
		return
	InventoryManager.add_item(item_key)
	UIManager.show_dialogue(log_lines, speaker_name)
	queue_free()

func on_focused() -> void:
	super.on_focused()
	_material.emission = Color(0.4, 0.35, 0.08)

func on_unfocused() -> void:
	super.on_unfocused()
	_material.emission = Color(0.15, 0.12, 0.03)
