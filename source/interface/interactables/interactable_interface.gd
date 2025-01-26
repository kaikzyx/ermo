class_name InteractableInterface extends Control

signal exited()

var interactable: Interactable = null

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(&"stop_inspect"):
		exited.emit()
