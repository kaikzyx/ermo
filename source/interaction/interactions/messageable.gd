class_name Messageable extends Interaction

@export_multiline var message: String = ""

func interact(_interactor: Interactor) -> bool:
	Global.main.information.sent(message, InformationUI.Information.MESSAGE)
	return true
