extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var from = transform.origin
onready var to = transform.origin + Vector3(0, 1, 0)
var t = 0
var go_forward = true

func _physics_process(delta):
	t += delta * 0.4
	if (go_forward):
		transform.origin = lerp(from, to, t)
		if (transform.origin > to):
			go_forward = false
			t = 0
	if (not go_forward):
		transform.origin = lerp(to, from, t)
		if (transform.origin < from):
			go_forward = true
			t = 0
	rotate_y(0.006)
