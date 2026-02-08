extends State

class_name WalkSidleState


@export_range(0.0, 10.0) var SPEED := 5.0
@export var wall_raycast : WallDetectionRay







func enter():
	var character = state_machine.get_parent()
	print("enter walk sidle state!")
	if wall_raycast.cast() != null:
		character.wall_inverse_normal = -wall_raycast.get_collision_normal()
	print(character.wall_inverse_normal)

	"""

	TODO:
		- upon entering this state, player should rotate to face the correct way 
		(probably the way the're currently facing)

		- now the sidling can start



	"""



func physics_update(delta):
	var character = state_machine.get_parent()


	"""

	TODO:
		- now with sidling set up we can start moving the player along the wall
		- this can be achived by walking like normal, but applying a massive gravity vector towards the wall they're touching
		- find closest wall to player
			- shoot raycast out of right side of body, get normal of the surface
			- apply force in inverse of that vector
		- apply force
		- if range exceeded, leave sidle 
		- TODO: this "range exceeded" needs thinking about. 

		- NOTE:
			the wall detection should have NOTHING To do with the visuals. use internal
			camera / position / rotation info for that
			- ex. player turns around mid sidle. visuals change, sidle shouldnt end

	THIS IS WORKING!!!
	sorta...
	its kinda a mess, but the idea is there. just need to worry about ending the state now and
	cleaning up the code a bit
	

	"""

	# Add the gravity.
	#if not character.is_on_floor():
	#	character.velocity += character.get_gravity() * delta * character.GRAVITY_SCALE

	"""
	DO NOT add the gravity... yet? 
	add force towards the wall. right now i'm not dynamically getting the closest wall just the OG
	"""
	
		
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




		# !!!!!!!!! SIDLE CHANGES!!!!!!!!! 



		# Check if sidle condition is met
		# TODO: implement sidle states and transition here
		#if character.is_on_wall():
		#	if wall_raycast.cast() == null:
		#		print("no")
		#	else:
		#		print("yes!!")



		# !!!! end sidle !!!!!!
		



	else:
		state_machine.change_state("IdleSidleState")

	character.velocity += character.wall_inverse_normal * delta * character.WALL_PULL_SPEED
	character.move_and_slide()

	
	


func handle_input(_event):
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("JumpState")
