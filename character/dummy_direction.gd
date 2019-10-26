extends MeshInstance

func turn_to(target_position: Vector3):
	look_at(target_position, Vector3.UP)
