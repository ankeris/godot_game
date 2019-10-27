extends Control

func _ready():
	# Called every time the node is added to the scene.
	game_state.connect("connection_failed", self, "_on_connection_failed")
	game_state.connect("connection_succeeded", self, "_on_connection_success")
	game_state.connect("player_list_changed", self, "refresh_lobby")
	game_state.connect("game_ended", self, "_on_game_ended")
	game_state.connect("game_error", self, "_on_game_error")

func _on_host_pressed():
	if (get_node("connect/name").text == ""):
		get_node("connect/error_label").text="Invalid name!"
		return

	get_node("connect").hide()
	get_node("players").show()
	get_node("connect/error_label").text=""

	var player_name = get_node("connect/name").text
	var port = int(get_node("connect/port").value)
	game_state.host_game(port, player_name)
	refresh_lobby()

func _on_join_pressed():
	if (get_node("connect/name").text == ""):
		get_node("connect/error_label").text="Invalid name!"
		return

	var ip = get_node("connect/ip").text
	if (not ip.is_valid_ip_address()):
		get_node("connect/error_label").text="Invalid IPv4 address!"
		return

	var port = int(get_node("connect/port").value)
	if (port == 0):
		get_node("connect/error_label").text="Port cannot be 0!"
		return

	get_node("connect/error_label").text=""
	get_node("connect/host").disabled=true
	get_node("connect/join").disabled=true

	var player_name = get_node("connect/name").text
	game_state.join_game(port, ip, player_name)
	# refresh_lobby() gets called by the player_list_changed signal


func _on_connection_success():
	get_node("connect").hide()
	get_node("players").show()

func _on_connection_failed():
	get_node("connect/host").disabled=false
	get_node("connect/join").disabled=false
	get_node("connect/error_label").set_text("Connection failed.")

func _on_game_ended():
	show()
	get_node("connect").show()
	get_node("players").hide()
	get_node("connect/host").disabled=false
	get_node("connect/join").disabled

func _on_game_error(errtxt):
	get_node("error").dialog_text = errtxt
	get_node("error").popup_centered_minsize()

func refresh_lobby():
	var players = game_state.get_player_list()
	players.sort()
	get_node("players/list").clear()
	get_node("players/list").add_item(game_state.get_player_name() + " (You)")
	for p in players:
		get_node("players/list").add_item(p)

	get_node("players/start").disabled=not get_tree().is_network_server()

func _on_start_pressed():
	game_state.begin_game()

func _on_Quit_pressed():
	#reload a scene
	#var currentScene = get_tree().get_current_scene().get_filename()
	#print(currentScene) # for Debug
	#get_tree().change_scene(currentScene)
	
	game_state.end_game()
	print("end game")
	get_tree().quit()
	