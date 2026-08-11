extends State

class_name Enemy_PatrolState


var current_node := 0





func enter():
	var character = state_machine.get_parent()
	character.nav_target = character.patrol_path_list[current_node]


func physics_update(_delta):

	"""
	Note:
		where to go when coming back here? back to last node attempting to visit? closest node to us?
		closest makes the most senese
		could also switch to a different!!! closer path entirely??? maybe there are unused paths people can swap into?
			prevent multiple people in 1 path (or at least not that many)

	Right now for patrol paths:
		probably just bake them into the level, then set certian enemies to have them
		individual points, get children, loop through list
		next_node = (cur_node + 1) % total_nodes 

	Figure out patrol path
	Start navigating to first node in patrol path
	Walk to there
	Check to see if we're close enough to point
	Arrive there if so
	If node is marked with an "action" (i.e. idle is the only one rn) then do that action (switch to that state)
	once action is completed, move to next patrol point

	during all of this, run detection for the player

	"""


	var character = state_machine.get_parent()

	# TODO: Probably shouldn't update position every update...

	# Velocity towards target
	character.velocity = Vector3.ZERO
	character.nav_agent.set_target_position(character.nav_target.global_position)
	var next_nav_point = character.nav_agent.get_next_path_position()
	character.velocity = (next_nav_point - character.global_position).normalized() * character.WALK_SPEED

	# Rotate to face moving direction
	var direction = character.velocity.normalized()
	var target_rotation := atan2(-direction.x, -direction.z)
	character.rotation.y = lerp_angle(character.rotation.y, target_rotation, 0.1)

	# Check if target reached
	var distance_to_target = (character.nav_target.position - character.position).length()
	if distance_to_target <= .1:
		current_node = (current_node + 1) % character.patrol_path_list.size()
		state_machine.change_state("IdleState")
	


	if character.seen_player:
		character.detection_meter += 0.5
		if character.detection_meter >= 100:
			state_machine.change_state("PursuitState")



	character.move_and_slide()



	pass

