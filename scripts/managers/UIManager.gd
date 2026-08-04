extends Node

signal ui_opened(ui_name: String)
signal ui_closed(ui_name: String)
signal hud_updated

var _active_ui: Array[String] = []

func _ready() -> void:
	print("[UIManager] initialized")

func show_ui(ui_name: String) -> void:
	if ui_name in _active_ui:
		return
	_active_ui.append(ui_name)
	Debug.print_info("show_ui() placeholder: " + ui_name, "UIManager")
	ui_opened.emit(ui_name)

func hide_ui(ui_name: String) -> void:
	_active_ui.erase(ui_name)
	Debug.print_info("hide_ui() placeholder: " + ui_name, "UIManager")
	ui_closed.emit(ui_name)

func is_ui_open(ui_name: String) -> bool:
	return ui_name in _active_ui

func update_hud() -> void:
	hud_updated.emit()
