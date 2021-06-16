extends Node2D


func _ready():
	hide_all()


func hide_all():
	for c in get_children():
		c.visible = false


func display_content(node_name: String):
	hide_all()
	get_node(node_name).visible = true
