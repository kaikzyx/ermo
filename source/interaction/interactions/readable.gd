class_name Readable extends Interaction

@export_multiline var content: String = &"Nothing to read."

var _scene_readable_interface: PackedScene = load("res://source/interface/interactables/readable_interface.tscn")

func interact(_interator: Interator) -> void:
	# Create a readable interface when interacting.
	if not _scene_readable_interface.can_instantiate(): return

	var readable_interface: ReadableInterface = _scene_readable_interface.instantiate()
	readable_interface.interaction = self

	readable_interface.exited.connect(func() -> void:
		readable_interface.queue_free()
		Global.main.rest(false))

	Global.main.interface.add_child(readable_interface)
	Global.main.rest(true)
