class_name Chapter01Builder
extends Node3D

const DEPTH: float = 3.0
const HD: float = 1.5

# ── Materials ─────────────────────────────────────────────────────────────────

var _ext_concrete: StandardMaterial3D  # wet exterior concrete
var _int_concrete: StandardMaterial3D  # interior floor
var _wall_mid: StandardMaterial3D      # standard interior wall
var _wall_dark: StandardMaterial3D     # dark corridor wall
var _back_wall: StandardMaterial3D     # back/depth wall
var _metal_rough: StandardMaterial3D   # structural metal (rough)
var _metal_shiny: StandardMaterial3D   # pipes, smooth metal
var _wood: StandardMaterial3D          # crates, desks
var _ceiling_mat: StandardMaterial3D
var _rust: StandardMaterial3D

func _ready() -> void:
	_make_materials()
	_build_exterior()
	_build_street_lights()
	_build_lobby_entrance()
	_build_dark_corridor()
	_build_break_room()
	_build_main_lobby()
	_build_rain()
	_build_lights()

# ── Material helpers ──────────────────────────────────────────────────────────

func _make_materials() -> void:
	# Wet exterior concrete — low roughness, slight blue-grey
	_ext_concrete = _mat(Color(0.10, 0.11, 0.13), 0.38, 0.0)

	# Interior concrete floor — warmer, drier
	_int_concrete = _mat(Color(0.15, 0.14, 0.13), 0.80, 0.0)

	# Standard interior wall
	_wall_mid = _mat(Color(0.20, 0.20, 0.23), 0.88, 0.0)

	# Dark corridor
	_wall_dark = _mat(Color(0.07, 0.07, 0.09), 0.92, 0.0)

	# Back/depth wall — slightly cooler
	_back_wall = _mat(Color(0.10, 0.10, 0.13), 0.92, 0.0)

	# Structural metal (rough, old)
	_metal_rough = _mat(Color(0.26, 0.27, 0.30), 0.70, 0.45)

	# Smooth metal (pipes, rails)
	_metal_shiny = _mat(Color(0.32, 0.33, 0.36), 0.48, 0.65)

	# Wood (crates, desks)
	_wood = _mat(Color(0.24, 0.18, 0.11), 0.88, 0.0)

	# Ceiling
	_ceiling_mat = _mat(Color(0.08, 0.08, 0.10), 0.95, 0.0)

	# Rust/aged metal
	_rust = _mat(Color(0.28, 0.14, 0.06), 0.92, 0.15)

func _mat(color: Color, rough: float = 0.85, metal: float = 0.0) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = rough
	m.metallic = metal
	return m

func _emissive_mat(color: Color, emission: Color, rough: float = 0.5) -> StandardMaterial3D:
	var m := _mat(color, rough, 0.0)
	m.emission_enabled = true
	m.emission = emission
	m.emission_energy_multiplier = 1.0
	return m

# ── Geometry helpers ──────────────────────────────────────────────────────────

func _solid(pos: Vector3, sz: Vector3, mat: StandardMaterial3D) -> void:
	var body := StaticBody3D.new()
	body.position = pos
	var cs := CollisionShape3D.new()
	var shape := BoxShape3D.new()
	shape.size = sz
	cs.shape = shape
	body.add_child(cs)
	var mi := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = sz
	mi.mesh = mesh
	mi.material_override = mat
	body.add_child(mi)
	add_child(body)

func _deco(pos: Vector3, sz: Vector3, mat: StandardMaterial3D) -> void:
	var mi := MeshInstance3D.new()
	mi.position = pos
	var mesh := BoxMesh.new()
	mesh.size = sz
	mi.mesh = mesh
	mi.material_override = mat
	add_child(mi)

func _pipe(pos: Vector3, r: float, h: float, mat: StandardMaterial3D,
		rz: float = 0.0, rx: float = 0.0) -> void:
	var mi := MeshInstance3D.new()
	mi.position = pos
	mi.rotation.z = rz
	mi.rotation.x = rx
	var mesh := CylinderMesh.new()
	mesh.top_radius = r
	mesh.bottom_radius = r
	mesh.height = h
	mi.mesh = mesh
	mi.material_override = mat
	add_child(mi)

