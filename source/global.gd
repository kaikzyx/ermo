extends Node

var main: Main = null
var actor: Player = null

func get_prompt(action: StringName) -> StringName:
	for event in InputMap.action_get_events(action):
		return &"[" + event.as_text() + &"]"

	return &"<Keycode not found>"
