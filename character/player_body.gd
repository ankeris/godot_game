extends Spatial

onready var dummy_direction = $"../dummy_direction"
var speed = 0.1

func turn_to_smooth(target_direction: Vector3):
	dummy_direction.turn_to(target_direction)

func _process(_delta):
	var from = transform.basis.get_rotation_quat()
	var to = dummy_direction.transform.basis.get_rotation_quat()
	# find halfway point between a and b
	var c = from.slerp(to, speed)
	transform.basis = Basis(c)
	pass