extends Node2D


# The port we will listen to
const PORT = 9080
# Our WebSocketServer instance
var _server = WebSocketServer.new()

# signaling

signal playerConnected(uuid)
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
	emit_signal("playerConnected", id)
	

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
		emit_signal("playerMoved", id, Vector2(data.result.x, data.result.y))
		#print(data.result.x)
	# _server.get_peer(id).put_packet(pkt)

func _process(delta):
	# Call this in _process or _physics_process.
	# Data transfer, and signals emission will only happen when calling this function.
	_server.poll()
