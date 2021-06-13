extends Node

onready var parent: Gate = get_parent()


func _ready():
	$TextureButton.connect("pressed", self, "_on_TextureButton_pressed")


func apply(i1: bool, i2: bool, i3: bool, i4: bool) -> bool:
	return parent.activated


func _on_TextureButton_pressed():
	parent.activated = not parent.activated
	updateSwitchLabel(parent.activated)


func updateSwitchLabel(activated: bool):
	if activated:
		parent.label.text = "ON"
	else:
		parent.label.text = "OFF"
