extends VBoxContainer

export(NodePath) var inventory_holder
onready var node_ref_inventory = get_node(inventory_holder)

export(NodePath) var attacks_holder
onready var node_ref_attack = get_node(attacks_holder)

export var max_inventory_count = 0
var items = []

# Called when the node enters the scene tree for the first time.
func _ready():
	max_inventory_count = node_ref_inventory.get_child_count()
	print(max_inventory_count)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
