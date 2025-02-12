class_name MainUI extends CanvasLayer

@onready var screen: Control = $Container/Margin/Canvas/Screen
@onready var information: InformationUI = $Container/Margin/Canvas/Screen/InformationUI
var resting: bool = true

@onready var _viewport: SubViewport = $Container/Margin/Canvas/ViewportContainer/Viewport
@onready var _inventory_ui: InventoryUI = $Container/SideBar/Margin/InventoryUI
var _scene_aim_ui: PackedScene = load("res://source/core/aim_ui.tscn")
var _control_aim_ui: AimUI = null

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.main = self
	rest(false)

	# Inventory ui.
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
			# Remove the aim ui when rest.
			if is_instance_valid(_control_aim_ui):
				_control_aim_ui.queue_free()
		else:
			# Create the aim ui when stop rest.
			if _scene_aim_ui.can_instantiate():
				_control_aim_ui = _scene_aim_ui.instantiate()
				screen.add_child(_control_aim_ui)

		if is_instance_valid(Global.actor):
			Global.actor.controllable = not enable
			Global.actor.interator.enabled = not enable
