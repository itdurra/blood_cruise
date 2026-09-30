extends CharacterBody3D

@onready var player_camera: Camera3D = %player_camera

@export var speed: float = 2.0
@export var sprint_mult: float = 2.0
@export var TILT_LOWER_LIMIT: float = deg_to_rad(-90.0)
@export var TILT_UPPER_LIMIT: float = deg_to_rad(90.0)
@export var MOUSE_SENSITIVITY: float = 0.5 

var is_disabled: bool = false
var is_sprinting: bool = false

var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float
var _player_rotation : Vector3
var _camera_rotation : Vector3

func build() -> void:
	#build any services or other variables that we need in this context
	pass

func bind_dependencies() -> void:
	# pass in and bind any dependencies that this context needs from parent
	pass

func setup() -> void:
	# at this point, we have all dependencies resolved, and so we can do any
	# setup that requires those, e.g. connect signals and use factories etc.
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if is_disabled:
		return

	_update_camera(delta)

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Sprint"):
		is_sprinting = true
	
	if Input.is_action_just_released("Sprint"):
		is_sprinting = false

	var input_dir: Vector2 = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#add sprint
	var current_speed: float = speed
	if is_sprinting:
		current_speed *= sprint_mult

	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)

	move_and_slide()

func _unhandled_input(event):
	_mouse_input = event is InputEventMouseMotion
	if _mouse_input :
		_rotation_input = -event.relative.x * MOUSE_SENSITIVITY
		_tilt_input = -event.relative.y * MOUSE_SENSITIVITY

func _update_camera(delta):
	
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, TILT_LOWER_LIMIT, TILT_UPPER_LIMIT)
	_mouse_rotation.y += _rotation_input * delta
	
	_player_rotation = Vector3(0.0,_mouse_rotation.y,0.0)
	_camera_rotation = Vector3(_mouse_rotation.x,0.0,0.0)
	
	player_camera.transform.basis = Basis.from_euler(_camera_rotation)
	player_camera.rotation.z = 0.0
	
	global_transform.basis = Basis.from_euler(_player_rotation)
	
	_rotation_input = 0.0
	_tilt_input = 0.0
	