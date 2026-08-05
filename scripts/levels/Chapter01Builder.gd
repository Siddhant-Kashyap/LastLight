class_name Chapter01Builder
extends Node3D

const DEPTH: float = 3.0
const HD: float = 1.5  # half depth

# Shared materials
var _mat_concrete: StandardMaterial3D
var _mat_wall: StandardMaterial3D
var _mat_wall_dark: StandardMaterial3D
var _mat_back: StandardMaterial3D
var _mat_metal: StandardMaterial3D
var _mat_wood: StandardMaterial3D
var _mat_ceiling: StandardMaterial3D

func _ready() -> void:
	_make_materials()
	_build_exterior()
	_build_lobby_entrance()
	_build_dark_corridor()
	_build_break_room()
	_build_main_lobby()
	_build_rain()
	_build_interior_lights()

# ─── Material helpers ──────────────────────────────────────────────────────────

func _make_materials() -> void:
	_mat_concrete  = _mat(Color(0.18, 0.19, 0.21))
	_mat_wall      = _mat(Color(0.22, 0.22, 0.25))
	_mat_wall_dark = _mat(Color(0.10, 0.10, 0.12))
	_mat_back      = _mat(Color(0.12, 0.12, 0.14))
	_mat_metal     = _mat(Color(0.30, 0.30, 0.33))
	_mat_wood      = _mat(Color(0.27, 0.21, 0.14))
	_mat_ceiling   = _mat(Color(0.14, 0.14, 0.16))

func _mat(color: Color, rough: float = 0.88) -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = color
	m.roughness = rough
	return m

# ─── Geometry helpers ──────────────────────────────────────────────────────────

# Solid box with physics collision (floors, structural walls, climbable desks)
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

# Visual-only box (background, decoration, thin panels)
func _deco(pos: Vector3, sz: Vector3, mat: StandardMaterial3D) -> void:
	var mi := MeshInstance3D.new()
	mi.position = pos
	var mesh := BoxMesh.new()
	mesh.size = sz
	mi.mesh = mesh
	mi.material_override = mat
	add_child(mi)

# Cylinder — visual only (pipes, pillars)
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

# OmniLight3D for interior atmosphere
func _light(pos: Vector3, color: Color, energy: float, range_val: float) -> void:
	var l := OmniLight3D.new()
	l.position = pos
	l.light_color = color
	l.light_energy = energy
	l.omni_range = range_val
	l.shadow_enabled = true
	add_child(l)

# ─── SECTION 1: EXTERIOR ───────────────────────────────────────────────────────
# x: -22 to 10  |  open sky, rain, building entrance at x=10

func _build_exterior() -> void:
	# Ground
	_solid(Vector3(-6, -0.25, 0), Vector3(33, 0.5, DEPTH), _mat_concrete)

	# World boundary — left wall
	_solid(Vector3(-22, 2.5, 0), Vector3(0.5, 5.5, DEPTH), _mat_metal)

	# Building facade visible above door opening
	# Door gap: y 0→3  |  wall above: y 3→4.5
	_solid(Vector3(9.75, 3.75, 0), Vector3(0.5, 1.5, DEPTH), _mat_wall)

	# Background — building facade strip running the full exterior (visual depth)
	_deco(Vector3(-6, 5.0, -HD), Vector3(33, 3.0, 0.2), _mat_wall_dark)

	# Debris left side (crate stack near boundary)
	_solid(Vector3(-18, 0.65, 0.0), Vector3(2.5, 1.3, 1.6), _mat_wood)
	_solid(Vector3(-18, 1.55, 0.0), Vector3(1.6, 0.8, 1.0), _mat_wood)
	_deco(Vector3(-14.8, 0.35, 0.2), Vector3(0.7, 0.7, 0.7), _mat_metal)   # barrel

	# Loose debris near entrance
	_deco(Vector3(4.5, 0.18, 0.4),  Vector3(1.2, 0.35, 0.7), _mat_wood)
	_deco(Vector3(2.0, 0.12, -0.3), Vector3(0.6, 0.25, 0.5), _mat_metal)
	_deco(Vector3(7.0, 0.12, 0.3),  Vector3(0.4, 0.25, 0.4), _mat_metal)

	# Horizontal pipe above entrance
	_pipe(Vector3(-6, 3.8, -0.5), 0.09, 34, _mat_metal, PI * 0.5)

# ─── SECTION 2: LOBBY ENTRANCE ────────────────────────────────────────────────
# x: 10 to 35  |  ceiling y=4.5  |  security desk, dim emergency lighting

