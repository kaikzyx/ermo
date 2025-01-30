class_name Interactable extends Area3D

signal interacted(interator: Interator)
signal message_changed(message: StringName)

@export var message: StringName:
	set(value): message = value; message_changed.emit(message)
@export var interactions: Array[Interaction] = []

func interact(interator: Interator) -> bool:
	for index in interactions.size():
		if not interactions[index].interact(interator): return false
		if not interactions[index].life(): interactions.remove_at(index)

	interacted.emit(interator)
	return true
