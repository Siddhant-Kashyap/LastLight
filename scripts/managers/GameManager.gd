extends Node

signal game_started
signal game_paused(is_paused: bool)
signal game_over
signal chapter_changed(chapter: int)

var current_chapter: int = 0
var is_paused: bool = false

func _ready() -> void:
	print("[GameManager] initialized")

func pause_game() -> void:
	is_paused = true
	get_tree().paused = true
	game_paused.emit(true)

func resume_game() -> void:
	is_paused = false
	get_tree().paused = false
	game_paused.emit(false)

func set_chapter(chapter: int) -> void:
	current_chapter = chapter
	chapter_changed.emit(chapter)
	Debug.print_info("Chapter set to: " + str(chapter), "GameManager")
