@tool class_name ItemObject extends RigidBody3D

@export var item: Item = null:
	set(value): item = value; _refresh_item()

@onready var _mesh: MeshInstance3D = $Mesh
@onready var _collision: CollisionShape3D = $Collision
@onready var _interactable: Interactable = $Interactable
@onready var _interactable_collision: CollisionShape3D = $Interactable/Collision

func _ready() -> void:
	if not Engine.is_editor_hint():
		_interactable.interacted.connect(_on_interactable_interacted)

	_refresh_item()

func _refresh_item() -> void:
	if not is_node_ready(): return

	if item != null and item.mesh != null:
		var shape: ConvexPolygonShape3D = item.mesh.create_convex_shape()

		# Refresh the item.
		_mesh.mesh = item.mesh
		_collision.shape = shape
		_interactable_collision.shape = shape
	else:
		# Clear.
		_mesh.mesh = null
		_collision.shape = null
		_interactable_collision.shape = null

func _on_interactable_interacted(interator: Interator) -> void:
	var node: Node = interator.owner
	if node is Player: node.inventory.insert(item)

	queue_free()
