extends Node3D

@export var actor: Player

@onready var _prompt: Label = $Interface/Control/Prompt

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Show player interaction information.
	if is_instance_valid(actor):
		var interator: Node = actor.find_child(&"Interator")
		if is_instance_valid(interator):
			if interator is Interator:
				interator.focus_entered.connect(func(interactable: Interactable) -> void:
					_prompt.text = interactable.message + &"\n" + _get_prompt()
					_prompt.show())
				interator.focus_exited.connect(func(_interactable: Interactable) -> void:
					_prompt.text = &""
					_prompt.hide())

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		# Toggle mouse mode between captured and visible.
		if event.pressed and event.keycode == KEY_ESCAPE:
			var captured: bool = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if captured else Input.MOUSE_MODE_CAPTURED

func _get_prompt() -> StringName:
	for event in InputMap.action_get_events(&"interact"):
		if event is InputEventKey:
			return &"Interact: [" + event.as_text_keycode() + &"]"

	return &"Keycode not found."
