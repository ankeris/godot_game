#extends KinematicBody
#
# Declare member variables here. Examples:
#var speed = 6
#var gravity = Vector3.DOWN * 18
#var velocity = Vector3()
#
## Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	velocity += gravity * delta
#	get_input()
#	velocity = move_and_slide(velocity, Vector3.UP)
#

extends KinematicBody

const coord = preload("Coordinate.tscn")
onready var nav = get_parent().get_node("Floor/Navigation")
# Path finding vars
var path = []
var path_ind = 0
const move_speed = 6
var previous_coord = null
var value = 0

func _ready():
	add_to_group("players")

func _physics_process(delta):
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
			# Prevent from breaking - check if index is in scope of array
			if (not path_ind >= path.size()):
				$body.turn_to_smooth(path[path_ind])
		else:
			self.move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			turn_face($body, path[path_ind], delta)

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0

	# Add coordinate sign
	if (previous_coord):
		get_parent().remove_child(previous_coord)
	previous_coord = coord.instance()
	previous_coord.transform.origin = target_pos
	get_parent().add_child(previous_coord)

func turn_face(body, target, delta):
	target.y = body.global_transform.origin.y  #comment this line if want rotation to rotate only all axis
#	# solution was found here: 
#	# https://www.reddit.com/r/godot/comments/8kpxj6/can_anyone_help_me_with_math_3d/dza4ezj/
#	var rotation_speed = 10 # self explanatory
#	var origin_rot = body.rotation
#	body.look_at(target, Vector3(0,1,0))
#	var target_rot = body.rotation
#	var rot_length = target_rot - origin_rot
#	var rot_step = rot_length * rotation_speed * delta
#	body.rotation = origin_rot + rot_step