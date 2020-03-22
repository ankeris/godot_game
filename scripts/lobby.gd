extends Control
const api_url = 'http://localhost:3001'
func _ready():
	# Called every time the node is added to the scene.
	print("IP:", IP.get_local_addresses())
	$HTTP_login.connect("request_completed", self, "_on_request_completed")
#	var http = root.get_node('HTTPRequest')
#	http.request()

func _on_join_pressed():
	# Convert data to json string:
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	var dict = {"username": $"connect/name".text, "password": $"connect/password".text}
	var query = JSON.print(dict)
	$HTTP_login.request(api_url + "/api/account/login", headers, true, HTTPClient.METHOD_POST, query)

func _on_request_completed( result, response_code, headers, body ):
	var body_text = str2var(body.get_string_from_utf8())
	if (response_code == 200):
		print(body_text)
	else:
		print(body_text)
