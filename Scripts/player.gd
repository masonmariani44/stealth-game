extends CharacterBody3D

# =============== NODE REFERENCES =============== #

@onready var player: CharacterBody3D = $"."
@onready var cam_pivot: Node3D = $CamPivot
@onready var visuals: Node3D = $Visuals





# =============== CONSTANTS =============== #

@export_range(0.0, 10.0)  var SPEED 				:= 5.0
@export_range(0.0, 20.0)  var JUMP_VELOCITY 		:= 4.5
@export_range(0.0, 90.0)  var SENSITIVITY 			:= 14.0
@export_range(0.0, 1.0)   var TURN_SPEED 			:= 0.1  # TODO: when i replace lerp rotate value with this causes spinning...
@export_range(0.0, 10.0)  var GRAVITY_SCALE 		:= 1.0 	# NOTE: 2.8 feels nice



var x_rotation = 0.0





func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# https://www.reddit.com/r/godot/comments/72j6vu/getting_mouse_delta/
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# TODO/NOTE: changed this to have deg_to_rad to make the sens numbers bigger. maybe change idk
		var cam_motion = Vector2(deg_to_rad(event.relative.x), deg_to_rad(event.relative.y)) * deg_to_rad(SENSITIVITY)
		x_rotation -= cam_motion.y
		x_rotation = clampf(x_rotation, deg_to_rad(-75), deg_to_rad(75))
		cam_pivot.rotation.y += -cam_motion.x
		cam_pivot.rotation.x = x_rotation






func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_SCALE

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction
	var input_dir := Input.get_vector("left", "right", "forward", "back")

	# Create movement direction vector rotated in direction of camera
	var direction := Vector3.ZERO
	direction.z = input_dir.y
	direction.x = input_dir.x
	direction = direction.rotated(Vector3.UP, cam_pivot.rotation.y)

	if direction:
		# Handle acceleration
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED

		# Rotate to face moving direction
		var target_rotation:float = atan2(-direction.x, -direction.z)
		#TODO: why cant I replace this 0.1 constant with a variable???? with the same value?? casuses spinning...
		rotation.y = lerp_angle(rotation.y, target_rotation, 0.1)

	else:
		# Handle deceleration
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)


	move_and_slide()



	
