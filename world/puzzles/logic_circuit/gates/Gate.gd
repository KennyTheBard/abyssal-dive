extends Node2D
class_name Gate

signal status_changed(new_status)

export (NodePath) var input_1_path
var input_1: Wire = null

export (NodePath) var input_2_path
var input_2: Wire = null

export (NodePath) var input_3_path
var input_3: Wire = null

export (NodePath) var input_4_path
var input_4: Wire = null

onready var logic: Node = $Logic
onready var label: Label = $Label

var i1: bool = false
var i2: bool = false
var i3: bool = false
var i4: bool = false

var activated: bool = false setget set_activated


func _ready():
	if has_node(input_1_path):
		input_1 = get_node(input_1_path)
		i1 = input_1.activated
		input_1.connect("status_changed", self, "_on_i1_status_changed")
	
	if has_node(input_2_path):
		input_2 = get_node(input_2_path)
		i2 = input_2.activated
		input_2.connect("status_changed", self, "_on_i2_status_changed")
	
	if has_node(input_3_path):
		input_3 = get_node(input_3_path)
		i3 = input_3.activated
		input_3.connect("status_changed", self, "_on_i3_status_changed")
	
	if has_node(input_4_path):
		input_4 = get_node(input_4_path)
		i4 = input_4.activated
		input_4.connect("status_changed", self, "_on_i4_status_changed")
	
	updateLabelColor()


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
