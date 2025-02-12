class_name InventorySlotUI extends Button

signal selected(index: int)

enum State { NONE, HIGHLIGHT, SELECT }

var state: State = State.NONE: set = _set_state
var slot_index: int = -1
var has_item: bool = false

@onready var _background: Panel = $Background
@onready var _label: Label = $Margin/Label

func _ready() -> void:
	pressed.connect(func() -> void: select())

func refresh(item: Item) -> void:
	has_item = item != null
	_label.text = item.name if has_item else &"" 

func select() -> void:
	selected.emit(slot_index)

func _set_state(value: State) -> void:
	state = value

	match value:
		State.NONE:
			_background.self_modulate.a = 1.0
		State.HIGHLIGHT:
			_background.self_modulate.a = 0.5
		State.SELECT:
			_background.self_modulate.a = 0.1