func _omni(pos: Vector3, color: Color, energy: float, range_val: float) -> void:
	var l := OmniLight3D.new()
	l.position = pos
	l.light_color = color
	l.light_energy = energy
	l.omni_range = range_val
	l.shadow_enabled = true
	add_child(l)

func _spot(pos: Vector3, color: Color, energy: float, angle: float, range_val: float) -> void:
	var l := SpotLight3D.new()
	l.position = pos
	l.rotation.x = -PI * 0.5  # point down
	l.light_color = color
	l.light_energy = energy
	l.spot_angle = angle
	l.spot_range = range_val
	l.shadow_enabled = true
	add_child(l)

func _model(path: String, pos: Vector3, scale_val: float = 1.0, ry: float = 0.0) -> void:
	var packed := load(path)
	if packed == null:
		return
	var inst := (packed as PackedScene).instantiate()
	inst.position = pos
	inst.scale = Vector3.ONE * scale_val
	if ry != 0.0:
		inst.rotation_degrees.y = ry
	add_child(inst)

# ── Section 1: EXTERIOR ───────────────────────────────────────────────────────
# x: -22 to 10 | open sky, rain, wet ground, industrial debris

func _build_exterior() -> void:
	# Wet ground (low roughness = reflective sheen)
	_solid(Vector3(-6, -0.25, 0), Vector3(33, 0.5, DEPTH), _ext_concrete)

	# Left boundary wall
	_solid(Vector3(-22, 2.5, 0), Vector3(0.5, 5.5, DEPTH), _metal_rough)

	# Building facade above door opening (y: 3 → 4.5)
	_solid(Vector3(9.75, 3.75, 0), Vector3(0.5, 1.5, DEPTH), _wall_mid)

	# Background facade strip — suggests the full building height
	_deco(Vector3(-6, 6.5, -HD), Vector3(34, 6.0, 0.2), _wall_dark)
	# Facade window bands (dark horizontal strips on the building face)
	_deco(Vector3(-6, 8.2, -HD + 0.05), Vector3(34, 0.55, 0.12), _metal_rough)
	_deco(Vector3(-6, 7.0, -HD + 0.05), Vector3(34, 0.55, 0.12), _metal_rough)

	# Rainwater drainage channel along base of building (slight ledge)
	_deco(Vector3(8, 0.06, -HD + 0.1), Vector3(4, 0.12, 0.4), _metal_shiny)

	# Crate stack — left side, acts as early cover
	_solid(Vector3(-17.5, 0.62, 0.0), Vector3(2.4, 1.25, 1.6), _wood)
	_solid(Vector3(-17.5, 1.55, 0.1), Vector3(1.6, 0.8, 1.0), _wood)
	_deco(Vector3(-15.5, 0.35, 0.2), Vector3(0.7, 0.7, 0.7), _metal_rough)

	# Rock cluster (replaces rusted barrels) — Rock1 Y_min=0, sits on ground
	_model("res://assets/models/environment/Rock1.gltf", Vector3(-10.0, 0, 0.3), 0.75)
	_model("res://assets/models/environment/Rock1.gltf", Vector3(-9.2, 0, -0.3), 0.52, 75.0)
	_model("res://assets/models/environment/Rock2.gltf", Vector3(-11.2, 0, -0.1), 0.55, 30.0)

	# Fallen signage / panel on ground
	_deco(Vector3(-3, 0.04, 0.2), Vector3(2.0, 0.08, 0.7), _metal_rough)

	# Ground debris near entrance
	_deco(Vector3(4.5, 0.12, 0.4),  Vector3(1.1, 0.25, 0.65), _wood)
	_deco(Vector3(2.2, 0.08, -0.3), Vector3(0.55, 0.18, 0.45), _metal_rough)

	# Overhead cable/pipe spanning exterior wall to building
	_pipe(Vector3(-6, 4.2, -0.45), 0.06, 34, _metal_shiny, PI * 0.5)
	_pipe(Vector3(-6, 3.7, -0.3),  0.04, 34, _metal_shiny, PI * 0.5)

	# Wall-mounted light fixture housing (broken — no light, adds detail)
	_deco(Vector3(-8, 3.6, -HD + 0.12), Vector3(0.4, 0.3, 0.25), _metal_rough)
	_deco(Vector3(0,  3.6, -HD + 0.12), Vector3(0.4, 0.3, 0.25), _metal_rough)

	# Trim strip between ground and back facade
	_deco(Vector3(-6, 0.05, -HD + 0.06), Vector3(34, 0.1, 0.12), _metal_rough)

	# Dead trees — horror atmosphere in background, Y_min=0 so no Y offset needed
	_model("res://assets/models/environment/DeadTree_1.gltf", Vector3(-19, 0, -1.2), 0.85)
	_model("res://assets/models/environment/DeadTree_2.gltf", Vector3(-14, 0, -1.1), 0.75, 40.0)
	_model("res://assets/models/environment/DeadTree_3.gltf", Vector3(-3.5, 0, -1.3), 0.80, 120.0)

