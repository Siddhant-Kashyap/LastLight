class_name LanternController
extends Node3D

signal toggled(is_on: bool)
signal fuel_changed(current: float, maximum: float)
signal fuel_low
signal fuel_depleted

@export_group("Fuel")
@export var max_fuel: float = 100.0
@export var drain_rate: float = 3.0
@export var low_fuel_threshold: float = 25.0

@export_group("Light")
@export var light_energy_on: float = 2.0
@export var light_range: float = 8.0
@export var light_color: Color = Color(1.0, 0.75, 0.4, 1.0)

@export_group("Flicker")
@export var flicker_speed: float = 3.0
@export var flicker_intensity: float = 0.12

var is_on: bool = false
var current_fuel: float = 0.0

var _flicker_time: float = 0.0
var _low_fuel_signaled: bool = false
var _glass_mat: StandardMaterial3D
var _core_mat: StandardMaterial3D

@onready var _light: OmniLight3D = $OmniLight3D

func _ready() -> void:
	current_fuel = max_fuel
	_light.light_color = light_color
	_light.omni_range = light_range
	_light.light_energy = 0.0
	_light.shadow_enabled = false  # no self-shadowing on holder
	_build_visual()
	Debug.print_info("LanternController ready", "Lantern")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("lantern"):
		_toggle()
	if not is_on:
		return
	_drain_fuel(delta)
	_update_flicker(delta)

func _toggle() -> void:
	if not is_on and is_zero_approx(current_fuel):
		return
	is_on = not is_on
	_light.visible = is_on
	if not is_on:
		_light.light_energy = 0.0
	_update_visual_state()
	toggled.emit(is_on)
	Debug.print_info("Lantern " + ("on" if is_on else "off"), "Lantern")

func _drain_fuel(delta: float) -> void:
	if is_zero_approx(current_fuel):
		return
	current_fuel = maxf(current_fuel - drain_rate * delta, 0.0)
	fuel_changed.emit(current_fuel, max_fuel)
	if not _low_fuel_signaled and current_fuel <= max_fuel * (low_fuel_threshold / 100.0):
		_low_fuel_signaled = true
		fuel_low.emit()
		Debug.print_info("Fuel low", "Lantern")
	if is_zero_approx(current_fuel):
		_extinguish()

func _extinguish() -> void:
	is_on = false
	_light.visible = false
	_light.light_energy = 0.0
	_update_visual_state()
	fuel_depleted.emit()
	Debug.print_info("Fuel depleted — lantern extinguished", "Lantern")

func _update_flicker(delta: float) -> void:
	_flicker_time += delta
	var fuel_pct: float = get_fuel_percent()
	var speed_mul: float = 1.0 + (1.0 - fuel_pct) * 2.0
	var intensity_mul: float = 1.0 + (1.0 - fuel_pct) * 0.5
	var t: float = _flicker_time * flicker_speed * speed_mul
	var noise: float = (
		sin(t * 1.00) * 0.50 +
		sin(t * 2.30) * 0.30 +
		sin(t * 5.10) * 0.15 +
		sin(t * 11.7) * 0.05
	)
	var energy := maxf(0.0, light_energy_on * (1.0 + noise * flicker_intensity * intensity_mul))
	_light.light_energy = energy
	if _core_mat != null:
		_core_mat.emission_energy_multiplier = energy * 2.2

func _update_visual_state() -> void:
	if _glass_mat == null or _core_mat == null:
		return
	if is_on:
		_glass_mat.albedo_color = Color(1.0, 0.80, 0.45, 0.55)
		_glass_mat.emission = Color(1.0, 0.60, 0.15)
		_glass_mat.emission_energy_multiplier = 1.2
		_core_mat.emission_energy_multiplier = light_energy_on * 2.2
	else:
		_glass_mat.albedo_color = Color(0.52, 0.48, 0.38, 0.28)
		_glass_mat.emission_energy_multiplier = 0.0
		_core_mat.emission_energy_multiplier = 0.0

