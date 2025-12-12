extends State

class_name JumpState


@export_range(0.0, 20.0) var JUMP_VELOCITY := 4.5
@export_range(0.0, 10.0) var SPEED := 5.0


func enter():
    print("Enter jump state")

    var character = state_machine.get_parent()
    character.velocity.y = JUMP_VELOCITY



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
        # Handle deceleration
        character.velocity.x = move_toward(character.velocity.x, 0, SPEED)
        character.velocity.z = move_toward(character.velocity.z, 0, SPEED)


    character.move_and_slide()


    # Change to Idle when grounded
    if character.is_on_floor():
        if direction:
            state_machine.change_state("WalkState")
        else:
            state_machine.change_state("IdleState")