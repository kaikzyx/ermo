class_name AimInterface extends Control


@onready var _label_interactable_name: Label = $InteractionContainer/InteractableContainer/InteractableName
@onready var _label_interactable_message: Label = $InteractionContainer/InteractableContainer/InteractableMessage
@onready var _label_interactable_action: Label = $InteractionContainer/InteractionAction

func _ready() -> void:
	if is_instance_valid(Global.actor):
		Global.actor.interator.focus_entered.connect(_on_actor_interator_focus_entered)
		Global.actor.interator.focus_exited.connect(_on_actor_interator_focus_exited)

	_label_interactable_action.hide()
	_label_interactable_action.text = &"Press " + Global.get_prompt(&"interact") + &" to interact."

func _on_actor_interator_focus_entered(interactable: Interactable) -> void:
	interactable.message_changed.connect(_on_actor_interator_interactable_message_changed)

	# Format the text with the message of the interactive, if any.
	_label_interactable_message.text = &""
	if not interactable.message.is_empty():
		_label_interactable_message.text = &" - " + interactable.message

	_label_interactable_name.text = interactable.owner.name.capitalize()
	_label_interactable_action.show()

func _on_actor_interator_focus_exited(interactable: Interactable) -> void:
	interactable.message_changed.disconnect(_on_actor_interator_interactable_message_changed)

	# Clear.
	_label_interactable_name.text = &""
	_label_interactable_message.text = &""
	_label_interactable_action.hide()

func _on_actor_interator_interactable_message_changed(message: StringName) -> void:
	# Dynamically updates the text when the interactable message changes.
	_label_interactable_message.text = &" - " + message
