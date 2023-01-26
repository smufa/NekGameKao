extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (PackedScene) var player
var players = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Server_playerConnected(uuid):
	print("naj bi biu plajer")
	var instance = player.instance()
	add_child(instance)
	instance.uuid = uuid
	players[uuid] = instance

func _on_Server_playerMoved(uuid, pos):
	# print("premik")
	players[uuid].movement_input = pos
