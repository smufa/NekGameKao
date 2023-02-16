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




func _on_Server_playerConnected(uuid, col):
	print(uuid, col)
	var instance = player.instance()
	instance.set("uuid", uuid) # TO NE DELAAA
	players[uuid] = instance
	instance.set("my_col", Color(col))
	add_child(instance)

func _on_Server_playerMoved(uuid, pos):
	players[uuid].movement_input = pos
	
