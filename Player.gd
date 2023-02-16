extends RigidBody2D


# Declare member variables here. Examples:
export var speed = 10
export var uuid = ""
export var my_col = Color(1,0,0,1)
export(float) var mu_static = 0.8  # friction coefficients
export(float) var mu_moving = 0.5  # pushing something moving is easier

var movement_input: Vector2

#var screen_size
var velocity: Vector2 = Vector2.ZERO




# Called when the node enters the scene tree for the first time.
func _ready():
	#screen_size = get_viewport_rect().size
	var col = Color(my_col)
	print("color ", col)
	print("uuid ", uuid)
	$Light2D.set_color(col) # solved ne tikaj prosim ej te prosim
	#$Sprite..(col)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#var acceleration = movement_input * speed + -0.5 * velocity * velocity * Vector2(0.6, 0.6)
	#velocity += acceleration * delta
	
		
	#if velocity.length() > 0:
	#	velocity = velocity.normalized() * speed
	#	$AnimatedSprite.play()
	#else:
	#	$AnimatedSprite.stop()
		
	
	self.apply_central_impulse(movement_input * speed)
	
	#print("accel", acceleration)
	#print(velocity)

