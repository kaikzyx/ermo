class_name Interactable extends CollisionObject3D

signal interacted(interator: Interator)

@export var message: StringName

func interact(interator: Interator) -> bool:
	interacted.emit(interator)
	return true