# ── Section 2: LOBBY ENTRANCE ─────────────────────────────────────────────────
# x: 10 to 35 | ceiling y=4.5 | security desk, emergency red light

func _build_lobby_entrance() -> void:
	var cx: float = 22.5;  var w: float = 25.0;  var cy: float = 4.5

	_solid(Vector3(cx, -0.25, 0), Vector3(w, 0.5, DEPTH),      _int_concrete)
	_solid(Vector3(cx, cy + 0.25, 0), Vector3(w, 0.5, DEPTH),  _ceiling_mat)
	# Upper wall only — gap y:0–2.8 left for door
	_solid(Vector3(35, 3.65, 0), Vector3(0.5, 1.7, DEPTH), _wall_mid)
	_deco(Vector3(cx, cy * 0.5, -HD), Vector3(w, cy + 0.5, 0.2), _back_wall)

	# Floor skirting strip
	_deco(Vector3(cx, 0.06, -HD + 0.08), Vector3(w, 0.12, 0.16), _metal_rough)
	# Ceiling cornice
	_deco(Vector3(cx, cy - 0.06, -HD + 0.08), Vector3(w, 0.12, 0.18), _metal_rough)

	# Overhead pipe pair
	_pipe(Vector3(cx, cy - 0.28, -0.55), 0.09, w, _metal_shiny, PI * 0.5)
	_pipe(Vector3(cx, cy - 0.18, 0.25),  0.05, w, _metal_shiny, PI * 0.5)

	# Emergency light housing strip on ceiling
	_deco(Vector3(cx, cy - 0.02, 0.5), Vector3(w * 0.6, 0.06, 0.22), _metal_rough)

	# Security desk (L-shaped, player can jump on)
	_solid(Vector3(19, 0.65, 0), Vector3(4.2, 0.80, 1.35), _metal_rough)
	_deco(Vector3(17.0, 0.38, 0),   Vector3(0.30, 0.72, 1.35), _metal_rough)
	_deco(Vector3(21.0, 0.38, 0),   Vector3(0.30, 0.72, 1.35), _metal_rough)
	_deco(Vector3(19.0, 0.38, -0.68), Vector3(4.2, 0.72, 0.32), _metal_rough)

	# Monitor with glowing screen
	_deco(Vector3(18.2, 1.22, -0.42), Vector3(1.1, 0.70, 0.09), _metal_rough)
	_deco(Vector3(18.2, 1.22, -0.37),
		Vector3(0.9, 0.55, 0.04),
		_emissive_mat(Color(0.03, 0.06, 0.12), Color(0.02, 0.05, 0.14)))
	# Keyboard
	_deco(Vector3(19.5, 0.88, -0.08), Vector3(1.2, 0.06, 0.58), _metal_rough)
	# Radio/walkie-talkie
	_deco(Vector3(20.5, 0.95, -0.3), Vector3(0.45, 0.38, 0.38), _metal_rough)

	# Toppled chair
	_deco(Vector3(21.6, 0.28, 0.55), Vector3(0.72, 0.58, 0.72), _metal_rough)

	# Filing cabinet right side
	_solid(Vector3(33.2, 1.05, -0.55), Vector3(1.0, 2.1, 0.65), _metal_rough)
	# Cabinet drawer lines
	_deco(Vector3(32.72, 1.05, -0.28), Vector3(0.04, 2.0, 0.04), _metal_shiny)

	# Scattered papers
	_deco(Vector3(15.5, 0.04, 0.35),  Vector3(2.8, 0.04, 1.0), _mat(Color(0.42, 0.40, 0.36), 0.9))
	_deco(Vector3(26.0, 0.04, -0.45), Vector3(1.8, 0.04, 0.8), _mat(Color(0.42, 0.40, 0.36), 0.9))

	# Warning sign (glowing faint red)
	_deco(Vector3(35.1, 2.8, 0.5), Vector3(0.06, 0.55, 0.80),
		_emissive_mat(Color(0.5, 0.05, 0.02), Color(0.3, 0.02, 0.01)))

