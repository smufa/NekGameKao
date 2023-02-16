extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var max_items = 6
var spells = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func update_children():
	var children = get_children()
	var clean_c = []
	for c in children:
		if(c is VBoxContainer):
			clean_c.append_array(c.get_children())
		if(c is ColorRect):
			clean_c.append(c)
		if(c is BoxContainer):
			clean_c.append(c.get_child())
	print("len of atacks:", len(clean_c))
	
	for i in len(clean_c):
		if(i >= len(spells)):
			break
		clean_c[i] = Color(0,0,1)

func can_drop_data(position:Vector2, data) -> bool:
	var can_drop: bool = data is Node and data.is_in_group("DRAGGABLE")
	print("Can drop: ", can_drop)
	return true

func drop_data(position:Vector2, data) -> void:
	#print(data)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
