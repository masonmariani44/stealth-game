extends CharacterBody3D




@export_range(0.0, 10.0)  var SPEED := 5.0 

# TODO: maybe I should make a file for general "rule" values for the game? like falling speeds that way everyone's isn't different but could be?
@export_range(0.0, 10.0)  var GRAVITY_SCALE := 1.0 	# NOTE: 2.8 feels nice


# TODO: maybe change these to names? could just refer to them as references and not care though... depends ig?
@export var player_1 : CharacterBody3D
@export var player_2 : CharacterBody3D


@onready var nav_agent = $NavigationAgent3D
@export var nav_target : Node3D

#@export_range(0.001, 4096.0) var IDLE_WAIT_AMOUNT := 4.0


@export var patrol_path : Node3D
@onready var patrol_path_list = patrol_path.get_children()
