extends Node2D
class_name GateInput

signal activated
signal deactivated

var activated: bool = false setget set_activated

func activate():
	activated = true


func deactivate():
	activated = false


func set_activated(new_activated: bool):
	activated = new_activated
	
	if activated:
		emit_signal("activated")
	else:
		emit_signal("deactivated")
