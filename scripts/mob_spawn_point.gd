extends Position3D
var mob = preload("res://scenes/mob.tscn")
onready var navigation = $"../Navigation"
var radius = 5

func _ready():
	var new_mob = mob.instance()
	var new_mob_2 = mob.instance()
	
	var closest_point = navigation.get_closest_point(transform.origin);
	new_mob.find_node("mob").spawn_point = closest_point
	new_mob.find_node("mob").label_name = 'heroin'
	new_mob_2.find_node("mob").spawn_point = closest_point
	add_child(new_mob)
	add_child(new_mob_2)	
