extends State

class_name Enemy_IdleState


@export_range(0.0, 10.0) var DECELERATION_SPEED := 5.0


var seen_player : CharacterBody3D


func enter():
	$IdleWaitTimer.start()


func physics_update(delta):

	"""

	Stand here for a little bit, then decide to start walking along a patrol path

	Still check for player, maybe move a little or suffle or animate a bit

	

	"""
	
	var character = state_machine.get_parent()

	# Add the gravity.
	if not character.is_on_floor():
		character.velocity += character.get_gravity() * delta * character.GRAVITY_SCALE

	# Handle deceleration
	character.velocity.x = move_toward(character.velocity.x, 0, DECELERATION_SPEED)
	character.velocity.z = move_toward(character.velocity.z, 0, DECELERATION_SPEED)

	character.move_and_slide()



func _on_idle_wait_timer_timeout() -> void:
	state_machine.change_state("PatrolState")


func _on_vision(body:Node3D) -> void:
	if body.is_in_group("player"):
		seen_player = body
	


func _on_vision_exit(body:Node3D) -> void:
	if body.is_in_group("player"):
		seen_player = null
