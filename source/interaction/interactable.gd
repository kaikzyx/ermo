class_name Interactable extends Area3D

signal interacted(interactor: Interactor)
signal message_changed(message: StringName)

@export var message: StringName:
	set(value): message = value; message_changed.emit(message)
@export var interactions: Array[Interaction] = []

func interact(interactor: Interactor) -> bool:
	for index in interactions.size():
		if not interactions[index].interact(interactor): return false
		if not interactions[index].life(): interactions.remove_at(index)

	interacted.emit(interactor)
	return true
