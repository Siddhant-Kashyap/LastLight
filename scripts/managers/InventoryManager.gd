extends Node

signal item_added(item_id: String, count: int)
signal item_removed(item_id: String, count: int)
signal item_changed(item_id: String, count: int)

var _items: Dictionary = {}

func _ready() -> void:
	Debug.print_info("InventoryManager ready", "Inventory")

func add_item(item_id: String, count: int = 1) -> void:
	_items[item_id] = _items.get(item_id, 0) + count
	item_added.emit(item_id, _items[item_id])
	item_changed.emit(item_id, _items[item_id])
	Debug.print_info("Added %s x%d (total: %d)" % [item_id, count, _items[item_id]], "Inventory")

func remove_item(item_id: String, count: int = 1) -> bool:
	if not has_item(item_id):
		return false
	_items[item_id] = max(0, _items[item_id] - count)
	item_removed.emit(item_id, _items[item_id])
	item_changed.emit(item_id, _items[item_id])
	return true

func has_item(item_id: String) -> bool:
	return _items.get(item_id, 0) > 0

func get_count(item_id: String) -> int:
	return _items.get(item_id, 0)

func get_all_items() -> Dictionary:
	return _items.duplicate()

func clear() -> void:
	_items.clear()
