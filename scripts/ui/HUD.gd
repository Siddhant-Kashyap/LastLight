class_name HUD
extends Control

@onready var _fuel_bar: ProgressBar = $FuelPanel/VBox/FuelBar
@onready var _fuel_title: Label = $FuelPanel/VBox/FuelTitle
@onready var _prompt: Label = $InteractionPrompt

var _fill_full: StyleBoxFlat
var _fill_med: StyleBoxFlat
var _fill_low: StyleBoxFlat

func _ready() -> void:
	_build_styles()
	call_deferred("_connect_signals")

func _build_styles() -> void:
	var panel_bg := StyleBoxFlat.new()
	panel_bg.bg_color = Color(0.0, 0.0, 0.0, 0.65)
	panel_bg.corner_radius_top_left = 4
	panel_bg.corner_radius_top_right = 4
	panel_bg.corner_radius_bottom_left = 4
	panel_bg.corner_radius_bottom_right = 4
	panel_bg.content_margin_left = 10
	panel_bg.content_margin_top = 8
	panel_bg.content_margin_right = 10
	panel_bg.content_margin_bottom = 8
	$FuelPanel.add_theme_stylebox_override("panel", panel_bg)

	_fuel_title.add_theme_color_override("font_color", Color(0.9, 0.65, 0.2))
	_fuel_title.add_theme_font_size_override("font_size", 11)

	_fill_full = _make_fill(Color(0.9, 0.6, 0.1))
	_fill_med = _make_fill(Color(0.9, 0.38, 0.05))
	_fill_low = _make_fill(Color(0.85, 0.1, 0.05))

	var bar_bg := StyleBoxFlat.new()
	bar_bg.bg_color = Color(0.15, 0.15, 0.15)
	_fuel_bar.add_theme_stylebox_override("background", bar_bg)
	_fuel_bar.add_theme_stylebox_override("fill", _fill_full)
	_fuel_bar.custom_minimum_size = Vector2(160, 14)

	$FuelPanel/VBox.add_theme_constant_override("separation", 5)

	_prompt.add_theme_color_override("font_color", Color(1, 1, 1, 0.95))
	_prompt.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.85))
	_prompt.add_theme_constant_override("shadow_offset_x", 2)
	_prompt.add_theme_constant_override("shadow_offset_y", 2)
	_prompt.add_theme_font_size_override("font_size", 15)

func _make_fill(color: Color) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = color
	return s

func _connect_signals() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return
	var player := players[0]

	var lantern: Node = player.get_node_or_null("Lantern")
	if is_instance_valid(lantern):
		lantern.fuel_changed.connect(_on_fuel_changed)
		_on_fuel_changed(lantern.get("current_fuel"), lantern.get("max_fuel"))

	var detector: Node = player.get_node_or_null("InteractionDetector")
	if is_instance_valid(detector):
		detector.interactable_focused.connect(_on_focused)
		detector.interactable_unfocused.connect(_on_unfocused)

func _on_fuel_changed(current: float, maximum: float) -> void:
	var pct := current / maximum
	_fuel_bar.value = pct * 100.0
	if pct > 0.5:
		_fuel_bar.add_theme_stylebox_override("fill", _fill_full)
	elif pct > 0.25:
		_fuel_bar.add_theme_stylebox_override("fill", _fill_med)
	else:
		_fuel_bar.add_theme_stylebox_override("fill", _fill_low)

func _on_focused(_interactable: Area3D, label: String) -> void:
	_prompt.text = "[ E ]  " + label
	_prompt.visible = true

func _on_unfocused() -> void:
	_prompt.visible = false
