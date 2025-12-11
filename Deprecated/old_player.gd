extends CharacterBody3D


# =============== NODE REFERENCES =============== #

@onready var player: CharacterBody3D = $"."
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var cam_pivot: Node3D = $CamPivot
@onready var spring_arm: SpringArm3D = $CamPivot/SpringArm3D
@onready var camera: Camera3D = $CamPivot/SpringArm3D/Camera3D
@onready var remote_transform: RemoteTransform3D = $RemoteTransform3D
@onready var visuals: Node3D = $Visuals





# =============== CONSTANTS =============== #

@export_range(0.0, 10.0)  var SPEED 				:= 5.0
@export_range(0.0, 20.0)  var JUMP_VELOCITY 		:= 4.5
@export_range(0.0, 0.01)   var SENSITIVITY 			:= 0.01
@export_range(0.0, 200.0)  var TURN_SPEED 			:= 2.0
@export_range(0.0, 10.0)  var GRAVITY_SCALE 		:= 1.0 	# NOTE: 2.8 feels nice
@export_range(-180, 180) var TURN_ANGLE_THRESHOLD 	:= 170





# =============== VARIABLES =============== #

var x_rotation = 0.0










func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# https://www.reddit.com/r/godot/comments/72j6vu/getting_mouse_delta/
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var cam_motion = Vector2(event.relative.x, event.relative.y) * SENSITIVITY
		x_rotation -= cam_motion.y
		x_rotation = clampf(x_rotation, deg_to_rad(-75), deg_to_rad(75))
		#camera.transform.basis = Basis()
		cam_pivot.rotation.y += -cam_motion.x
		cam_pivot.rotation.x = x_rotation
	



func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_SCALE

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	
	var move_direction := Vector3.ZERO
	move_direction.z = input_dir.y
	move_direction.x = input_dir.x
	move_direction = move_direction.rotated(Vector3.UP, cam_pivot.rotation.y)

	#move_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if move_direction:



		# turn character in movement direction. only turn if moving and outside of range

		var angle_diff := angle_difference(
			visuals.rotation.y, 
			Vector3.FORWARD.signed_angle_to(move_direction, Vector3.UP)
		)
	
		

		#angle_diff = wrapf(atan2(move_direction.x, move_direction.z) - visuals.rotation.y, -PI, PI)
		print(rad_to_deg(angle_diff))
		
		#visuals.rotation.y -= clamp(SPEED * delta, 0, abs(angle_diff)) * sign(angle_diff)
		
		if rad_to_deg(angle_diff) < TURN_ANGLE_THRESHOLD:
			""" OLD IMPLEMENTATION. causes character to jitter between steps"""

			rotation.y -= clampf(angle_difference(rotation.y, 
			Vector3.MODEL_FRONT.signed_angle_to(move_direction, Vector3.UP)), 
			-TURN_SPEED * delta, TURN_SPEED * delta)
			print(angle_diff)
	
			""" eh.... another solution...
			var target_rotation = rotation.y - clampf(angle_diff, -TURN_SPEED * delta, TURN_SPEED * delta)

			rotation.y = lerp(rotation.y, target_rotation, abs(.1 * TURN_SPEED * (target_rotation - rotation.y)))
			"""



		velocity.z = move_direction.z * SPEED
		velocity.x = move_direction.x * SPEED
			

	else:
		velocity.z = move_toward(velocity.z, 0, SPEED)
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	

	move_and_slide()
