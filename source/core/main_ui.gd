class_name MainUI extends CanvasLayer

@onready var processor: ProcessorUI = $Container/Margin/Canvas/Screen/ProcessorUI
@onready var information: InformationUI = $Container/Margin/Canvas/Screen/InformationUI
var resting: bool = false: set = _set_resting

@onready var _viewport: SubViewport = $Container/Margin/Canvas/ViewportContainer/Viewport
@onready var _aim_ui: AimUI = $Container/Margin/Canvas/Screen/AimUI
@onready var _inventory_ui: InventoryUI = $Container/SideBar/Margin/InventoryUI

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.main = self

	processor.started_processing.connect(_on_processor_started_processing)
	processor.stopped_processing.connect(_on_processor_stopped_processing)
	processor.hide()

	_inventory_ui.initialize(Global.actor.inventory)

func _input(event: InputEvent) -> void:
	# Activates inputs to the viewport.
	_viewport.push_input(event)

	if event is InputEventKey:
		# Toggle mouse mode between captured and visible.
		if event.pressed and event.keycode == KEY_ESCAPE:
			var captured: bool = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if captured else Input.MOUSE_MODE_CAPTURED
			resting = captured

func _set_resting(value: bool) -> void:
	# Does not change "resting" to false if there is still a process.
	if processor.processing() and value == false: return

	resting = value
	_aim_ui.visible = not resting

	if is_instance_valid(Global.actor):
		Global.actor.controllable = not resting
		Global.actor.interator.enabled = not resting

func _on_processor_started_processing() -> void:
	processor.show()
	resting = true

func _on_processor_stopped_processing() -> void:
	processor.hide()
	resting = false
