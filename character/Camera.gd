extends Camera

const ray_length = 1000
onready var label = $"../target_label"
var mouse_is_on_mob: bool

func _ready():
	pass

func _input(event):
	var from = project_ray_origin(event.position)
	var to = from + project_ray_normal(event.position) * ray_length
	var space_state = get_world().direct_space_state
	var result = space_state.intersect_ray(from, to, [], 1)
	var whos_there = get_object_under_mouse(from, to, space_state)
	# handle click
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		if (whos_there and whos_there.collider.find_node('mob')):
			var mob_info = whos_there.collider.find_node('mob')
			label.visible = true
			label.find_node("target_name").text = mob_info.label_name
		elif result:
			label.visible = false
			get_parent().move_to(result.position)
	# handle hover
	if (whos_there and whos_there.collider.find_node('mob') and not mouse_is_on_mob):
		mouse_is_on_mob = true
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	elif (whos_there and not whos_there.collider.find_node('mob') and mouse_is_on_mob):
		mouse_is_on_mob = false
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
func get_object_under_mouse(ray_from, ray_to, space_state):
	return space_state.intersect_ray(ray_from, ray_to)
	
