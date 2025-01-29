class_name ReadableInterface extends InteractableInterface

@onready var _label_exit_message: Label = $ExitMessage
@onready var _label_content: Label = $Content

func _ready() -> void:
	_label_exit_message.text = &"Exit: " + Global.get_prompt(&"stop_inspect")

 	# Show the readable content.
	if is_instance_valid(interaction):
		if interaction is Readable:
			_label_content.text = interaction.content
			return

	_label_content.text = &"<empty>"
