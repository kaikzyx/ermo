class_name PhysicalItem extends RigidBody3D

@export var _item: Item = null

func _ready() -> void:
	assert(_item != null, "Item cannot be null.")

	var interactable: Interactable = find_child(&"Interactable")
	assert(is_instance_valid(interactable), "Interactable not found.")

	interactable.interacted.connect(_on_interactable_interacted)

func _on_interactable_interacted(interactor: Interactor) -> void:
	var node: Node = interactor.owner
	if node is Player: node.inventory.insert(_item)
	queue_free()
