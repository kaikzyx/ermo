class_name Player extends CharacterBody3D

@onready var interator: Interator = $Head/Interator
var speed: float = 2.5
var acceleration: float = 7.5
var controllable: bool = true

@onready var _head: Node3D = $Head
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

	var goal: Vector3 = velocity.lerp(movement * speed, acceleration * delta)
	velocity = Vector3(goal.x, velocity.y, goal.z)

	# Gravity logic.
	if not is_on_floor():
		velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") as float * delta

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		# Fist person camera logic.
		if controllable and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * _mouse_sensitivity)
			_head.rotate_x(-event.relative.y * _mouse_sensitivity)
			_head.rotation.x = clampf(_head.rotation.x, -_camera_threshold, _camera_threshold)
