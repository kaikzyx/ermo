class_name Messageable extends Interaction

@export_multiline var message: String = ""

func interact(_interator: Interator) -> bool:
	Global.main.information.sent(message, InformationUI.Information.MESSAGE)
	return true
