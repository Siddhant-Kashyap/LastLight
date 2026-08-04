extends Node

signal checkpoint_activated(checkpoint_id: String)
signal player_respawned

var _spawn_position: Vector3 = Vector3(0, 0.5, 0)
var _active_id: String = "start"

func _ready() -> void:
	Debug.print_info("CheckpointManager ready", "Checkpoint")

func set_checkpoint(world_position: Vector3, checkpoint_id: String = "") -> void:
	_spawn_position = world_position
	_active_id = checkpoint_id
	checkpoint_activated.emit(checkpoint_id)
	Debug.print_info("Checkpoint activated: '%s' at %s" % [checkpoint_id, str(world_position)], "Checkpoint")

func respawn_player() -> void:
	var players := get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return
	var player := players[0]
	player.global_position = _spawn_position
	player.velocity = Vector3.ZERO
	player_respawned.emit()
	Debug.print_info("Respawned at: " + str(_spawn_position), "Checkpoint")

func get_active_id() -> String:
	return _active_id
