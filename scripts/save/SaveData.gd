class_name SaveData
extends Resource

@export var save_version: int = Constants.SAVE_FILE_VERSION
@export var chapter: int = 0
@export var checkpoint: String = ""
@export var player_position: Vector3 = Vector3.ZERO
@export var inventory: Dictionary = {}
@export var fuel: float = Constants.MAX_FUEL
@export var collectibles: Array[String] = []
@export var settings: Dictionary = {}
@export var timestamp: int = 0
