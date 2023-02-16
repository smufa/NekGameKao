extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# visible variables
export var connected = false
export var player_col = Color(1,0,0,1)

# UI elements
var button = null
var indicator = null
var input = null
var test = null
var nipple = null
var nipple_center: Vector2
var player_color_rect = null

# joystick
var joystick_active = false
var texture_fix: Vector2  = Vector2(0,0)

# websocket conn
var _client = WebSocketClient.new()

# output
var one_direction: Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	# get button on click
	button = $VBoxContainer/MarginContainer/HBoxContainer/Button
	indicator = $VBoxContainer/MarginContainer/HBoxContainer/Indicator
	input = $VBoxContainer/MarginContainer/HBoxContainer/TextEdit
	nipple = $VBoxContainer/mainLeft/MarginContainer/CenterContainer2/nipple
	player_color_rect = $VBoxContainer/PlayerColorRect
	
	nipple_center = nipple.get_global_position()
	
	# handle button on click	
	button.connect("pressed", self, "_button_pressed")
	
	# Connect base signals to get notified of connection open, close, and errors.
	_client.connect("data_received", self, "_on_msg_receive")
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		if(nipple.is_pressed()):
			var new_position = event.position + Vector2(-35,-35)
			var move_vec: Vector2 = new_position - nipple_center
			if move_vec.length() > 100:
				move_vec = move_vec.normalized() * 100
			nipple.set_global_position(nipple_center + move_vec)
			one_direction=move_vec/100
			
		else:
			nipple.set_global_position(nipple_center)
			one_direction.x = 0
			one_direction.y = 0
			
func _physics_process(delta):
	#var packet: PoolByteArray = JSON.print("{'x':1,'y':2}").to_utf8()
	#print("Sending packet ", packet.get_string_from_utf8())
	var data ={
		"x":one_direction.x,
		"y":one_direction.y
	}
	var packet: PoolByteArray = JSON.print(data).to_utf8()
	if(connected):
		pass
		_client.get_peer(1).put_packet(packet)

func calculate_move_vec(event_position: Vector2):
	var texture_center = nipple.get_global_position() + Vector2(-35,-35)
	return(event_position - texture_center).normalized()
	
func _button_pressed():
	print("clicked")
	indicator.color = Color(0,0,1,1)
	
	# Initiate connection to the given URL.
	var host = input.get_text()
	var err = _client.connect_to_url("ws://"+ host +":9080")
	if err != OK:
		print("Unable to connect")
		set_process(false)
		indicator.color = Color(1,0,0,1)
		button.set_text("Connect")
	else:
		connected = true

func _closed(was_clean = false):
	# was_clean will tell you if the disconnection was correctly notified
	# by the remote peer before closing the socket.
	print("Closed, clean: ", was_clean)
	set_process(false)
	indicator.color = Color(1,0,0,1)
	button.set_text("Connect")	

func _connected(proto = ""):
	# This is called on connection, "proto" will be the selected WebSocket
	# sub-protocol (which is optional)
	print("Connected with protocol: ", proto)
	indicator.color = Color(0,1,0,1)
	button.set_text("Disconnect")
	connected = true
	
	var packet: PoolByteArray = JSON.print({"hey":1}).to_utf8()
	_client.get_peer(1).set_write_mode(WebSocketPeer.WRITE_MODE_BINARY)
	_client.get_peer(1).put_packet(packet)
	
func _on_msg_receive():
	print("ondata")
	# Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
	# and not get_packet directly when not using the MultiplayerAPI.
	var pkt = _client.get_peer(1).get_packet()
	# _client.get_peer(id).put_packet(pkt)
	var data = JSON.parse(pkt.get_string_from_utf8())
	if(data.error != OK):
		print("nije uredu")
	else:
		if ("color" in data.result):
			print("colorset")
			player_color_rect.color = Color(data.result.color)
			print(player_color_rect.color)
	
func _process(delta):
	# Call this in _process or _physics_process. Data transfer, and signals
	# emission will only happen when calling this function.
	_client.poll()
