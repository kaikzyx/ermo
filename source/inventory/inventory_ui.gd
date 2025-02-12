class_name InventoryUI extends ScrollContainer


@onready var _container: VBoxContainer = $Container
var _scene_inventory_slot_ui: PackedScene = preload("res://source/inventory/inventory_slot_ui.tscn")
var _inventory: Inventory = null
var _slot_highlight_index: int = -1: set = _set_slot_highlight_index

func initialize(inventory: Inventory) -> void:
	_inventory = inventory

	_inventory.refreshed.connect(_on_slot_refreshed)
	_inventory.inserted.connect(_on_slot_inserted)
	_inventory.removed.connect(_on_slot_removed)
	_inventory.selected.connect(_on_slot_selected)

	# Clear children.
	for child in _container.get_children():
		child.queue_free()

	for index in _inventory.size():
		_create_inventory_slot_ui(index)

	_slot_highlight_index = 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if not event.pressed: return

		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				_slot_highlight_index -= 1
			MOUSE_BUTTON_WHEEL_DOWN:
				_slot_highlight_index += 1
			MOUSE_BUTTON_MIDDLE:
				_get_inventory_slot_ui(_slot_highlight_index).select()

func _create_inventory_slot_ui(index: int) -> InventorySlotUI:
	var inventory_slot_ui: InventorySlotUI = _scene_inventory_slot_ui.instantiate()
	inventory_slot_ui.selected.connect(_on_inventory_slot_ui_selected)
	inventory_slot_ui.slot_index = index
	_container.add_child(inventory_slot_ui)
	return inventory_slot_ui

func _get_inventory_slot_ui(index: int) -> InventorySlotUI:
	if index > -1 and index < _container.get_child_count():
		return _container.get_child(index)

	return null

func _set_slot_highlight_index(value: int) -> void:
	value = clamp(value, 0, _container.get_child_count() - 1)
	if _slot_highlight_index == value: return

	var old_inventory_slot_ui: InventorySlotUI = _get_inventory_slot_ui(_slot_highlight_index)
	if is_instance_valid(old_inventory_slot_ui) and old_inventory_slot_ui.state != InventorySlotUI.State.SELECT:
		old_inventory_slot_ui.state = InventorySlotUI.State.NONE

	var inventory_slot_ui: InventorySlotUI = _get_inventory_slot_ui(value)
	if inventory_slot_ui.state != InventorySlotUI.State.SELECT:
		inventory_slot_ui.state = InventorySlotUI.State.HIGHLIGHT
	inventory_slot_ui.grab_focus()

	_slot_highlight_index = value

func _on_inventory_slot_ui_selected(index: int) -> void:
	_inventory.slot_index_selected = index
	_slot_highlight_index = index

func _on_slot_refreshed(index: int) -> void:
	_get_inventory_slot_ui(index).refresh(_inventory.get_item(index))

func _on_slot_inserted(index: int, leaking: bool) -> void:
	var item: Item = _inventory.get_item(index)
	Global.main.information.sent(item.name, InformationInterface.Information.ITEM)

	if leaking: _create_inventory_slot_ui(_inventory.size()).refresh(item)

func _on_slot_removed(index: int, leaking: bool) -> void:
	if leaking: _get_inventory_slot_ui(index).queue_free()

func _on_slot_selected(from: int, to: int) -> void:
	var old_inventory_slot_ui: InventorySlotUI = _get_inventory_slot_ui(from)
	if is_instance_valid(old_inventory_slot_ui):
		var condition: bool = from != _slot_highlight_index
		old_inventory_slot_ui.state = InventorySlotUI.State.NONE if condition else InventorySlotUI.State.HIGHLIGHT

	var inventory_slot_ui: InventorySlotUI = _get_inventory_slot_ui(to)
	if is_instance_valid(inventory_slot_ui):
		inventory_slot_ui.state = InventorySlotUI.State.SELECT
		inventory_slot_ui.grab_focus()

		if inventory_slot_ui.has_item:
			Global.main.information.sent(_inventory.get_item(to).name, InformationInterface.Information.ITEM)
