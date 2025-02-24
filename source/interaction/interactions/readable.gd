class_name Readable extends Interaction

@export_multiline var content: String = &"Nothing to read."

var _scene_readable_ui: PackedScene = preload("res://source/interaction/readable_ui.tscn")

func interact(_interactor: Interactor) -> bool:
	# Create a readable ui when interacting.
	var readable_ui: ReadableUI = _scene_readable_ui.instantiate()
	readable_ui.interaction = self
	Global.main.processor.process(readable_ui)

	return true
