extends KinematicBody

const coord = preload("Coordinate.tscn")
onready var nav = get_parent().get_node("Floor/Navigation")
# Path finding vars
var path = []
var path_ind = 0
const move_speed = 6
var previous_coord = null
onready var player_body_animation = $player_body/human_body/AnimationPlayer

func _ready():
	add_to_group("players")

func _physics_process(_delta):
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
			# Prevent from breaking - check if index is in scope of array
			if (not path_ind >= path.size()):
				$player_body.turn_to_smooth(path[path_ind])
			if (path_ind == path.size()):
				player_body_animation.play("Rest.001")
		else:
			self.move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
			player_body_animation.play("Walk.001")
		
func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0

	# Add coordinate sign
	if (previous_coord):
		get_parent().remove_child(previous_coord)
	previous_coord = coord.instance()
	previous_coord.transform.origin = target_pos
	get_parent().add_child(previous_coord)