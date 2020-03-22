extends "res://scripts/base_body_walking.gd"

onready var timer = $"../Timer"
var aggressive = false;
var spawn_point: Vector3
var next_walk_timeout: float = 1
var local_radius = 5

func _ready():
	randomize() # reset the random seed
	kinematic_body.global_transform.origin = spawn_point
	timer.connect("timeout", self, "_on_walking_timeout")
	_on_walking_timeout()

func reset_walking():
	timer.set_wait_time(next_walk_timeout)
	timer.start()

func _on_walking_timeout():
	next_walk_timeout = rand_range(1,11) 
	var next_random_coordinate = spawn_point
	next_random_coordinate.x += rand_range(-local_radius - 1, local_radius + 1)
	next_random_coordinate.z += rand_range(-local_radius - 1, local_radius + 1)
	var normalize = navigation.get_closest_point(next_random_coordinate)
	move_to(normalize)
#	move_to()
	reset_walking()
