extends Position3D
onready var name_tag = $"../name_tag"

func _process(delta):
	var pos = global_transform.origin
	var cam = get_tree().get_root().get_camera()
	var screenpos = cam.unproject_position(pos)
	name_tag.set_position(Vector2(screenpos.x , screenpos.y))
