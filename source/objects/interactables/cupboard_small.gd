extends StaticBody3D

var open: bool = false

@onready var _interactable: Interactable = $Interactable

func _ready() -> void:
	_interactable.interacted.connect(func(_interator: Interator) -> void:
		_interactable.message = &"Open." if open else &"Close."; open = not open)
