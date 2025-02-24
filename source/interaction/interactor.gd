class_name Interactor extends RayCast3D

signal focus_entered(interactable: Interactable)
signal focus_exited(interactable: Interactable)
signal interacted(interactable: Interactable, successful: bool)

var focus: Interactable = null

func _process(_delta: float) -> void:
	if not enabled: return

	var collider: Object = get_collider() if is_colliding() else null
	var interactable: Interactable = collider if collider is Interactable else null
	var interactable_exists: bool = is_instance_valid(interactable)

	# If the current focus is no longer valid, emit the exit signal and reset it.
	if focus and not is_instance_valid(focus):
		focus_exited.emit(null)
		focus = null

	# Handle signals.
	if focus != interactable:
		if is_instance_valid(focus): focus_exited.emit(focus)
		if interactable_exists: focus_entered.emit(interactable)
		focus = interactable

	if interactable_exists and Input.is_action_just_pressed(&"interact"):
		interacted.emit(interactable, interactable.interact(self))
