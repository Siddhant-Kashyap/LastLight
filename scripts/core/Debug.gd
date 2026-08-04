extends Node

var debug_mode: bool = true

func print_info(message: String, source: String = "") -> void:
	if not debug_mode:
		return
	if source.is_empty():
		print("[INFO] ", message)
	else:
		print("[INFO][", source, "] ", message)

func print_warning(message: String, source: String = "") -> void:
	if source.is_empty():
		push_warning("[WARN] " + message)
	else:
		push_warning("[WARN][" + source + "] " + message)

func print_error(message: String, source: String = "") -> void:
	if source.is_empty():
		push_error("[ERR] " + message)
	else:
		push_error("[ERR][" + source + "] " + message)
