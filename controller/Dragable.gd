extends TextureRect

export(Texture) var empty_texture
export(Texture) var fireball_texture

export(int) var spell_index = 1
	
var spell = {"id":0}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("DRAGGABLE")
	spell.id = spell_index
	update_display()
	
func get_active_texture():
	if(spell.id == 1):
		return fireball_texture
	# if no spells area ctive return empty
	return empty_texture
	
func update_display():
	self.texture = get_active_texture()

func change_spell(index):
	spell.id = index
	update_display()

func drop_data(position:Vector2, data) -> void:
	# fires when data is dropped - RECEIVED
	if("id" in data and data.id != 0):
		spell = data
		print("dropped:", data)
	
func get_drag_data(position):
	set_drag_preview(get_preview_control())
	return spell

func get_preview_control() -> Control:
	# renders a preview rect
	var preview = TextureRect.new()
	preview.rect_size = rect_size
	preview.texture = get_active_texture()
	preview.set_rotation(.1) 
	return preview


func can_drop_data(position:Vector2, data) -> bool:
	# data can be dropped on this item if it is a valid spell
	return "id" in data and data.id != 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
