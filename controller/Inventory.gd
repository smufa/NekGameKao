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
	for i in len(children):
		if(i >= len(spells)):
			break
		if (children[i] is BoxContainer):
			children[i].get_child().color = Color(0,0,1)

func can_drop_data(position:Vector2, data) -> bool:
	# print(data)
	var can_drop: bool = data is Node and data.is_in_group("DRAGGABLE")
	return true

func drop_data(position:Vector2, data) -> void:
	if(len(spells) < max_items - 1):
		spells.append(data)
		for spell in spells:
			print(spell)
		print("Allow dropz")
	else:
		print("dont allow dropz")
	update_children()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
