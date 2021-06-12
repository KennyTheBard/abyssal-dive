extends Node2D
class_name Gate

signal status_changed(new_status)

onready var logic: Node = $Logic
onready var label: Label = $Label

var input_1: Wire = null
var input_2: Wire = null
var input_3: Wire = null
var input_4: Wire = null

var i1: bool = false
var i2: bool = false
var i3: bool = false
var i4: bool = false

var activated: bool = false setget set_activated


func init():
	if input_1 != null:
		i1 = input_1.activated
		input_1.connect("status_changed", self, "_on_i1_status_changed")
	
	if input_2 != null:
		i2 = input_2.activated
		input_2.connect("status_changed", self, "_on_i2_status_changed")
	
	if input_3 != null:
		i3 = input_3.activated
		input_3.connect("status_changed", self, "_on_i3_status_changed")
	
	if input_4 != null:
		i4 = input_4.activated
		input_4.connect("status_changed", self, "_on_i4_status_changed")
	
	updateLabelColor()


func getFirstFreeInput():
	if input_1 == null:
		return "input_1"
	if input_2 == null:
		return "input_2"
	if input_3 == null:
		return "input_3"
	if input_4 == null:
		return "input_4"
	return null


func updateLabelColor():
	if activated:
		label.add_color_override("font_color", Color.green)
	else:
		label.add_color_override("font_color", Color.red)


func set_activated(new_activated: bool):
	activated = new_activated
	emit_signal("status_changed", activated)
	updateLabelColor()


func _on_i1_status_changed(new_activated):
	i1 = new_activated
	set_activated(logic.apply(i1, i2, i3, i4))


func _on_i2_status_changed(new_activated):
	i2 = new_activated
	set_activated(logic.apply(i1, i2, i3, i4))


func _on_i3_status_changed(new_activated):
	i3 = new_activated
	set_activated(logic.apply(i1, i2, i3, i4))


func _on_i4_status_changed(new_activated):
	i4 = new_activated
	set_activated(logic.apply(i1, i2, i3, i4))
