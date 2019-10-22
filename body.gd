extends MeshInstance

onready var TweenNode = $Tween

func _ready():
	pass

func _physics_process(delta):
	TweenNode.interpolate_property(self, "transform/rotation", 30, 90, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
