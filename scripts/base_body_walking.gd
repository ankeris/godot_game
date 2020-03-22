extends Spatial
# # # # # # #
# KEEP base_body_walking AS FIRST LEVEL CHILD NODE
# KINEMATICBODY -> !!base_body_walking!! -> and_then_body_object
onready var kinematic_body = get_parent()

var label_name = 'humanoidus'

# HP Health Points
puppet var hp: int = 90
var hp_max: int = 100
puppet var hp_regenerable: int = 100
var hp_regeneration: int = 1
var hp_regeneration_interval: int = 5
signal hp_changed(hp, hp_reg, hp_max)

# Run
puppet var running: bool = false
var run_stamina: float = 5
var run_speed: float = 7.5

# Walk
puppet var walking: bool = false
var walk_speed: float = 5

# Attack
puppet var attacking: bool = false
var attack_speed: float = 1

# Time since latest damage
var time_hit: float = 0

# State
var dead: bool = false
var direction: Vector3 = Vector3()
var velocity: Vector3 = Vector3()
var selected: bool = false

# Other
var interpolation_factor: float = 10  # how fast we interpolate rotations
var previous_origin: Vector3 = Vector3()
const coord = preload("res://scenes/Coordinate.tscn")
onready var navigation = $"../../../Navigation"

# Path finding vars
var path = []
var path_ind = 0
const move_speed = 6
var previous_coord = null
var display_coord_obj = false
onready var dummy_direction = $dummy_direction
var turning_speed = 0.1

func _ready():
	$name_tag/label.text = label_name

func turn_to_smooth(target_direction: Vector3):
	dummy_direction.turn_to(target_direction)

func _process(_delta):
	var from = $body.transform.basis.get_rotation_quat()
	var to = dummy_direction.transform.basis.get_rotation_quat()
	# find halfway point between a and b
	var c = from.slerp(to, turning_speed)
	$body.transform.basis = Basis(c)
	if (not hp == $name_tag/ProgressBar.value):
		$name_tag/ProgressBar.value = hp

func _physics_process(_delta):
	if path_ind < path.size():
		var move_vec = (path[path_ind] - kinematic_body.global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
			# Prevent from breaking - check if index is in scope of array
			if (not path_ind >= path.size()):
				turn_to_smooth(path[path_ind])
		else:
			kinematic_body.move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))

func move_to(target_pos):
	if (kinematic_body.global_transform.origin.distance_to(target_pos) > 1.5):
		path = []
		path = navigation.get_simple_path(kinematic_body.global_transform.origin, target_pos)
		path_ind = 0

		# Add coordinate sign
		if (previous_coord):
			get_parent().remove_child(previous_coord)
		if (display_coord_obj):
			previous_coord = coord.instance()
			previous_coord.transform.origin = target_pos
			get_parent().add_child(previous_coord)
