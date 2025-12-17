extends State

class_name IdleState


@export_range(0.0, 10.0) var DECELERATION_SPEED := 5.0



func enter():
    pass


func physics_update(delta):
    var character = state_machine.get_parent()

	# Add the gravity.
    if not character.is_on_floor():
        character.velocity += character.get_gravity() * delta * character.GRAVITY_SCALE

    # Handle deceleration
    character.velocity.x = move_toward(character.velocity.x, 0, DECELERATION_SPEED)
    character.velocity.z = move_toward(character.velocity.z, 0, DECELERATION_SPEED)

    character.move_and_slide()


func handle_input(_event: InputEvent):
    if \
    Input.is_action_pressed("forward") or \
    Input.is_action_pressed("back")    or \
    Input.is_action_pressed("left")    or \
    Input.is_action_pressed("right"):
        state_machine.change_state("WalkState")

    if Input.is_action_just_pressed("jump"):
        state_machine.change_state("JumpState")