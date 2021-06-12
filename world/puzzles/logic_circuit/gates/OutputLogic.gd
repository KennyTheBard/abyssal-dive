extends Node2D

onready var parent: Gate = get_parent()


func apply(i1: bool, i2: bool, i3: bool, i4: bool) -> bool:
	updateOutputLabel(i1);
	return i1


func updateOutputLabel(activated: bool):
	if activated:
		parent.label.text = "OK"
	else:
		parent.label.text = "ZERO"
