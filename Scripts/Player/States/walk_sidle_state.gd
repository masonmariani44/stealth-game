extends State

class_name WalkSidleState


@export_range(0.0, 10.0) var SPEED := 5.0


@export var wall_detect_raycast_forward  : WallDetectionRay
@export var wall_leave_raycast_left      : WallDetectionRay
@export var wall_leave_raycast_right     : WallDetectionRay
@export var wall_leave_raycast_forward   : WallDetectionRay







func enter():
	print("start sidle")
	var character = state_machine.get_parent()
	if wall_detect_raycast_forward.cast() != null:
		character.wall_inverse_normal = -wall_detect_raycast_forward.get_collision_normal()


	# https://kidscancode.org/godot_recipes/3.x/3d/3d_align_surface/
	# good resource for rotation objects to surface normals. it's what i use here

	# perform the rotation they specify then set the rotation's z to 0. the y value should automatically be set to 
	# face the incoming direction, which means we don't neeed to check for an "angle_diff"

	# rotate character to facing direction along wall

	# TODO: Remove this?? unnecessary
	#var angle_diff = character.wall_inverse_normal.signed_angle_to(character.transform.basis.z, Vector3.UP)

	# step 2: if right, rotate character to face wall normal, then +(?) 90 degrees around up vector (-90 if left)
	character.global_transform.basis.y = -character.wall_inverse_normal
	character.global_transform.basis.x = -character.global_transform.basis.z.cross(-character.wall_inverse_normal)
	character.global_transform.basis = character.global_transform.basis.orthonormalized()
	character.rotation.z = 0




func leave_sidle_to(new_state : String):
	var character = state_machine.get_parent()
	character.remote_transform_visuals.update_rotation = true
	character.visuals.rotation = character.rotation
	state_machine.change_state(new_state)



func physics_update(delta):
	var character = state_machine.get_parent()

	character.remote_transform_visuals.update_rotation = false


	# TODO:player should only be able to sidle on wall layer!!! right now it looks like they can sidle on enemies too

	# Add the gravity.
	#if not character.is_on_floor():
	#	character.velocity += character.get_gravity() * delta * character.GRAVITY_SCALE

	"""
	DO NOT add the gravity... yet? 
	add force towards the wall. right now i'm not dynamically getting the closest wall just the OG

	TODO: need to test this when sidling over ledge
	"""


	var angle_diff = character.wall_inverse_normal.signed_angle_to(character.transform.basis.z, Vector3.UP)
	print(character.visuals.rotation)
	if angle_diff > 0:
		pass
		#character.visuals.rotation += 180






		
	# Get the input direction
	var input_dir := Input.get_vector("left", "right", "forward", "back")
	
	# Create movement direction vector rotated in direction of camera
	var direction := Vector3.ZERO
	direction.z = input_dir.y
	direction.x = input_dir.x
	direction = direction.rotated(Vector3.UP, character.cam_pivot.rotation.y)

	if direction:
		# Handle acceleration
		character.velocity.x = direction.x * SPEED
		character.velocity.z = direction.z * SPEED

		# Rotate to face moving direction
		var target_rotation := atan2(-direction.x, -direction.z)
		#TODO: why cant I replace this 0.1 constant with a variable???? with the same value?? casuses spinning...
		
		character.rotation.y = lerp_angle(character.rotation.y, target_rotation, 0.1)






		# TODO: check if right or left raycast are still touching a wall
		if character.is_on_wall():
			if \
			wall_leave_raycast_right.cast()   == null and \
			wall_leave_raycast_left.cast()    == null and \
			wall_leave_raycast_forward.cast() == null:
				leave_sidle_to("WalkState")






	else:
		state_machine.change_state("IdleSidleState")

	

	character.velocity += character.wall_inverse_normal * delta * character.WALL_PULL_SPEED
	character.move_and_slide()

	
	


func handle_input(_event):
	if Input.is_action_just_pressed("jump"):
		leave_sidle_to("JumpState")
