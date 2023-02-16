extends Node2D


# The port we will listen to
const PORT = 9080
# Our WebSocketServer instance
var _server = WebSocketServer.new()

var colors = [
	Color("#f87171"),
	Color("#fb923c"),
	Color("#f59e0b"),
	Color("#84cc16"),
	Color("#0d9488"),
	Color("#0ea5e9"),
	Color("#8b5cf6"),
	Color("#d946ef")
	]

# signaling

signal playerConnected(uuid, col)
signal playerMoved(uuid, pos)

func _ready():
	_server.connect("client_connected", self, "_connected")
	_server.connect("client_disconnected", self, "_disconnected")
	_server.connect("client_close_request", self, "_close_request")
	_server.connect("data_received", self, "_on_data")
	
	# Start listening on the given port.
	var err = _server.listen(PORT)
	if err != OK:
		print("Unable to start server")
		set_process(false)
	else:
		print("Listening on port:", PORT)

func _connected(id, proto):
	# This is called when a new peer connects, "id" will be the assigned peer id,
	# "proto" will be the selected WebSocket sub-protocol (which is optional)
	print("Client %d connected with protocol: %s" % [id, proto])
	# generate new color
	var index = (int(id)* 3)%len(colors)
	var playerCol:Color = colors[index]
	var playerColHex = playerCol.to_html(false)
	
	# emit new player signal
	emit_signal("playerConnected", id, playerColHex)
	
	# send player color back
	var data ={
		"color": playerColHex,
	}
	var packet: PoolByteArray = JSON.print(data).to_utf8()
	_server.get_peer(id).put_packet(packet)

func _close_request(id, code, reason):
	# This is called when a client notifies that it wishes to close the connection,
	# providing a reason string and close code.
	print("Client %d disconnecting with code: %d, reason: %s" % [id, code, reason])

func _disconnected(id, was_clean = false):
	# This is called when a client disconnects, "id" will be the one of the
	# disconnecting client, "was_clean" will tell you if the disconnection
	# was correctly notified by the remote peer before closing the socket.
	print("Client %d disconnected, clean: %s" % [id, str(was_clean)])

func _on_data(id):
	# Print the received packet, you MUST always use get_peer(id).get_packet to receive data,
	# and not get_packet directly when not using the MultiplayerAPI.
	var pkt = _server.get_peer(id).get_packet()
	#print("Got data from client %d: %s " % [id, pkt.get_string_from_utf8()])
	var data = JSON.parse(pkt.get_string_from_utf8())
	if(data.error != OK):
		print("nije uredu")
	else:
		if("x" in data.result):
			emit_signal("playerMoved", id, Vector2(data.result.x, data.result.y))
		else:
			if("hey" in data.result):
				var index = int(id)%len(colors)
				var playerCol:Color = colors[index]
				var pck = {
					"color": playerCol.to_html(false),
				}
				var packet: PoolByteArray = JSON.print(pck).to_utf8()
				print("sending to: ", _server.get_peer(id))
				_server.get_peer(id).set_write_mode(WebSocketPeer.WRITE_MODE_TEXT)
				_server.get_peer(id).put_packet(packet)
			

func _process(delta):
	# Call this in _process or _physics_process.
	# Data transfer, and signals emission will only happen when calling this function.
	_server.poll()


func _on_Area2D2_body_entered(body):
	pass # Replace with function body.
