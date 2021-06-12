extends Node

onready var parent: Gate = get_parent()
onready var area = $Area2D

func _ready():
	area.connect("input_event", self, "_on_Area2D_input_event")


func apply(i1: bool, i2: bool, i3: bool, i4: bool) -> bool:
	return parent.activated


func _on_Area2D_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		parent.activated = not parent.activated
		updateSwitchLabel(parent.activated)


func updateSwitchLabel(activated: bool):
	if activated:
		parent.label.text = "ON"
	else:
		parent.label.text = "OFF"
