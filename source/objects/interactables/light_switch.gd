class_name LightSwitch extends Interactable

@export var light_buld: LightBuld

func _ready() -> void:
	interacted.connect(func(_interator: Interator) -> void:
		if is_instance_valid(light_buld):
			light_buld.toggle(not light_buld.on))
