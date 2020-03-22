extends Spatial

var players      = []
var money        = 1000
var bandwidth    = 14.4
var timecop      = Timer.new()

func _ready():
#	timecop.set_wait_time(60)
#	timecop.connect("timeout", self, "_on_timecop_timeout")
#	add_child(timecop)
#	timecop.start()
	$network.start_server()
		
func _input(_event):
	if Input.is_action_just_pressed("ui_end"):
		get_tree().reload_current_scene()

func _on_timecop_timeout():
	for player in players:
		if len(player.connections) == 0:
			if player.delete_tag == false:
				player.delete_tag = true
			else:
				players.erase(player)
				player.queue_free()