# ── Section 3: DARK CORRIDOR ──────────────────────────────────────────────────
# x: 35 to 55 | ceiling y=3.5 | claustrophobic, lantern only

func _build_dark_corridor() -> void:
	var cx: float = 45.0;  var w: float = 20.0;  var cy: float = 3.5

	_solid(Vector3(cx, -0.25, 0), Vector3(w, 0.5, DEPTH), _int_concrete)
	_solid(Vector3(cx, cy + 0.25, 0), Vector3(w, 0.5, DEPTH), _ceiling_mat)
	# Upper wall only — gap y:0–2.8 for door (shared with lobby above)
	_solid(Vector3(35, 3.15, 0), Vector3(0.5, 0.7, DEPTH), _wall_dark)
	_solid(Vector3(55, cy * 0.5, 0), Vector3(0.5, cy + 0.5, DEPTH), _wall_dark)
	_deco(Vector3(cx, cy * 0.5, -HD), Vector3(w, cy + 0.5, 0.2), _wall_dark)

	# Pipe cluster on ceiling
	_pipe(Vector3(cx, cy - 0.18, -0.60), 0.09,  w, _metal_shiny, PI * 0.5)
	_pipe(Vector3(cx, cy - 0.12, 0.20),  0.06,  w, _metal_shiny, PI * 0.5)
	_pipe(Vector3(cx, cy - 0.28, -0.20), 0.055, w, _rust,        PI * 0.5)

	# Vertical drops (like conduit dripping)
	_pipe(Vector3(39.5, cy - 1.10, -0.60), 0.09, 2.4, _metal_shiny)
	_pipe(Vector3(49.0, cy - 0.90, -0.60), 0.09, 2.0, _metal_shiny)
	_pipe(Vector3(44.0, cy - 0.70, -0.20), 0.06, 1.6, _rust)

	# Blocked path crate (player must jump)
	_solid(Vector3(38.5, 0.55, 0.1), Vector3(1.6, 1.1, 1.3), _wood)
	_deco(Vector3(38.5, 1.15, 0.1), Vector3(1.55, 0.04, 1.25),
		_emissive_mat(Color(0.4, 0.15, 0.02), Color(0.15, 0.04, 0.005)))

	# Fallen pipe on ground
	_deco(Vector3(47.5, 0.09, -0.3), Vector3(0.5, 0.18, 5.0), _rust, )

	# Blood streak (very dark, subtle)
	_deco(Vector3(44, 0.025, 0.1), Vector3(0.4, 0.05, 2.5),
		_mat(Color(0.10, 0.02, 0.02), 0.92))

	# Scuff/damage marks on back wall
	_deco(Vector3(41, 1.5, -HD + 0.06), Vector3(0.8, 1.2, 0.08),
		_mat(Color(0.05, 0.04, 0.04), 0.95))
	_deco(Vector3(51, 2.0, -HD + 0.06), Vector3(1.2, 0.8, 0.06),
		_mat(Color(0.05, 0.04, 0.04), 0.95))

	# Warning tape strip on floor near crate (yellow-black suggestion)
	_deco(Vector3(36.5, 0.026, 0), Vector3(0.18, 0.05, DEPTH),
		_emissive_mat(Color(0.45, 0.38, 0.02), Color(0.12, 0.09, 0.005)))

