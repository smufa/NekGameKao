tool
extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# export var pol: PoolVector2Array = PoolVector2Array()

	
	
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if Engine.editor_hint:
		$LightOccluder2D.occluder.polygon = self.polygon
		$StaticBody2D/CollisionPolygon2D.polygon = self.polygon


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
