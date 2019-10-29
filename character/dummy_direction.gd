extends MeshInstance

# this is used to control where object turns
func turn_to(target_position: Vector3):
	look_at(target_position, Vector3.UP)
