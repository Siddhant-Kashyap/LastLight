class_name GameSettings
extends Resource

@export_range(0.0, 1.0) var master_volume: float = 1.0
@export_range(0.0, 1.0) var music_volume: float = 0.8
@export_range(0.0, 1.0) var sfx_volume: float = 1.0
@export_range(0.0, 2.0) var brightness: float = 1.0
@export var fullscreen: bool = false
@export var language: String = "en"
@export var controller_vibration: bool = true
@export_range(0.0, 1.0) var camera_shake_intensity: float = 1.0
