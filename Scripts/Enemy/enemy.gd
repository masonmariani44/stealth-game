extends CharacterBody3D


var target = null

@export_range(0.0, 10.0)  var SPEED := 5.0 


@export var temp_target_path : NodePath
@onready var nav_agent = $NavigationAgent3D



func _ready() -> void:
	target = get_node(temp_target_path)

func _physics_process(delta: float) -> void:

	velocity = Vector3.ZERO

	nav_agent.set_target_position(target.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_position).normalized() * SPEED

	# Rotate to face moving direction
	var direction = velocity.normalized()
	var target_rotation := atan2(-direction.x, -direction.z)
	rotation.y = lerp_angle(rotation.y, target_rotation, 0.1)

	move_and_slide()