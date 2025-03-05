class_name Interactor extends RayCast3D

signal focus_entered(interactable: Interactable)
signal focus_exited(interactable: Interactable)
signal interacted(interactable: Interactable, successful: bool)

var _interactable_id: int = 0

func _process(_delta: float) -> void:
	if not enabled: return

	var collider_id: int = 0

	# If there is an interactable being focused.
	if is_colliding() and get_collider() is Interactable:
		collider_id = get_collider().get_instance_id()

		if Input.is_action_just_pressed(&"interact"):
			var interactable: Interactable = instance_from_id(collider_id)
			interacted.emit(interactable, interactable.interact(self))

	# Handle signals.
	if _interactable_id != collider_id:
		if _interactable_id != 0:
			focus_exited.emit(instance_from_id(_interactable_id) if is_instance_id_valid(_interactable_id) else null)
		if is_instance_id_valid(collider_id): focus_entered.emit(instance_from_id(collider_id))
		_interactable_id = collider_id
