extends Node2D

onready var parent: Gate = get_parent()
onready var area = $Area2D


func _ready():
	area.connect("input_event", self, "_on_Area2D_input_event")


func _on_Area2D_input_event(viewport, event, shape_idx ):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		parent.activated != parent.activated
