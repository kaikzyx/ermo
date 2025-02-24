class_name Interaction extends Resource

var interactable: Interactable = null

func interact(_interactor: Interactor) -> bool:
	return true

func life() -> bool:
	return true
