extends Node

signal scene_load_started(scene_path: String)
signal scene_load_completed(scene_path: String)
signal fade_started
signal fade_completed

var _current_scene_path: String = ""
var _is_loading: bool = false

func _ready() -> void:
	print("[SceneManager] initialized")

func load_scene(scene_path: String, use_fade: bool = true) -> void:
	if _is_loading:
		Debug.print_warning("Scene load already in progress", "SceneManager")
		return
	_is_loading = true
	_current_scene_path = scene_path
	scene_load_started.emit(scene_path)
	if use_fade:
		fade_out()
	Debug.print_info("load_scene() placeholder: " + scene_path, "SceneManager")
	# TODO: Implement actual scene swap via get_tree().change_scene_to_file()
	_is_loading = false
	scene_load_completed.emit(scene_path)

func unload_scene() -> void:
	Debug.print_info("unload_scene() placeholder", "SceneManager")
	_current_scene_path = ""

func fade_in(duration: float = 0.5) -> void:
	fade_started.emit()
	Debug.print_info("fade_in() placeholder, duration: " + str(duration), "SceneManager")
	# TODO: Animate CanvasLayer ColorRect alpha 1 -> 0 over duration
	fade_completed.emit()

func fade_out(duration: float = 0.5) -> void:
	Debug.print_info("fade_out() placeholder, duration: " + str(duration), "SceneManager")
	# TODO: Animate CanvasLayer ColorRect alpha 0 -> 1 over duration

func get_current_scene_path() -> String:
	return _current_scene_path
