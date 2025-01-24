class_name Player extends CharacterBody3D

var speed: float = 5.0

@onready var _camera: Camera3D = $Camera
static var _camera_threshold: float = deg_to_rad(70.0)
static var _mouse_sensitivity: float = 0.001

func _physics_process(delta: float) -> void:
	# Movement logic.
	var input: Vector2 = Input.get_vector(&"move_left", &"move_right", &"move_front", &"move_back")
	var movement: Vector3 = Vector3(input.x, 0.0, input.y).rotated(Vector3.UP, rotation.y)
	var goal: Vector3 = velocity.lerp(movement * speed, delta * 10.0)
	velocity = Vector3(goal.x, velocity.y, goal.z)

	# Gravity logic.
	if not is_on_floor():
		velocity.y -= ProjectSettings.get_setting("physics/3d/default_gravity") as float * delta

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		# Fist person camera logic.
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-event.relative.x * _mouse_sensitivity)
			_camera.rotate_x(-event.relative.y * _mouse_sensitivity)
			_camera.rotation.x = clampf(_camera.rotation.x, -_camera_threshold, _camera_threshold)
