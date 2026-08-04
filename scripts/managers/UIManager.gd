extends Node

signal ui_opened(ui_name: String)
signal ui_closed(ui_name: String)

var _active_ui: Array[String] = []

func _ready() -> void:
	print("[UIManager] initialized")

func show_ui(ui_name: String) -> void:
	if ui_name in _active_ui:
		return
	_active_ui.append(ui_name)
	ui_opened.emit(ui_name)

func hide_ui(ui_name: String) -> void:
	_active_ui.erase(ui_name)
	ui_closed.emit(ui_name)

func is_ui_open(ui_name: String) -> bool:
	return ui_name in _active_ui

func show_dialogue(lines: Array, speaker: String = "") -> void:
	var boxes := get_tree().get_nodes_in_group("dialogue_box")
	if boxes.is_empty():
		Debug.print_warning("No DialogueBox in scene", "UIManager")
		return
	show_ui("dialogue")
	boxes[0].call("show_lines", lines, speaker)
