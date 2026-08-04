class_name DialogueBox
extends Control

@onready var _panel: PanelContainer = $Panel
@onready var _speaker: Label = $Panel/VBox/Speaker
@onready var _body: Label = $Panel/VBox/Body
@onready var _continue_hint: Label = $Panel/VBox/ContinueHint

var _lines: Array = []
var _index: int = 0

func _ready() -> void:
	add_to_group("dialogue_box")
	_build_styles()
	visible = false

func _build_styles() -> void:
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color(0.0, 0.0, 0.0, 0.82)
	bg.corner_radius_top_left = 4
	bg.corner_radius_top_right = 4
	bg.corner_radius_bottom_left = 4
	bg.corner_radius_bottom_right = 4
	bg.content_margin_left = 20
	bg.content_margin_top = 14
	bg.content_margin_right = 20
	bg.content_margin_bottom = 14
	_panel.add_theme_stylebox_override("panel", bg)

	_speaker.add_theme_color_override("font_color", Color(0.9, 0.65, 0.2))
	_speaker.add_theme_font_size_override("font_size", 13)

	_body.add_theme_color_override("font_color", Color(0.92, 0.92, 0.92))
	_body.add_theme_font_size_override("font_size", 15)
	_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	_continue_hint.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7, 0.8))
	_continue_hint.add_theme_font_size_override("font_size", 12)
	_continue_hint.text = "[ E ]  Continue"

func _process(_delta: float) -> void:
	if not visible:
		return
	if Input.is_action_just_pressed("interact"):
		_advance()

func show_lines(lines: Array, speaker: String = "") -> void:
	_lines = lines
	_index = 0
	_speaker.text = speaker
	_speaker.visible = speaker.length() > 0
	_show_current()
	visible = true

func _show_current() -> void:
	_body.text = _lines[_index]
	var is_last: bool = _index >= _lines.size() - 1
	_continue_hint.text = "[ E ]  Close" if is_last else "[ E ]  Continue"

func _advance() -> void:
	_index += 1
	if _index >= _lines.size():
		_close()
		return
	_show_current()

func _close() -> void:
	visible = false
	_lines.clear()
	_index = 0
	UIManager.hide_ui("dialogue")
