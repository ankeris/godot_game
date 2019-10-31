extends Control

func _ready():
	# Called every time the node is added to the scene.
	print("IP:", IP.get_local_addresses())
#	var http = root.get_node('HTTPRequest')
#	http.request()

func _on_join_pressed():
	var http = HTTPClient.new()
	var err = http.connect_to_host("http://localhost", 3001)

	assert(err == OK)

	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		print("Connecting..")
		OS.delay_msec(500)
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)

	var dict = {"username": $"connect/name".text, "password": $"connect/password".text}
	var query = JSON.print(dict)
	http.request(HTTPClient.METHOD_POST, "/api/account/login", ["Content-Type: application/json"], query)
	if (http.has_response()):
		print('hello')

func _on_HTTPRequest_request_completed( result, response_code, headers, body ):
    print(response_code)