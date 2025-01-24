class_name Interator extends RayCast3D

signal interacted(interactable: Interactable, successful: bool)
signal focus_entered(interactable: Interactable)
signal focus_exited(interactable: Interactable)

var focus: Interactable

func _process(_delta: float) -> void:
	# Clear.
	if not is_colliding():
		focus_exited.emit(focus)
		focus = null
		return

	var collider: Object = get_collider()

	if collider is Interactable:
		# Handle signals.
		if focus != collider:
			if is_instance_valid(focus): focus_exited.emit(focus)
			focus_entered.emit(collider)
			focus = collider

		if Input.is_action_just_pressed(&"interact"):
			interacted.emit(collider, collider.interact(self))
