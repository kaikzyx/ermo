class_name Inventory extends Node

signal refreshed(index: int)
signal inserted(index: int, leaking: bool)
signal removed(index: int, leaking: bool)
signal selected(from: int, to: int)

@export var minimum_slots: int = 9
var slot_index_selected: int = -1: set = _set_slot_index_selected

var _slots: Array[Item] = []

func _ready() -> void:
	_slots.resize(minimum_slots)

func insert(item: Item) -> void:
	# Try to fill existing empty slots first.
	for index in _slots.size():
		if _slots[index] == null:
			_slots[index] = item
			inserted.emit(index, false)
			refreshed.emit(index)
			return
	
	# If no empty slots, add new slot.
	_slots.push_back(item)
	inserted.emit(_slots.size() - 1, true)
	refreshed.emit(_slots.size() - 1)

func remove(index: int) -> void:
	if not _can_index(index): return
	
	if _slots.size() > minimum_slots:
		# Only remove slot if above minimum capacity.
		_slots.remove_at(index)
		removed.emit(index, true)
	else:
		# Otherwise just clear slot.
		_slots[index] = null
		removed.emit(index, false)
		refreshed.emit(index)

	slot_index_selected = -1

func request(item: Item) -> bool:
	if slot_index_selected != -1 and _slots[slot_index_selected] == item:
		remove(slot_index_selected)
		return true

	return false

func swap(fist: int, second: int) -> void:
	if fist == second or not _can_index(fist) or not _can_index(second): return

	var temporary: Item = _slots[fist]
	_slots[fist] = _slots[second]
	_slots[second] = temporary
	refreshed.emit(fist); refreshed.emit(second) 

func get_item(index: int) -> Item:
	if _can_index(index):
		return _slots[index]

	return null

func size() -> int:
	return _slots.size()

func _can_index(index: int) -> bool:
	return index > -1 and index < _slots.size()

func _set_slot_index_selected(value: int) -> void:
	value = clamp(value, -1, _slots.size() - 1)

	if slot_index_selected != value:
		selected.emit(slot_index_selected, value)
		slot_index_selected = value
