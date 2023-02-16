extends TextureRect

export(Texture) var empty_texture

export var spell = {"id":"fire-spell"}

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("DRAGGABLE")

func drop_data(position:Vector2, data) -> void:
	print("Draggin", data)
	
func get_drag_data(position):
	set_drag_preview(get_preview_control())
	return self

func get_preview_control() -> Control:
	var preview = ColorRect.new()
	preview.rect_size = rect_size
	var preview_color = Color(0,0.2,0.2)
	preview_color.a = 0.5
	preview.color = preview_color
	preview.set_rotation(.05)
	return preview

func _on_item_droped_on_target():
	pass

func can_drop_data(position:Vector2, data) -> bool:
	# print(data)
	var can_drop: bool = data is Node and data.is_in_group("DRAGGABLE")
	return true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
