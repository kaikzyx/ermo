class_name InteractableUI extends Control

var interaction: Interaction = null

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(&"stop_inspect"):
		queue_free()
