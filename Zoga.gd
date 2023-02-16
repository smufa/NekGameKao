extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal left_goal
signal right_goal

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D2_body_entered(body):
	print("left")
	emit_signal("left_goal")


func _on_Area2D3_body_entered(body):
	print("right")
	emit_signal("right_goal")
