class_name Readable extends Interaction

@export_multiline var content: String = &"Nothing to read."

var _scene_readable_ui: PackedScene = preload("res://source/interaction/readable_ui.tscn")

func interact(_interator: Interator) -> bool:
	# Create a readable ui when interacting.
	var readable_ui: ReadableUI = _scene_readable_ui.instantiate()
	readable_ui.interaction = self

	readable_ui.exited.connect(func() -> void:
		readable_ui.queue_free()
		Global.main.rest(false))

	Global.main.screen.add_child(readable_ui)
	Global.main.rest(true)

	return true
