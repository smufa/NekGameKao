extends Node


# Declare member variables here. Examples:
var left: int
var right: int

var ball_spawn: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	left = 0
	right = 0
	print("0:0")
	ball_spawn = $BallSpawn.transform.get_origin()


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_Zoga_left_goal():
	left += 1
	$MarginContainer/HBoxContainer/HBoxContainer/Score1.text = str(left)
	print(left, ":", right)
	$Zoga.position = ball_spawn


func _on_Zoga_right_goal():
	right += 1
	$MarginContainer/HBoxContainer/HBoxContainer2/Score2.text = str(right)
	print(left, ":", right)
	$Zoga.position = ball_spawn
	
