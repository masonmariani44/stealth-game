extends State

class_name Enemy_PursuitState




func enter():
	var character = state_machine.get_parent()

	character.nav_target = character.seen_player



func physics_update(_delta):


	var character = state_machine.get_parent()

	# TODO: Probably shouldn't update position every update...

	character.velocity = Vector3.ZERO

	character.nav_agent.set_target_position(character.nav_target.global_position)
	var next_nav_point = character.nav_agent.get_next_path_position()
	character.velocity = (next_nav_point - character.global_position).normalized() * character.SPEED

	# Rotate to face moving direction
	var direction = character.velocity.normalized()
	var target_rotation := atan2(-direction.x, -direction.z)
	character.rotation.y = lerp_angle(character.rotation.y, target_rotation, 0.1)

	character.move_and_slide()
