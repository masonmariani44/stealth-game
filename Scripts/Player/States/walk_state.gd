extends State

class_name WalkState


@export_range(0.0, 10.0) var SPEED := 5.0





func enter():
	print("Enter walk state")



func physics_update(delta):
	var character = state_machine.get_parent()

	# Add the gravity.
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta * character.GRAVITY_SCALE
		
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

	else:
		state_machine.change_state("IdleState")


	character.move_and_slide()

	
	


func handle_input(_event):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("JumpState")
