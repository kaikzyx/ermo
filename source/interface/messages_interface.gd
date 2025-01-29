class_name MessagesInterface extends Control

@onready var _container: VBoxContainer = $Container

func sent(message: StringName) -> void:
	# shows a message for a while and then erases it.
	if message.is_empty(): return

	var label: Label = Label.new()
	label.text = message
	_container.add_child(label)

	await get_tree().create_timer(1).timeout
	label.queue_free()
