extends KinematicBody

const coord = preload("res://scenes/Coordinate.tscn")
onready var nav = $"../../Floor/Navigation"
onready var player_body_animation = $player_body/human_body/AnimationPlayer
puppet var previous_coord = null
const move_speed = 6
var current_name = null;

# Path finding vars
puppet var slave_pos = Vector3()
puppet var slave_path = []
puppet var slave_path_index = 0

var path_idx = 0
var path = []

var move_vec = Vector3()
#slave func set_animation(pos):
#  player_body_animation.play("Walk.001")

func set_player_name(new_name):
	current_name = new_name
	$"name_tag/label".set_text(new_name)

func _ready():
	slave_pos = self.get_translation()
	if (is_network_master()):
		$Camera.make_current()
		print(current_name)

func _physics_process(_delta):
	var is_network_master = is_network_master()
	
	# (NETWORK): what you see about yourself
	if is_network_master:
		if path_idx < path.size():
			move_vec = (path[path_idx] - global_transform.origin)
			if move_vec.length() < 0.1:
				path_idx += 1
				rset("slave_path_index", path_idx)
				# Prevent from breaking - check if index is in scope of array
				if (not path_idx >= path.size()):
					$player_body.turn_to_smooth(path[path_idx])
				if (path_idx == path.size()):
					player_body_animation.play("Rest.001")
				else:
					player_body_animation.play("Walk.001")
			else:
				move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))
				rset("slave_pos", get_translation())
	# (NETWORK): what you see about others
	else:
		global_transform.origin = slave_pos
#		print(str(slave_path_index) + ' ' + str(slave_path.size()))
		if (slave_path_index < slave_path.size()):
			player_body_animation.play("Walk.001")
		elif (slave_path_index == slave_path.size()):
			player_body_animation.play("Rest.001")

func move_to(target_pos):
	path = []
	path = nav.get_simple_path(global_transform.origin, target_pos)
	rset("slave_path", path)
	path_idx = 0

	# Add coordinate sign
	if (is_network_master()):
		if (previous_coord):
			get_parent().remove_child(previous_coord)
		previous_coord = coord.instance()
		previous_coord.transform.origin = target_pos
		get_parent().add_child(previous_coord)