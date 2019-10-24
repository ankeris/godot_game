extends MeshInstance

func _ready():
	pass

	# look_at(dummy_position, Vector3.UP);
	# Such a long winded discussion for such a simple thing. 
	# Just have an invisible dummy object with same position as main object, 
	# run look_at on the dummy_object, and then Tween main object rotation
	# to the rotation of the dummy object. Full control this way.

func turn_to(target_position: Vector3):
	look_at(target_position, Vector3.UP)
