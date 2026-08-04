extends Node

signal music_started(track_name: String)
signal music_stopped
signal sfx_played(sfx_name: String)

var _master_volume: float = 1.0
var _music_volume: float = 0.8
var _sfx_volume: float = 1.0

func _ready() -> void:
	print("[AudioManager] initialized")

func set_master_volume(value: float) -> void:
	_master_volume = clampf(value, 0.0, 1.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(_master_volume))

func set_music_volume(value: float) -> void:
	_music_volume = clampf(value, 0.0, 1.0)

func set_sfx_volume(value: float) -> void:
	_sfx_volume = clampf(value, 0.0, 1.0)

func play_music(_track_name: String) -> void:
	Debug.print_info("play_music() placeholder: " + _track_name, "AudioManager")
	music_started.emit(_track_name)

func stop_music() -> void:
	Debug.print_info("stop_music() placeholder", "AudioManager")
	music_stopped.emit()

func play_sfx(_sfx_name: String) -> void:
	Debug.print_info("play_sfx() placeholder: " + _sfx_name, "AudioManager")
	sfx_played.emit(_sfx_name)
