class_name Requestable extends Interaction

@export var item: Item = null
@export var message_has: StringName = &""
@export var message_not_has: StringName = &""

func interact(interator: Interator) -> bool:
	if item != null:
		var node: Node = interator.owner

		if node is Player:
			var index: int = node.inventory.request(item)

			if index != -1:
				node.inventory.remove(index)
				Global.main.messages.sent(message_has)
				return true

	Global.main.messages.sent(message_not_has)
	return false

func life() -> bool:
	return false