func _build_lobby_entrance() -> void:
	var cx: float = 22.5
	var w:  float = 25.0
	var cy: float = 4.5

	_solid(Vector3(cx, -0.25, 0), Vector3(w, 0.5, DEPTH),   _mat_concrete)
	_solid(Vector3(cx, cy + 0.25, 0), Vector3(w, 0.5, DEPTH), _mat_ceiling)
	_solid(Vector3(35, cy * 0.5, 0), Vector3(0.5, cy + 0.5, DEPTH), _mat_wall)
	_deco(Vector3(cx, cy * 0.5, -HD), Vector3(w, cy + 0.5, 0.2), _mat_back)

	# Overhead pipe
	_pipe(Vector3(cx, cy - 0.3, -0.5), 0.09, w, _mat_metal, PI * 0.5)

	# Security desk (player can jump on it)
	_solid(Vector3(19, 0.65, 0), Vector3(4.0, 0.8, 1.3), _mat_metal)
	_deco(Vector3(17.2, 0.65, 0), Vector3(0.3, 0.7, 1.3), _mat_metal)   # left panel
	_deco(Vector3(20.8, 0.65, 0), Vector3(0.3, 0.7, 1.3), _mat_metal)   # right panel
	_deco(Vector3(19, 0.65, -0.65), Vector3(4.0, 0.7, 0.3), _mat_metal) # back panel

	# Equipment on desk
	_deco(Vector3(18.2, 1.2, -0.4), Vector3(1.0, 0.65, 0.1),  _mat_metal)  # monitor
	_deco(Vector3(19.2, 0.88, -0.1), Vector3(1.0, 0.08, 0.55), _mat_metal) # keyboard
	_deco(Vector3(20.4, 0.95, -0.3), Vector3(0.55, 0.35, 0.4), _mat_metal) # radio

	# Toppled chair
	_deco(Vector3(21.5, 0.25, 0.5), Vector3(0.75, 0.55, 0.75), _mat_metal)

	# Filing cabinet (right wall)
	_solid(Vector3(33.2, 1.05, -0.55), Vector3(1.0, 2.1, 0.65), _mat_metal)

	# Fallen papers / debris
	_deco(Vector3(16, 0.08, 0.3), Vector3(2.5, 0.04, 1.2), _mat(Color(0.45, 0.43, 0.40)))

# ─── SECTION 3: DARK CORRIDOR ─────────────────────────────────────────────────
# x: 35 to 55  |  ceiling y=3.5  |  lower, narrower, pitch black — lantern only

func _build_dark_corridor() -> void:
	var cx: float = 45.0
	var w:  float = 20.0
	var cy: float = 3.5

	_solid(Vector3(cx, -0.25, 0), Vector3(w, 0.5, DEPTH), _mat_concrete)
	_solid(Vector3(cx, cy + 0.25, 0), Vector3(w, 0.5, DEPTH), _mat_ceiling)
	_solid(Vector3(35, cy * 0.5, 0), Vector3(0.5, cy + 0.5, DEPTH), _mat_wall_dark)
	_solid(Vector3(55, cy * 0.5, 0), Vector3(0.5, cy + 0.5, DEPTH), _mat_wall_dark)
	_deco(Vector3(cx, cy * 0.5, -HD), Vector3(w, cy + 0.5, 0.2), _mat_wall_dark)

	# Pipes on ceiling
	_pipe(Vector3(cx, cy - 0.2, -0.55), 0.085, w, _mat_metal, PI * 0.5)
	_pipe(Vector3(cx, cy - 0.14, 0.25), 0.06, w,  _mat_metal, PI * 0.5)

	# Vertical pipe drops from ceiling
	_pipe(Vector3(40, cy - 1.1, -0.55), 0.085, 2.4, _mat_metal)
	_pipe(Vector3(50, cy - 0.9, -0.55), 0.085, 2.0, _mat_metal)

	# Fallen crate blocking part of path (player must jump)
	_solid(Vector3(38.5, 0.55, 0.1), Vector3(1.6, 1.1, 1.3), _mat_wood)
	_deco(Vector3(47.5, 0.15, -0.3), Vector3(0.6, 0.3, 0.5), _mat_metal)

	# Warning sign on wall (decorative flat box)
	_deco(Vector3(35.1, 2.2, 0.3), Vector3(0.05, 0.55, 0.7), _mat(Color(0.6, 0.4, 0.05)))

# ─── SECTION 4: BREAK ROOM ────────────────────────────────────────────────────
# x: 55 to 78  |  ceiling y=4.5  |  table, chairs, vending machine