# ── Section 4: BREAK ROOM ─────────────────────────────────────────────────────
# x: 55 to 78 | ceiling y=4.5 | warmer feel, break furniture

func _build_break_room() -> void:
	var cx: float = 66.5;  var w: float = 23.0;  var cy: float = 4.5

	_solid(Vector3(cx, -0.25, 0), Vector3(w, 0.5, DEPTH), _int_concrete)
	_solid(Vector3(cx, cy + 0.25, 0), Vector3(w, 0.5, DEPTH), _ceiling_mat)
	_solid(Vector3(78, cy * 0.5, 0), Vector3(0.5, cy + 0.5, DEPTH), _wall_mid)
	_deco(Vector3(cx, cy * 0.5, -HD), Vector3(w, cy + 0.5, 0.2), _back_wall)

	# Skirting + cornice
	_deco(Vector3(cx, 0.06, -HD + 0.08), Vector3(w, 0.12, 0.16), _metal_rough)
	_deco(Vector3(cx, cy - 0.06, -HD + 0.08), Vector3(w, 0.12, 0.16), _metal_rough)

	# Window in back wall — dark glass pane with frame
	_deco(Vector3(63.5, 2.5, -HD + 0.04), Vector3(4.5, 2.2, 0.12), _metal_rough)
	_deco(Vector3(63.5, 2.5, -HD + 0.10),
		Vector3(4.1, 1.9, 0.06),
		_emissive_mat(Color(0.03, 0.05, 0.09), Color(0.005, 0.01, 0.025)))
	_deco(Vector3(63.5, 2.5, -HD + 0.14),  Vector3(0.06, 1.9, 0.06), _metal_shiny)
	_deco(Vector3(63.5, 3.45, -HD + 0.14), Vector3(4.1, 0.06, 0.06), _metal_shiny)

	# Overhead pipe
	_pipe(Vector3(cx, cy - 0.28, -0.55), 0.09, w, _metal_shiny, PI * 0.5)
	_pipe(Vector3(cx, cy - 0.18, 0.28),  0.05, w, _metal_shiny, PI * 0.5)

	# Break table (solid, jumpable)
	_solid(Vector3(64, 0.62, 0), Vector3(3.6, 0.78, 1.35), _wood)
	_deco(Vector3(62.3, 0.2, 0.48),  Vector3(0.22, 0.5, 0.22), _metal_rough)
	_deco(Vector3(65.7, 0.2, 0.48),  Vector3(0.22, 0.5, 0.22), _metal_rough)
	_deco(Vector3(62.3, 0.2, -0.48), Vector3(0.22, 0.5, 0.22), _metal_rough)
	_deco(Vector3(65.7, 0.2, -0.48), Vector3(0.22, 0.5, 0.22), _metal_rough)

	# Chairs
	_deco(Vector3(66.5, 0.52, -0.78), Vector3(0.72, 1.0, 0.72), _metal_rough)
	_deco(Vector3(61.8, 0.28, 0.55),  Vector3(0.72, 0.58, 0.72), _metal_rough)

	# Mugs, plates on table
	_deco(Vector3(63.5, 1.02, 0.18),  Vector3(0.22, 0.28, 0.22), _mat(Color(0.28, 0.20, 0.12), 0.88))
	_deco(Vector3(65.2, 1.02, -0.12), Vector3(0.20, 0.24, 0.20), _mat(Color(0.38, 0.36, 0.32), 0.8))

	# Vending machine (solid)
	_solid(Vector3(76.8, 0.95, -0.5), Vector3(0.9, 1.9, 0.75), _metal_rough)
	_deco(Vector3(76.35, 1.1, -0.5),
		Vector3(0.06, 1.05, 0.52),
		_emissive_mat(Color(0.04, 0.06, 0.12), Color(0.015, 0.025, 0.06)))
	# Vending machine brand strip
	_deco(Vector3(76.35, 1.72, -0.5),
		Vector3(0.06, 0.18, 0.52),
		_emissive_mat(Color(0.5, 0.08, 0.04), Color(0.2, 0.02, 0.01)))

	# Exit sign above right wall door suggestion
	_deco(Vector3(77.6, 3.9, 0.2), Vector3(0.08, 0.3, 0.55),
		_emissive_mat(Color(0.05, 0.5, 0.08), Color(0.02, 0.28, 0.04)))

