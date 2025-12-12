extends CharacterBody3D



@onready var cam_pivot: Node3D = $CamPivot


@export_range(0.0, 10.0)  var GRAVITY_SCALE := 1.0 	# NOTE: 2.8 feels nice
