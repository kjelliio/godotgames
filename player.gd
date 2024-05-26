extends VehicleBody3D

const TOP_SPEED = 100  # Maximum speed limit
const MAX_STEER = 1.5  # Increase steering angle for better agility
const ENGINE_POWER = 500  # Adjusted acceleration value
const BRAKING_FORCE = 25  # Adjust this value for braking force
const FRONT_WEIGHT_RATIO = 0.6  # Adjust the weight distribution toward the front

var SPEED = ENGINE_POWER

@onready var camera_pivot = $Camerapicot
@onready var camera_3d = $Camerapicot/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	# Steering logic
	var steering_input = Input.get_axis("ui_right", "ui_left")
	var max_steer = MAX_STEER * clamp(linear_velocity.length() / TOP_SPEED, 0.5, 1.0)
	steering = move_toward(steering, steering_input * max_steer, delta * 2.5)

	# Apply engine force
	apply_engine_force()

	# Apply braking force to shift weight forward
	var brake_input = Input.is_action_pressed("ui_select")
	if brake_input:
		apply_brake()

	# Camera follow logic
	camera_pivot.global_position = camera_pivot.global_position.lerp(global_position, delta * 20)
	camera_pivot.transform = camera_pivot.transform.interpolate_with(transform, delta * 5.0)

func apply_engine_force():
	engine_force = Input.get_axis("ui_down", "ui_up") * SPEED

func apply_brake():
	var braking_direction = -linear_velocity.normalized()
	var braking_force = braking_direction * BRAKING_FORCE
	apply_central_impulse(braking_force)
