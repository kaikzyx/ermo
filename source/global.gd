extends Node

var main: Main
var actor: Player

func get_prompt(action: StringName) -> StringName:
	for event in InputMap.action_get_events(action):
		if event is InputEventKey:
			return &"[" + event.as_text_keycode() + &"]"

	return &"<Keycode not found>"
