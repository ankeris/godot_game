extends MeshInstance

onready var dummy_direction = $"../dummy_direction"
onready var TweenNode = $Tween
var speed = 0.2

func _ready():
	pass

func turn_to_smooth(target_direction: Vector3):
	dummy_direction.turn_to(target_direction)


func _physics_process(delta):
	var from = Quat(transform.basis)
	var to = Quat(dummy_direction.transform.basis)
	# find halfway point between a and b
	var c = from.slerp(to, speed)
	transform.basis = Basis(c)