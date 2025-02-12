class_name InteractableUI extends Control

signal exited()

var interaction: Interaction = null

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(&"stop_inspect"):
		exited.emit()
