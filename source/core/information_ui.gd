class_name InformationUI extends Control

enum Information { MESSAGE, ITEM }

@onready var _messages_informations_container: VBoxContainer = $Informations/MessagesInformationsContainer
@onready var _item_informations_container: VBoxContainer = $Informations/ItemInformationsContainer

func sent(message: StringName, type: Information) -> void:
	# shows a message for a while and then erases it.
	if message.is_empty(): return

	var label: Label = Label.new()
	label.text = message

	match type:
		Information.MESSAGE:
			_messages_informations_container.add_child(label)
		Information.ITEM:
			_item_informations_container.add_child(label)

	await get_tree().create_timer(1).timeout
	label.queue_free()
