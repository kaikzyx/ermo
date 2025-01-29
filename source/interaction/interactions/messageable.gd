class_name Messageable extends Interaction

@export_multiline var message: String = ""

func interact(_interator: Interator) -> void:
	Global.main.messages.sent(message)
