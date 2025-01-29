class_name LightSwitch extends Node3D

@export var light_buld: LightBuld
@export var on: bool = true

@onready var _interactable: Interactable = $Interactable

func _ready() -> void:
	turn(true)

	_interactable.interacted.connect(func(_interator: Interator) -> void: turn(not on))

func turn(enable: bool) -> void:
	on = enable
	_interactable.message = &"Turn off." if enable else &"Turn on."

	if is_instance_valid(light_buld):
		light_buld.toggle(enable)
