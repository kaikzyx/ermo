class_name AimInterface extends Control

@onready var _prompt: Label = $Prompt

func _ready() -> void:
	# Show player interaction information.
	if is_instance_valid(Global.actor):
		Global.actor.interator.focus_entered.connect(_on_actor_interator_focus_entered)
		Global.actor.interator.focus_exited.connect(_on_actor_interator_focus_exited)

func _on_actor_interator_focus_entered(interactable: Interactable) -> void:
	_prompt.text = interactable.message + &"\nInteract: " + Global.get_prompt(&"interact")
	_prompt.show()

func _on_actor_interator_focus_exited(_interactable: Interactable) -> void:
	_prompt.text = &""
	_prompt.hide()
