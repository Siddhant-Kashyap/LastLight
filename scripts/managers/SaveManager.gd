extends Node

signal save_completed
signal load_completed
signal save_failed(error: String)
signal load_failed(error: String)

func _ready() -> void:
	print("[SaveManager] initialized")

func save_game(_data: Dictionary) -> void:
	Debug.print_info("save_game() placeholder called", "SaveManager")
	# TODO: Serialize SaveData resource and write to Constants.SAVE_PATH
	save_completed.emit()

func load_game() -> Dictionary:
	Debug.print_info("load_game() placeholder called", "SaveManager")
	# TODO: Read and deserialize SaveData resource from Constants.SAVE_PATH
	load_completed.emit()
	return {}

func save_settings(_settings: Resource) -> void:
	Debug.print_info("save_settings() placeholder called", "SaveManager")
	# TODO: Save GameSettings resource to Constants.SETTINGS_PATH

func load_settings() -> Resource:
	Debug.print_info("load_settings() placeholder called", "SaveManager")
	# TODO: Load GameSettings resource from Constants.SETTINGS_PATH
	return null

func has_save() -> bool:
	return FileAccess.file_exists(Constants.SAVE_PATH)