func add_fuel(amount: float) -> void:
	var was_empty: bool = is_zero_approx(current_fuel)
	current_fuel = minf(current_fuel + amount, max_fuel)
	if was_empty:
		_low_fuel_signaled = false
	fuel_changed.emit(current_fuel, max_fuel)
	Debug.print_info("Fuel added: %.1f (now: %.1f)" % [amount, current_fuel], "Lantern")

func get_fuel_percent() -> float:
	if is_zero_approx(max_fuel):
		return 0.0
	return current_fuel / max_fuel

# ── visual construction ──────────────────────────────────────────────────────

func _build_visual() -> void:
	var metal := StandardMaterial3D.new()
	metal.albedo_color = Color(0.11, 0.10, 0.09)
	metal.metallic = 0.75
	metal.roughness = 0.40

	_glass_mat = StandardMaterial3D.new()
	_glass_mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	_glass_mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	_glass_mat.albedo_color = Color(0.52, 0.48, 0.38, 0.28)
	_glass_mat.roughness = 0.05
	_glass_mat.emission_enabled = true
	_glass_mat.emission = Color(0, 0, 0)

	_core_mat = StandardMaterial3D.new()
	_core_mat.albedo_color = Color(1.0, 0.85, 0.50)
	_core_mat.emission_enabled = true
	_core_mat.emission = Color(1.0, 0.70, 0.20)
	_core_mat.emission_energy_multiplier = 0.0

	# Hook ring — the hand grips this
	_cyl(Vector3(0.0,  0.024, 0.0), 0.007, 0.032, metal)
	# Top cap
	_cyl(Vector3(0.0, -0.006, 0.0), 0.038, 0.012, metal)
	# 4 corner bars
	for sx: float in [-1.0, 1.0]:
		for sz: float in [-1.0, 1.0]:
			_cyl(Vector3(sx * 0.030, -0.065, sz * 0.030), 0.004, 0.100, metal)
	# Mid band
	_cyl(Vector3(0.0, -0.065, 0.0), 0.044, 0.007, metal)
	# Bottom cap
	_cyl(Vector3(0.0, -0.122, 0.0), 0.038, 0.012, metal)

	# Glass panels — one per face
	const G_Y   := -0.065
	const G_H   := 0.088
	const G_OFF := 0.034
	const G_W   := 0.056
	const G_D   := 0.004
	var panels: Array[Array] = [
		[Vector3( 0.0,   G_Y,  G_OFF), Vector3(G_W, G_H, G_D)],
		[Vector3( 0.0,   G_Y, -G_OFF), Vector3(G_W, G_H, G_D)],
		[Vector3( G_OFF, G_Y,  0.0  ), Vector3(G_D, G_H, G_W)],
		[Vector3(-G_OFF, G_Y,  0.0  ), Vector3(G_D, G_H, G_W)],
	]
	for p: Array in panels:
		var mi := MeshInstance3D.new()
		var bm := BoxMesh.new()
		bm.size = p[1]
		mi.mesh = bm
		mi.position = p[0]
		mi.material_override = _glass_mat
		add_child(mi)

	# Flame core sphere
	var core := MeshInstance3D.new()
	var sm := SphereMesh.new()
	sm.radius = 0.013
	sm.height = 0.026
	core.mesh = sm
	core.position = Vector3(0.0, -0.065, 0.0)
	core.material_override = _core_mat
	add_child(core)

	# Move OmniLight to body centre
	_light.position = Vector3(0.0, -0.065, 0.0)

func _cyl(pos: Vector3, radius: float, height: float, mat: Material) -> void:
	var mi := MeshInstance3D.new()
	var cm := CylinderMesh.new()
	cm.top_radius = radius
	cm.bottom_radius = radius
	cm.height = height
	cm.radial_segments = 8
	cm.rings = 1
	mi.mesh = cm
	mi.position = pos
	mi.material_override = mat
	add_child(mi)
