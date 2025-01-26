class_name Interator extends RayCast3D

signal focus_entered(interactable: Interactable)
signal focus_exited(interactable: Interactable)
signal interacted(interactable: Interactable, successful: bool)

var focus: Interactable

func _process(_delta: float) -> void:
	var collider: Object = get_collider() if is_colliding() else null
	var interactable: Interactable = collider if collider is Interactable else null
	var interactable_exists: bool = is_instance_valid(interactable)

	# Handle signals.
	if focus != interactable:
		if is_instance_valid(focus): focus_exited.emit(focus)
		if interactable_exists: focus_entered.emit(interactable)
		focus = interactable

	if interactable_exists and Input.is_action_just_pressed(&"interact"):
		interacted.emit(interactable, interactable.interact(self))
