class_name Main extends CanvasLayer

@onready var interface: Control = $Container/Margin/Screen/Interface
@onready var information: InformationInterface = $Container/Margin/Screen/Interface/InformationInterface
var resting: bool = true

@onready var _viewport: SubViewport = $Container/Margin/Screen/ViewportContainer/Viewport
@onready var _inventory_ui: InventoryUI = $Container/SideBar/Margin/InventoryUI
var _scene_aim_interface: PackedScene = load("res://source/interface/aim_interface.tscn")
var _control_aim_interface: AimInterface = null

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.main = self
	rest(false)

	# Inventory interface.
	_inventory_ui.initialize(Global.actor.inventory)

func _input(event: InputEvent) -> void:
	# Activates inputs to the viewport.
	_viewport.push_input(event)

	if event is InputEventKey:
		# Toggle mouse mode between captured and visible.
		if event.pressed and event.keycode == KEY_ESCAPE:
			var captured: bool = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if captured else Input.MOUSE_MODE_CAPTURED
			rest(captured)

func rest(enable: bool) -> void:
	# Toggle rest mode.
	if resting != enable:
		resting = enable

		if enable:
			# Remove the aim interface when rest.
			if is_instance_valid(_control_aim_interface):
				_control_aim_interface.queue_free()
		else:
			# Create the aim interface when stop rest.
			if _scene_aim_interface.can_instantiate():
				_control_aim_interface = _scene_aim_interface.instantiate()
				interface.add_child(_control_aim_interface)

		if is_instance_valid(Global.actor):
			Global.actor.controllable = not enable
			Global.actor.interator.enabled = not enable
