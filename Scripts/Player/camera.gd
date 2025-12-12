extends Node3D


@export_range(0.0, 90.0)  var SENSITIVITY := 14.0


var x_rotation = 0.0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# https://www.reddit.com/r/godot/comments/72j6vu/getting_mouse_delta/
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# TODO/NOTE: changed this to have deg_to_rad to make the sens numbers bigger. maybe change idk
		var cam_motion = Vector2(deg_to_rad(event.relative.x), deg_to_rad(event.relative.y)) * deg_to_rad(SENSITIVITY)
		x_rotation -= cam_motion.y
		x_rotation = clampf(x_rotation, deg_to_rad(-75), deg_to_rad(75))
		rotation.y += -cam_motion.x
		rotation.x = x_rotation