# ── Section 5: MAIN LOBBY ─────────────────────────────────────────────────────
# x: 78 to 108 | ceiling y=6.0 | tall, impressive, elevator end goal

func _build_main_lobby() -> void:
	var cx: float = 93.0;  var w: float = 30.0;  var cy: float = 6.0

	_solid(Vector3(cx, -0.25, 0), Vector3(w, 0.5, DEPTH), _int_concrete)
	_solid(Vector3(cx, cy + 0.25, 0), Vector3(w, 0.5, DEPTH), _ceiling_mat)
	_deco(Vector3(cx, cy * 0.5, -HD), Vector3(w, cy + 0.5, 0.2), _back_wall)

	# Skirting + cornice
	_deco(Vector3(cx, 0.06, -HD + 0.08), Vector3(w, 0.12, 0.16), _metal_rough)
	_deco(Vector3(cx, cy - 0.06, -HD + 0.08), Vector3(w, 0.14, 0.2), _metal_shiny)

	# Right end wall
	_solid(Vector3(108.25, cy * 0.5, 0), Vector3(0.5, cy + 0.5, DEPTH), _wall_mid)
	# Wall above elevator
	_solid(Vector3(104, cy - 1.25, 0), Vector3(7.2, 2.5, DEPTH), _wall_mid)
	# Elevator jambs
	_solid(Vector3(100.85, 1.75, 0), Vector3(0.32, 3.5, DEPTH), _metal_shiny)
	_solid(Vector3(107.15, 1.75, 0), Vector3(0.32, 3.5, DEPTH), _metal_shiny)

	# Elevator doors — slightly reflective panels
	_deco(Vector3(102.85, 1.75, 0.06), Vector3(2.6, 3.45, 0.12), _metal_shiny)
	_deco(Vector3(105.15, 1.75, 0.06), Vector3(2.6, 3.45, 0.12), _metal_shiny)
	# Door seam
	_deco(Vector3(104, 1.75, 0.13), Vector3(0.05, 3.45, 0.05), _mat(Color(0.02, 0.02, 0.025), 0.5))
	# Floor indicator above doors (glowing)
	_deco(Vector3(104, 3.7, 0.14),
		Vector3(1.5, 0.32, 0.08),
		_emissive_mat(Color(0.05, 0.35, 0.08), Color(0.02, 0.18, 0.04)))
	# Call button panel
	_deco(Vector3(100.68, 1.5, 0.32), Vector3(0.08, 0.62, 0.38), _metal_rough)
	_deco(Vector3(100.62, 1.5, 0.32),
		Vector3(0.05, 0.2, 0.2),
		_emissive_mat(Color(0.08, 0.8, 0.18), Color(0.04, 0.45, 0.10)))

	# Structural columns (visual depth, no collision)
	_deco(Vector3(82.0, cy * 0.5, -0.82), Vector3(0.56, cy, 0.56), _metal_rough)
	_deco(Vector3(98.5, cy * 0.5, -0.82), Vector3(0.56, cy, 0.56), _metal_rough)
	# Column base plates
	_deco(Vector3(82.0, 0.08, -0.82), Vector3(0.85, 0.16, 0.85), _metal_shiny)
	_deco(Vector3(98.5, 0.08, -0.82), Vector3(0.85, 0.16, 0.85), _metal_shiny)
	# Column cap plates
	_deco(Vector3(82.0, cy - 0.08, -0.82), Vector3(0.85, 0.16, 0.85), _metal_shiny)
	_deco(Vector3(98.5, cy - 0.08, -0.82), Vector3(0.85, 0.16, 0.85), _metal_shiny)

	# Overhead pipe pair
	_pipe(Vector3(cx, cy - 0.38, -0.55), 0.11, w, _metal_shiny, PI * 0.5)
	_pipe(Vector3(cx, cy - 0.56, 0.30),  0.07, w, _metal_shiny, PI * 0.5)

	# Reception desk (L-shape, jumpable)
	_solid(Vector3(86.5, 0.65, 0), Vector3(5.4, 0.82, 1.45), _metal_rough)
	_deco(Vector3(83.9, 0.38, 0),    Vector3(0.30, 0.72, 1.45), _metal_rough)
	_deco(Vector3(89.1, 0.38, 0),    Vector3(0.30, 0.72, 1.45), _metal_rough)
	_deco(Vector3(86.5, 0.38, -0.73), Vector3(5.4, 0.72, 0.32), _metal_rough)
	# Reception desk monitor
	_deco(Vector3(85.5, 1.22, -0.44), Vector3(1.1, 0.72, 0.09), _metal_rough)
	_deco(Vector3(85.5, 1.22, -0.39),
		Vector3(0.9, 0.55, 0.04),
		_emissive_mat(Color(0.03, 0.06, 0.12), Color(0.015, 0.04, 0.12)))

	# Maya's workstation (emotionally important)
	_solid(Vector3(94, 0.55, -0.15), Vector3(2.9, 0.72, 1.12), _wood)
	# Monitor
	_deco(Vector3(94, 1.24, -0.64), Vector3(1.35, 0.88, 0.09), _metal_rough)
	_deco(Vector3(94, 1.24, -0.59),
		Vector3(1.12, 0.72, 0.04),
		_emissive_mat(Color(0.04, 0.07, 0.14), Color(0.02, 0.04, 0.10)))
	# Keyboard
	_deco(Vector3(94, 0.92, -0.08), Vector3(1.1, 0.08, 0.56), _metal_rough)
	# Photo frame (warm — stands out in all the cold grey)
	_deco(Vector3(95.1, 0.98, -0.60),
		Vector3(0.30, 0.40, 0.05),
		_emissive_mat(Color(0.55, 0.48, 0.40), Color(0.06, 0.05, 0.04), 0.7))
	# Coffee mug
	_deco(Vector3(93.0, 0.98, -0.44), Vector3(0.22, 0.30, 0.22), _mat(Color(0.25, 0.18, 0.11), 0.88))
	# Personal plant (tiny cube, slight green — humanity in darkness)
	_deco(Vector3(95.4, 0.98, -0.20),
		Vector3(0.28, 0.30, 0.28),
		_emissive_mat(Color(0.08, 0.28, 0.06), Color(0.01, 0.04, 0.01), 0.9))

	# Stacked boxes near left column
	_solid(Vector3(81.5, 0.55, -0.4), Vector3(1.5, 1.1, 1.1), _wood)
	_solid(Vector3(81.5, 1.3, -0.4),  Vector3(1.2, 0.82, 0.9), _wood)

	# Overturned chair near Maya's desk
	_deco(Vector3(96.5, 0.28, 0.5), Vector3(0.72, 0.58, 0.72), _metal_rough)

