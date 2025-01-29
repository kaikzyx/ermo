class_name AimInterface extends Control

@onready var _label_message: Label = $Message

func _ready() -> void:
	if is_instance_valid(Global.actor):
		Global.actor.interator.focus_entered.connect(_on_actor_interator_focus_entered)
		Global.actor.interator.focus_exited.connect(_on_actor_interator_focus_exited)

func _on_actor_interator_focus_entered(interactable: Interactable) -> void:
	interactable.message_changed.connect(_on_actor_interator_interactable_message_changed)

	# Format the text with the message of the interactive, if any.
	var message: StringName = &""
	if not interactable.message.is_empty(): message = &" - " + interactable.message

	_label_message.text =  &"{0}\nPress {1} to interact.".format(
		[interactable.owner.name.capitalize() + message, Global.get_prompt(&"interact")])

func _on_actor_interator_focus_exited(interactable: Interactable) -> void:
	interactable.message_changed.disconnect(_on_actor_interator_interactable_message_changed)
	_label_message.text = &""

func _on_actor_interator_interactable_message_changed(old: StringName, new: StringName) -> void:
	# Dynamically updates the text when the interactable message changes.
	_label_message.text = _label_message.text.replace(old, new)