func _build_break_room() -> void:
	var cx: float = 66.5
	var w:  float = 23.0
	var cy: float = 4.5

	_solid(Vector3(cx, -0.25, 0), Vector3(w, 0.5, DEPTH), _mat_concrete)
	_solid(Vector3(cx, cy + 0.25, 0), Vector3(w, 0.5, DEPTH), _mat_ceiling)
	_solid(Vector3(78, cy * 0.5, 0), Vector3(0.5, cy + 0.5, DEPTH), _mat_wall)
	_deco(Vector3(cx, cy * 0.5, -HD), Vector3(w, cy + 0.5, 0.2), _mat_back)

	# Back-wall window suggestion
	_deco(Vector3(63.5, 2.5, -HD + 0.05), Vector3(4.2, 2.0, 0.1), _mat(Color(0.05, 0.08, 0.12)))
	_deco(Vector3(63.5, 2.5, -HD + 0.07), Vector3(0.06, 2.0, 0.06), _mat_metal) # center bar
	_deco(Vector3(63.5, 3.5, -HD + 0.07), Vector3(4.2, 0.06, 0.06), _mat_metal) # horizontal bar

	# Overhead pipe
	_pipe(Vector3(cx, cy - 0.3, -0.5), 0.09, w, _mat_metal, PI * 0.5)

	# Break table (solid — player can jump on it)
	_solid(Vector3(64, 0.65, 0), Vector3(3.5, 0.8, 1.3), _mat_wood)
	_deco(Vector3(62.4, 0.2, 0.45), Vector3(0.25, 0.55, 0.25), _mat_metal) # leg fl
	_deco(Vector3(65.6, 0.2, 0.45), Vector3(0.25, 0.55, 0.25), _mat_metal) # leg fr
	_deco(Vector3(62.4, 0.2, -0.45), Vector3(0.25, 0.55, 0.25), _mat_metal) # leg bl
	_deco(Vector3(65.6, 0.2, -0.45), Vector3(0.25, 0.55, 0.25), _mat_metal) # leg br

	# Chairs (one upright, one toppled for atmosphere)
	_deco(Vector3(66.5, 0.55, -0.75), Vector3(0.72, 1.0, 0.72), _mat_metal) # upright
	_deco(Vector3(62.0, 0.28, 0.55), Vector3(0.72, 0.6, 0.72), _mat_metal)  # fallen

	# Vending machine (solid — blocks path)
	_solid(Vector3(76.8, 0.95, -0.5), Vector3(0.9, 1.9, 0.75), _mat_metal)
	_deco(Vector3(76.35, 1.05, -0.5), Vector3(0.06, 1.0, 0.5), _mat(Color(0.04, 0.08, 0.14))) # screen

	# Mugs / debris on table
	_deco(Vector3(63.5, 1.1, 0.2),  Vector3(0.25, 0.3, 0.25), _mat_metal)
	_deco(Vector3(65.2, 1.1, -0.1), Vector3(0.2, 0.25, 0.2),  _mat_metal)

# ─── SECTION 5: MAIN LOBBY ────────────────────────────────────────────────────
# x: 78 to 108  |  ceiling y=6.0  |  tall, imposing, elevator at far right