# ── STREET LIGHTS ─────────────────────────────────────────────────────────────

func _build_street_lights() -> void:
	_street_light(Vector3(-18, 0, -0.3))
	_street_light(Vector3(-7,  0, -0.3))
	_street_light(Vector3( 3,  0, -0.3))

func _street_light(base: Vector3) -> void:
	# Pole
	_pipe(base + Vector3(0, 2.2, 0), 0.048, 4.4, _metal_rough)

	# Horizontal arm
	_pipe(base + Vector3(0.28, 4.35, 0), 0.038, 0.65, _metal_rough, 0.0, PI * 0.5)

	# Lamp head housing
	_deco(base + Vector3(0.28, 4.12, 0), Vector3(0.48, 0.22, 0.40), _metal_rough)

	# Lens face — emissive
	_deco(base + Vector3(0.28, 3.99, 0), Vector3(0.36, 0.06, 0.30),
		_emissive_mat(Color(0.88, 0.80, 0.58), Color(0.65, 0.58, 0.32)))

	# SpotLight cone
	var light := SpotLight3D.new()
	light.position = base + Vector3(0.28, 4.0, 0)
	light.rotation.x = -PI * 0.5
	light.light_color = Color(0.92, 0.82, 0.58)
	light.light_energy = 2.4
	light.spot_angle = 40.0
	light.spot_range = 8.5
	light.shadow_enabled = true
	add_child(light)

	# Fog volume — soft amber halo around the cone
	var fog := FogVolume.new()
	fog.position = base + Vector3(0.28, 2.2, 0)
	fog.size = Vector3(3.8, 4.8, 3.4)
	fog.shape = 0  # ELLIPSOID
	var fm := FogMaterial.new()
	fm.density = 0.20
	fm.albedo = Color(0.88, 0.80, 0.58, 1.0)
	fm.emission = Color(0.05, 0.04, 0.015)
	fm.edge_fade = 0.55
	fog.material = fm
	add_child(fog)

