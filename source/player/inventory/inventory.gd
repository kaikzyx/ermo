class_name Inventory extends Node

signal refreshed(index: int)
signal removed(index: int)

@export var minimun: int = 1

var _slots: Array[Item] = []

func _ready() -> void:
	_slots.resize(minimun)

func insert(item: Item) -> void:
	# Try to fill existing empty slots first.
	for index in _slots.size():
		if _slots[index] == null:
			_slots[index] = item
			refreshed.emit(index)
			return
	
	# If no empty slots, add new slot.
	_slots.push_back(item)
	refreshed.emit(_slots.size() - 1)

func remove(index: int) -> void:
	if index <= -1 or index >= _slots.size(): return
	
	if _slots.size() > minimun:
		# Only remove slot if above minimum capacity.
		_slots.remove_at(index)
		removed.emit(index)
	else:
		# Otherwise just clear slot.
		_slots[index] = null
		refreshed.emit(index)

func request(item: Item) -> int:
	return _slots.find(item)
