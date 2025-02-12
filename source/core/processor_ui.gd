class_name ProcessorUI extends Control

signal started_processing()
signal stopped_processing()

@onready var _processes: Control = $Processes
@onready var _exit_message_label: Label = $ExitMessage
var _processing: bool = false: set = _set_processing

func _ready() -> void:
	_processes.child_entered_tree.connect(_on_processes_child_entered_tree)
	_processes.child_exiting_tree.connect(_on_processes_child_exiting_tree)

	_exit_message_label.text = &"Exit: " + Global.get_prompt(&"stop_inspect")

func process(node: Control) -> void:
	_processes.add_child(node)

func processing() -> bool:
	return _processing

func _set_processing(value: bool) -> void:
	if _processing != value:
		_processing = value

		if _processing:
			started_processing.emit()
		else:
			stopped_processing.emit()

func _on_processes_child_entered_tree(_node: Node) -> void:
	# With some child.
	if _processes.get_child_count() == 1: _processing = true

func _on_processes_child_exiting_tree(_node: Node):
	# No child.
	await get_tree().process_frame
	if _processes.get_child_count() == 0: _processing = false
