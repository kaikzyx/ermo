class_name Interactable extends CollisionObject3D

signal interacted(interator: Interator)

@export var message: StringName
@export var enabled: bool = true

func interact(interator: Interator) -> bool:
	if not enabled: return false

	interacted.emit(interator)
	return true
