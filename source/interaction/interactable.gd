class_name Interactable extends Area3D

signal interacted(interator: Interator)
signal message_changed(old: StringName, new: StringName)

@export var message: StringName:
	set(value): message_changed.emit(message, value); message = value
@export var interactions: Array[Interaction]

func interact(interator: Interator) -> bool:
	for interaction in interactions:
		interaction.interact(interator)

	interacted.emit(interator)
	return true
