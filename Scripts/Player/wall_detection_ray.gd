extends RayCast3D

class_name WallDetectionRay


var current_cast



func cast():
	current_cast = get_collider()
	return current_cast