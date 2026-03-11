extends CharacterBody3D



@onready var cam_pivot: Node3D = $CamPivot
@onready var remote_transform_visuals: Node3D = $RemoteTransform3D_Visuals
@onready var visuals: Node3D = $VisualsCollection/Visuals


@export_range(0.0, 10.0)  var GRAVITY_SCALE := 1.0 	# NOTE: 2.8 feels nice

# Sidle
@export_range(0.0, 1000.0) var WALL_PULL_SPEED := 5.0
var wall_inverse_normal : Vector3