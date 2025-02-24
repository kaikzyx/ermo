class_name Player extends CharacterBody3D

@onready var interactor: Interactor = $Head/Vision/Interactor
@onready var inventory: Inventory = $Inventory
@onready var _head: Node3D = $Head
@onready var _vision: Node3D = $Head/Vision
@onready var _collision: CollisionShape3D = $Collision
@onready var _top_cast: ShapeCast3D = $Head/TopCast
@onready var _mesh: MeshInstance3D = $Mesh

# Movement.
var speed: float = 2.5
var acceleration: float = 7.5
var controllable: bool = true

# Crouch system.
@onready var _standard_height: float = _collision.shape.height
@onready var _standard_radius: float = _collision.shape.radius
@onready var _head_height: float = _standard_height - _mesh.mesh.height
var crouch_speed_factor: float = 0.4
var _crouch_height: float = 0.9
var _crouch_smoothing: float = 7.0

# Camera
static var _mouse_sensitivity: float = 0.001
static var _camera_threshold: float = deg_to_rad(70.0)

func _ready() -> void:
	Global.actor = self

func _physics_process(delta: float) -> void:
	# Movement logic.
	var movement: Vector3 = Vector3.ZERO

	if controllable:
		var input: Vector2 = Input.get_vector(&"left", &"right", &"forward", &"backward")
		movement = Vector3(input.x, 0.0, input.y).rotated(Vector3.UP, rotation.y)

	# Apply speed with crouch modifier.
	var current_speed: float = speed * (crouch_speed_factor if crouching() else 1.0)
	var goal_movement: Vector3 = velocity.lerp(movement * current_speed, acceleration * delta)
	velocity = Vector3(goal_movement.x, velocity.y, goal_movement.z)

	# Crouch logic.
	var goal_height: float = _standard_height

	if Input.is_action_pressed(&"crouch") or (crouching() and _top_cast.is_colliding()):
		goal_height = _crouch_height

	_collision.shape.height = lerp(_collision.shape.height, goal_height, _crouch_smoothing * delta)
	_collision.shape.radius = lerp(_collision.shape.radius, _standard_radius, _crouch_smoothing * delta)
	_collision.position.y = lerp(_collision.position.y, goal_height / 2, _crouch_smoothing * delta)

	var body_height: float = _collision.shape.height - _head_height

	_mesh.mesh.height = body_height
	_mesh.mesh.radius = _collision.shape.radius
	_mesh.position.y = body_height / 2

	# Vision pivot.
	_head.position.y = _collision.shape.height - _head_height / 2

	# Gravity
	if not is_on_floor():
		velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") as float * delta

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if controllable and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * _mouse_sensitivity)
			_vision.rotate_x(-event.relative.y * _mouse_sensitivity)
			_vision.rotation.x = clampf(_vision.rotation.x, -_camera_threshold, _camera_threshold)

func crouching() -> bool:
	return _collision.shape.height < _standard_height - 0.1
