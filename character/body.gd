extends MeshInstance

onready var dummy_direction = $"../dummy_direction"
onready var TweenNode = $Tween

func _ready():
	print(dummy_direction.rotation_degrees)

func turn_to_smooth(target_direction: Vector3):
	dummy_direction.turn_to(target_direction)
	var from = rotation_degrees
	var to = dummy_direction.rotation_degrees
	var oposite_point = null
	print(dummy_direction.rotation_degrees)
	TweenNode.interpolate_property(
		self, 
		"rotation_degrees",
		from,
		to,
		0.1,
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN_OUT
	)
	
	# find oposite point for calculations
#	if (is_negative(from.y)): 
#		oposite_point = 180 + from.y
#		# find fastest travel distance
#		if (oposite_point < to.y):
#			rotation_degrees = to
#		else:
#			TweenNode.start()
#	else: 
#		oposite_point = - 180 + from.y
#		# find fastest travel distance
#		if (oposite_point > to.y):
#			rotation_degrees = to
#		else:
#			TweenNode.start()

func is_negative(num: float):
	return num < 0