# ── RAIN ──────────────────────────────────────────────────────────────────────

func _build_rain() -> void:
	var rain := GPUParticles3D.new()
	rain.position = Vector3(-6, 14, 0)
	rain.amount = 900
	rain.lifetime = 1.9
	rain.preprocess = 1.8
	rain.emitting = true
	rain.draw_passes = 1
	rain.visibility_aabb = AABB(Vector3(-20, -15, -2), Vector3(38, 16, 4))

	var pm := ParticleProcessMaterial.new()
	pm.direction = Vector3(0.08, -1.0, 0.0)
	pm.spread = 3.0
	pm.gravity = Vector3(0.0, -24.0, 0.0)
	pm.initial_velocity_min = 11.0
	pm.initial_velocity_max = 17.0
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = Vector3(17.0, 0.5, 0.9)
	pm.color = Color(0.58, 0.68, 0.88, 0.65)
	pm.scale_min = 0.8
	pm.scale_max = 1.3
	rain.process_material = pm

	var quad := QuadMesh.new()
	quad.size = Vector2(0.02, 0.48)
	var rm := StandardMaterial3D.new()
	rm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	rm.albedo_color = Color(0.60, 0.72, 0.92, 0.55)
	rm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	rm.cull_mode = BaseMaterial3D.CULL_DISABLED
	quad.material = rm
	rain.draw_pass_1 = quad
	add_child(rain)

# ── ATMOSPHERIC LIGHTS ────────────────────────────────────────────────────────

func _build_lights() -> void:
	# Exterior — faint cold blue moonlight wash
	_omni(Vector3(-6, 6.5, 0), Color(0.45, 0.55, 0.80), 0.25, 28.0)

	# Lobby entrance — two broken emergency red ceiling fixtures
	_spot(Vector3(16, 4.1, 0), Color(0.95, 0.12, 0.04), 1.0,  28.0, 10.0)
	_spot(Vector3(29, 4.1, 0), Color(0.95, 0.12, 0.04), 0.65, 24.0, 9.0)
	# Warm fill for desk area
	_omni(Vector3(19, 2.5, 0), Color(0.90, 0.55, 0.18), 0.30, 6.0)

	# Dark corridor — almost no light (lantern only)
	# A faint flicker suggestion at far end
	_omni(Vector3(54, 2.0, 0), Color(0.85, 0.25, 0.06), 0.18, 5.0)

	# Break room — green exit tint + spot
	_spot(Vector3(68, 4.2, 0), Color(0.82, 0.82, 0.88), 0.45, 32.0, 9.0)
	_omni(Vector3(57, 3.5, 0), Color(0.12, 0.65, 0.18), 0.22, 5.5)

	# Main lobby — dramatic spotlight cones from high ceiling
	_spot(Vector3(84,  5.8, 0), Color(0.88, 0.60, 0.18), 0.80, 22.0, 12.0)
	_spot(Vector3(93,  5.8, 0), Color(0.88, 0.60, 0.18), 0.55, 20.0, 10.0)
	_spot(Vector3(100, 5.8, 0), Color(0.88, 0.60, 0.18), 0.45, 18.0, 9.0)

	# Elevator green accent light
	_omni(Vector3(104, 2.0, 0.4), Color(0.10, 0.90, 0.25), 0.55, 3.5)

	# Maya's desk warm fill — the emotional center
	_omni(Vector3(94, 1.8, 0), Color(0.90, 0.70, 0.40), 0.35, 4.5)