func _build_main_lobby() -> void:
	var cx: float = 93.0
	var w:  float = 30.0
	var cy: float = 6.0

	_solid(Vector3(cx, -0.25, 0), Vector3(w, 0.5, DEPTH), _mat_concrete)
	_solid(Vector3(cx, cy + 0.25, 0), Vector3(w, 0.5, DEPTH), _mat_ceiling)
	_deco(Vector3(cx, cy * 0.5, -HD), Vector3(w, cy + 0.5, 0.2), _mat_back)

	# Right wall — elevator cut: door gap x=101→107, y=0→3.5
	# Right end cap
	_solid(Vector3(108.25, cy * 0.5, 0), Vector3(0.5, cy + 0.5, DEPTH), _mat_wall)
	# Wall above elevator
	_solid(Vector3(104, cy - 1.25, 0), Vector3(7.0, 2.5, DEPTH), _mat_wall)
	# Elevator door jambs
	_solid(Vector3(100.85, 1.75, 0), Vector3(0.3, 3.5, DEPTH), _mat_metal)
	_solid(Vector3(107.15, 1.75, 0), Vector3(0.3, 3.5, DEPTH), _mat_metal)

	# Elevator door panels (closed, decorative — player goal)
	_deco(Vector3(102.8, 1.75, 0.05), Vector3(2.6, 3.45, 0.14), _mat_metal)
	_deco(Vector3(105.2, 1.75, 0.05), Vector3(2.6, 3.45, 0.14), _mat_metal)
	# Center seam
	_deco(Vector3(104, 1.75, 0.12), Vector3(0.06, 3.45, 0.06), _mat(Color(0.04, 0.04, 0.05)))
	# Button panel
	_deco(Vector3(100.7, 1.5, 0.3), Vector3(0.08, 0.6, 0.35), _mat_metal)
	_deco(Vector3(100.64, 1.5, 0.3), Vector3(0.05, 0.18, 0.18), _mat(Color(0.05, 0.35, 0.1))) # green button

	# Structural columns (background, no collision needed)
	_deco(Vector3(82.0, cy * 0.5, -0.8), Vector3(0.55, cy, 0.55), _mat_concrete)
	_deco(Vector3(98.0, cy * 0.5, -0.8), Vector3(0.55, cy, 0.55), _mat_concrete)

	# Overhead pipes
	_pipe(Vector3(cx, cy - 0.4, -0.5), 0.11, w, _mat_metal, PI * 0.5)
	_pipe(Vector3(cx, cy - 0.6, 0.3),  0.07, w, _mat_metal, PI * 0.5)

	# Reception desk
	_solid(Vector3(86.5, 0.65, 0), Vector3(5.2, 0.82, 1.4), _mat_metal)
	_deco(Vector3(84.0, 0.38, 0), Vector3(0.28, 0.7, 1.4), _mat_metal)
	_deco(Vector3(89.0, 0.38, 0), Vector3(0.28, 0.7, 1.4), _mat_metal)
	_deco(Vector3(86.5, 0.38, -0.7), Vector3(5.2, 0.7, 0.3), _mat_metal)

	# Maya's workstation
	_solid(Vector3(94, 0.55, -0.15), Vector3(2.8, 0.72, 1.1), _mat_wood)
	_deco(Vector3(94, 1.22, -0.62), Vector3(1.3, 0.85, 0.08), _mat_metal)  # monitor
	_deco(Vector3(94, 0.92, -0.08), Vector3(1.1, 0.08, 0.55), _mat_metal)  # keyboard
	# Photo frame (key emotional prop)
	_deco(Vector3(95.0, 0.98, -0.58), Vector3(0.28, 0.38, 0.05), _mat(Color(0.55, 0.50, 0.44)))
	# Coffee mug
	_deco(Vector3(93.0, 0.98, -0.45), Vector3(0.22, 0.28, 0.22), _mat(Color(0.3, 0.22, 0.15)))

	# Stacked boxes near reception
	_solid(Vector3(81.5, 0.55, -0.4), Vector3(1.5, 1.1, 1.1), _mat_wood)
	_solid(Vector3(81.5, 1.3, -0.4),  Vector3(1.2, 0.8, 0.9), _mat_wood)

# ─── RAIN ────────────────────────────────────────────────────────────────────

func _build_rain() -> void:
	var rain := GPUParticles3D.new()
	rain.position = Vector3(-6, 13, 0)
	rain.amount = 700
	rain.lifetime = 1.8
	rain.preprocess = 1.5
	rain.emitting = true
	rain.draw_passes = 1
	rain.visibility_aabb = AABB(Vector3(-18, -14, -2), Vector3(36, 15, 4))

	var pm := ParticleProcessMaterial.new()
	pm.direction = Vector3(0.1, -1.0, 0.0)
	pm.spread = 3.0
	pm.gravity = Vector3(0.0, -22.0, 0.0)
	pm.initial_velocity_min = 10.0
	pm.initial_velocity_max = 16.0
	pm.emission_shape = ParticleProcessMaterial.EMISSION_SHAPE_BOX
	pm.emission_box_extents = Vector3(16.0, 0.5, 0.8)
	pm.color = Color(0.60, 0.70, 0.88, 0.6)
	pm.scale_min = 0.85
	pm.scale_max = 1.2
	rain.process_material = pm

	var quad := QuadMesh.new()
	quad.size = Vector2(0.022, 0.45)

	var rm := StandardMaterial3D.new()
	rm.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	rm.albedo_color = Color(0.62, 0.72, 0.90, 0.52)
	rm.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	rm.cull_mode = BaseMaterial3D.CULL_DISABLED
	quad.material = rm

	rain.draw_pass_1 = quad
	add_child(rain)

# ─── INTERIOR ATMOSPHERIC LIGHTS ─────────────────────────────────────────────

func _build_interior_lights() -> void:
	# Lobby entrance — emergency red light
	_light(Vector3(22, 3.8, 0), Color(0.9, 0.15, 0.05), 0.6, 12.0)
	# Second lobby light (flicker handled by LanternController atmosphere)
	_light(Vector3(30, 3.5, 0), Color(0.85, 0.20, 0.05), 0.35, 8.0)

	# Break room — faint green emergency exit sign glow
	_light(Vector3(57.5, 3.8, 0), Color(0.05, 0.5, 0.12), 0.3, 6.0)

	# Main lobby — low amber emergency light
	_light(Vector3(84, 5.2, 0), Color(0.9, 0.55, 0.1), 0.5, 14.0)
	_light(Vector3(100, 5.2, 0), Color(0.9, 0.55, 0.1), 0.4, 10.0)

	# Elevator button glow
	_light(Vector3(101, 1.5, 0.5), Color(0.1, 0.9, 0.3), 0.4, 2.0)
